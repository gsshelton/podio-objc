//
//  PKReferenceItemData.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 12/7/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "PKReferenceItemData.h"


static NSString * const PKStreamItemDataItemId = @"ItemId";
static NSString * const PKStreamItemDataTitle = @"Title";
static NSString * const PKStreamItemDataAppName = @"AppName";
static NSString * const PKStreamItemDataAppId = @"AppId";
static NSString * const PKStreamItemDataAppItemName = @"AppItemName";
static NSString * const PKStreamItemDataAppIcon = @"AppIcon";
static NSString * const PKReferenceItemDataExcerptLabel = @"ExcerptLabel";
static NSString * const PKReferenceItemDataExcerptText = @"ExcerptText";

@interface PKReferenceItemData ()

@property (nonatomic, copy, readwrite) NSString *excerptLabel;
@property (nonatomic, copy, readwrite) NSString *excerptText;

@end

@implementation PKReferenceItemData

@synthesize itemId = itemId_;
@synthesize title = title_;
@synthesize appName = appName_;
@synthesize appId = appId_;
@synthesize appItemName = appItemName_;
@synthesize appIcon = appIcon_;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    itemId_ = [aDecoder decodeIntegerForKey:PKStreamItemDataItemId];
    title_ = [[aDecoder decodeObjectForKey:PKStreamItemDataTitle] copy];
    appName_ = [[aDecoder decodeObjectForKey:PKStreamItemDataAppName] copy];
    appId_ = [[aDecoder decodeObjectForKey:PKStreamItemDataAppId] copy];
    appItemName_ = [[aDecoder decodeObjectForKey:PKStreamItemDataAppItemName] copy];
    appIcon_ = [[aDecoder decodeObjectForKey:PKStreamItemDataAppIcon] copy];
    _excerptLabel = [[aDecoder decodeObjectForKey:PKReferenceItemDataExcerptLabel] copy];
    _excerptText = [[aDecoder decodeObjectForKey:PKReferenceItemDataExcerptText] copy];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [super encodeWithCoder:aCoder];
  [aCoder encodeInteger:itemId_ forKey:PKStreamItemDataItemId];
  [aCoder encodeObject:title_ forKey:PKStreamItemDataTitle];
  [aCoder encodeObject:appName_ forKey:PKStreamItemDataAppName];
  [aCoder encodeObject:appId_ forKey:PKStreamItemDataAppId];
  [aCoder encodeObject:appItemName_ forKey:PKStreamItemDataAppItemName];
  [aCoder encodeObject:appIcon_ forKey:PKStreamItemDataAppIcon];
  [aCoder encodeObject:_excerptLabel forKey:PKReferenceItemDataExcerptLabel];
  [aCoder encodeObject:_excerptText forKey:PKReferenceItemDataExcerptText];
}


#pragma mark - Factory methods

+ (id)dataFromDictionary:(NSDictionary *)dict {
  PKReferenceItemData *data = [self data];
  
  data.itemId = [[dict pk_objectForKey:@"item_id"] integerValue];
  data.title = [dict pk_objectForKey:@"title"];
  
  NSDictionary *appDict = [dict pk_objectForKey:@"app"];
  data.appName = [appDict pk_objectForKey:@"name"];
  data.appId = [appDict pk_objectForKey:@"app_id"];
  data.appItemName = [appDict pk_objectForKey:@"item_name"];
  data.appIcon = [appDict pk_objectForKey:@"icon"];

  NSDictionary *excerptDict = [dict pk_objectForKey:@"excerpt"];
  data.excerptLabel = [excerptDict pk_objectForKey:@"label"];
  data.excerptText = [excerptDict pk_objectForKey:@"text"];
  
  return data;
}

@end