//
//  POAPIClient.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 2011-07-01.
//  Copyright 2011 Podio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "PKAPIRequest.h"
#import "PKRequestOperation.h"
#import "PKFileOperation.h"
#import "PKOAuth2Client.h"


extern NSString * const POAPIClientWillBeginAuthentication;
extern NSString * const POAPIClientDidFinishAuthentication;

extern NSString * const POAPIClientWillBeginReauthentication;
extern NSString * const POAPIClientDidFinishReauthentication;

extern NSString * const POAPIClientDidAuthenticateUser;
extern NSString * const POAPIClientAuthenticationFailed;
extern NSString * const POAPIClientReauthenticationFailed;

extern NSString * const POAPIClientWillRefreshAccessToken;
extern NSString * const POAPIClientDidRefreshAccessToken;

extern NSString * const POAPIClientTokenRefreshFailed;
extern NSString * const POAPIClientNeedsReauthentication;

extern NSString * const POAPIClientRequestFinished;
extern NSString * const POAPIClientRequestFailed;

@interface PKAPIClient : NSObject <ASIHTTPRequestDelegate, PKOAuth2ClientDelegate> {

 @private
  NSString *baseURLString_;
  NSString *fileUploadURLString_;
  NSString *fileDownloadURLString_;
  NSString *userAgent_;
  
  ASINetworkQueue *networkQueue_;
  PKOAuth2Client *oauthClient_;
  PKOAuth2Token *authToken_;
  
  NSMutableArray *pendingRequests_;
  
  BOOL isRefreshingToken_;
  BOOL isAuthenticating_;
  BOOL isReuthenticating_;
}

@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy) NSString *fileUploadURLString;
@property (nonatomic, copy) NSString *fileDownloadURLString;
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, retain) PKOAuth2Token *authToken;

+ (PKAPIClient *)sharedClient;

- (void)configureWithClientId:(NSString *)clientId secret:(NSString *)secret;

- (void)configureWithClientId:(NSString *)clientId secret:(NSString *)secret baseURLString:(NSString *)baseURLString;

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password;

- (void)reauthenticateWithEmail:(NSString *)email password:(NSString *)password;

- (BOOL)isAuthenticated;

- (NSString *)URLStringForPath:(NSString *)path parameters:(NSDictionary *)parameters;

- (BOOL)addRequestOperation:(PKRequestOperation *)operation;

- (BOOL)addFileOperation:(PKFileOperation *)operation;

- (void)refreshToken;

- (void)refreshUsingRefreshToken:(NSString *)refreshToken;

@end