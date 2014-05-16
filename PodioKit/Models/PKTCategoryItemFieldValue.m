//
//  PKTCategoryItemFieldValue.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 28/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTCategoryItemFieldValue.h"
#import "PKTCategoryOption.h"

@implementation PKTCategoryItemFieldValue

- (instancetype)initFromValueDictionary:(NSDictionary *)valueDictionary {
  self = [super init];
  if (!self) return nil;

  self.unboxedValue = [[PKTCategoryOption alloc] initWithDictionary:valueDictionary[@"value"]];
  
  return self;
}

- (NSDictionary *)valueDictionary {
  PKTCategoryOption *option = self.unboxedValue;

  return @{@"value" : @(option.optionID)};
}

+ (BOOL)supportsBoxingOfValue:(id)value {
  return [value isKindOfClass:[PKTCategoryOption class]];
}

@end
