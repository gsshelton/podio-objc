//
//  PKTWorkspace.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 12/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTModel.h"
#import "PKTWorkspaceMembersAPI.h"

@class PKTAsyncTask;

@interface PKTWorkspace : PKTModel

@property (nonatomic, assign, readonly) NSUInteger spaceID;
@property (nonatomic, assign, readonly) NSUInteger organizationID;
@property (nonatomic, assign, readonly) NSInteger rank;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *linkURL;

+ (PKTAsyncTask *)fetchWorkspaceWithID:(NSUInteger)workspaceID;

+ (PKTAsyncTask *)createWorkspaceWithName:(NSString *)name organizationID:(NSUInteger)organizationID;

+ (PKTAsyncTask *)createOpenWorkspaceWithName:(NSString *)name organizationID:(NSUInteger)organizationID;

+ (PKTAsyncTask *)createPrivateWorkspaceWithName:(NSString *)name organizationID:(NSUInteger)organizationID;

- (PKTAsyncTask *)addMemberWithUserID:(NSUInteger)userID role:(PKTWorkspaceMemberRole)role;

- (PKTAsyncTask *)addMemberWithProfileID:(NSUInteger)profileID role:(PKTWorkspaceMemberRole)role;

- (PKTAsyncTask *)addMemberWithEmail:(NSString *)email role:(PKTWorkspaceMemberRole)role;

- (PKTAsyncTask *)addMembersWithUserIDs:(NSArray *)userIDs role:(PKTWorkspaceMemberRole)role;

- (PKTAsyncTask *)addMembersWithProfileIDs:(NSArray *)profileIDs role:(PKTWorkspaceMemberRole)role;

- (PKTAsyncTask *)addMembersWithEmails:(NSArray *)emails;

@end
