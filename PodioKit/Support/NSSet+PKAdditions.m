//
//  NSSet+PKAdditions.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 8/7/11.
//  Copyright 2011 Podio. All rights reserved.
//

#import "NSSet+PKAdditions.h"

@implementation NSSet (PKAdditions)

- (NSSet *)pk_setFromObjectsCollectedWithBlock:(id (^)(id obj))block {
  NSMutableSet *mutSet = [[NSMutableSet alloc] initWithCapacity:[self count]];
  
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    [mutSet addObject:block(obj)];
  }];
  
  NSSet *set = [mutSet copy];
  
  return set;
}

@end
