//
//  NSObject+PKTIntrospection.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+PKTIntrospection.h"

@implementation NSObject (PKTIntrospection)

- (NSArray *)pkt_codablePropertyNames {
  NSArray *propertyNames = objc_getAssociatedObject([self class], _cmd);
  if (propertyNames) {
    return propertyNames;
  }
  
  NSMutableArray *mutPropertyNames = [NSMutableArray array];
  
  Class klass = [self class];
  while (klass != [NSObject class]) {
    NSArray *classPropertyNames = [klass pkt_codablePropertyNames];
    [mutPropertyNames addObjectsFromArray:classPropertyNames];
    
    klass = [klass superclass];
  }
  
  propertyNames = [mutPropertyNames copy];
  objc_setAssociatedObject([self class], _cmd, propertyNames, OBJC_ASSOCIATION_COPY);
  
  return propertyNames;
}

+ (NSArray *)pkt_codablePropertyNames {
  unsigned int propertyCount;
  objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
  
  NSMutableArray *mutPropertyNames = [NSMutableArray arrayWithCapacity:propertyCount];
  
  for (int i = 0; i < propertyCount; ++i) {
    // Find all properties, backed by an ivar and with a KVC-compliant name
    objc_property_t property = properties[i];
    const char *name = property_getName(property);
    NSString *propertyName = @(name);
    
    // Check if there is a backing ivar
    char *ivar = property_copyAttributeValue(property, "V");
    if (ivar) {
      // Check if ivar has KVC-compliant name, i.e. either propertyName or _propertyName
      NSString *ivarName = @(ivar);
      if ([ivarName isEqualToString:propertyName] ||
          [ivarName isEqualToString:[@"_" stringByAppendingString:propertyName]]) {
        // setValue:forKey: will work
        [mutPropertyNames addObject:propertyName];
      }
      
      free(ivar);
    }
  }
  
  free(properties);
  
  return [mutPropertyNames copy];
}

+ (id)pkt_valueByPerformingSelectorWithName:(NSString *)selectorName {
  return [self pkt_valueByPerformingSelectorWithName:selectorName withObject:nil];
}

+ (id)pkt_valueByPerformingSelectorWithName:(NSString *)selectorName withObject:(id)object {
  id value = nil;
  
  SEL selector = NSSelectorFromString(selectorName);
  if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    value = [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
  }
  
  return value;
}

@end
