//
//  PKHTTPRequestOperation.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 11/30/12.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "PKHTTPRequestOperation.h"
#import "PKObjectMapper.h"
#import "NSDictionary+PKAdditions.h"

NSString * const PKHTTPRequestOperationFinished = @"PKHTTPRequestOperationFinished";
NSString * const PKHTTPRequestOperationFailed = @"PKHTTPRequestOperationFailed";

NSString * const PKHTTPRequestOperationKey = @"Request";

@interface PKHTTPRequestOperation ()

@property (nonatomic, copy, readonly) PKRequestCompletionBlock requestCompletionBlock;
@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation PKHTTPRequestOperation

+ (PKHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request completion:(PKRequestCompletionBlock)completion {
  PKHTTPRequestOperation *operation = [[self alloc] initWithRequest:request];
  [operation setRequestCompletionBlock:completion];
  
  return operation;
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
  return YES;
}

#pragma mark - Impl

- (void)setRequestCompletionBlock:(PKRequestCompletionBlock)requestCompletionBlock {
  _requestCompletionBlock = [requestCompletionBlock copy];
  
  // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
  self.completionBlock = ^{
    if ([self isCancelled]) {
      [self completeWithResult:nil error:[NSError pk_requestCancelledError]];
      return;
    }
    
    id parsedData = nil;
    id resultData = nil;
    id objectData = nil;
    NSError *error = nil;
    
    if ([self.responseData length] > 0) {
      NSError *parseError = nil;
      parsedData = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&parseError];
      
      if (parseError) {
        PKLogError(@"Failed to parse response data: %@, %@", parseError, [parseError userInfo]);
      }
    }
    
    if (!self.error) {
      PKLogDebug(@"Request finished with status code: %d", self.response.statusCode);
      
      if (self.response.statusCode >= 200 && self.response.statusCode <= 206) {
        if (self.response.statusCode != 204 && parsedData) {
          objectData = parsedData;
          if (self.objectDataPathComponents != nil) {
            objectData = [parsedData pk_objectForPathComponents:self.objectDataPathComponents];
          }
          
          // Should map response?
          if (self.objectMapper != nil) {
            @autoreleasepool {
              resultData = [self.objectMapper performMappingWithData:objectData];
            }
          }
        }
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{PKHTTPRequestOperationKey: self};
        [[NSNotificationCenter defaultCenter] postNotificationName:PKHTTPRequestOperationFinished object:self userInfo:userInfo];
      });
    } else {
      if (self.response.statusCode > 0) {
        // Failed on server side
        PKLogDebug(@"Request failed with body: %@", self.responseString);
        error = [NSError pk_serverErrorWithStatusCode:self.response.statusCode parsedData:parsedData];
      } else {
        error = self.error;
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{PKHTTPRequestOperationKey: self};
        [[NSNotificationCenter defaultCenter] postNotificationName:PKHTTPRequestOperationFailed object:self userInfo:userInfo];
      });
    }
    
    PKRequestResult *result = [PKRequestResult resultWithResponseStatusCode:self.response.statusCode
                                                               responseData:self.responseData
                                                                 parsedData:parsedData
                                                                 objectData:objectData
                                                                 resultData:resultData];
    
    [self completeWithResult:result error:error];
  };
#pragma clang diagnostic pop
}

- (void)completeWithResult:(PKRequestResult *)result error:(NSError *)error {
  if (self.requestCompletionBlock) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.requestCompletionBlock(error, result);
    });
  }
}

- (void)setValue:(NSString *)value forHeader:(NSString *)header {
  NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
  [mutableRequest setValue:value forHTTPHeaderField:header];
  self.request = mutableRequest;
}

@end
