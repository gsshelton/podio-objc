//
//  PKAPIRequest.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 2011-07-01.
//  Copyright 2011 Podio. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString * PKAPIRequestMethod;

extern PKAPIRequestMethod const PKAPIRequestMethodGET;
extern PKAPIRequestMethod const PKAPIRequestMethodPOST;
extern PKAPIRequestMethod const PKAPIRequestMethodPUT;
extern PKAPIRequestMethod const PKAPIRequestMethodDELETE;

@interface PKAPIRequest : NSObject {

 @protected
  NSString *path_;
  PKAPIRequestMethod method_;
  NSMutableDictionary *getParameters_;
  NSMutableDictionary *postParameters_;
  BOOL authenticated_;
}

@property (nonatomic, copy) NSString *path;
@property (nonatomic, readonly) NSMutableDictionary *getParameters;
@property (nonatomic, readonly) NSMutableDictionary *postParameters;
@property BOOL authenticated;

- (id)initWithPath:(NSString *)path method:(PKAPIRequestMethod)method;

+ (id)requestWithPath:(NSString *)path method:(PKAPIRequestMethod)method;

@end