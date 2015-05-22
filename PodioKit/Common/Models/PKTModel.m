//
//  PKTModel.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "PKTModel.h"
#import "NSObject+PKTIntrospection.h"

@implementation PKTModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (!self) return nil;
  
  [self updateFromDictionary:dictionary];
  
  return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if (!self) return nil;

  for (NSString *propertyName in self.pkt_codablePropertyNames) {
    id value = [coder decodeObjectForKey:propertyName];
    [self setValue:value forKey:propertyName];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  for (NSString *propertyName in self.pkt_codablePropertyNames) {
    id value = [self valueForKey:propertyName];
    [coder encodeObject:value forKey:propertyName];
  }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  id copy = [[[self class] alloc] init];
  
  for (NSString *key in self.pkt_codablePropertyNames) {
    id value = [self valueForKey:key];
    [copy setValue:value forKey:key];
  }
  
  return copy;
}

#pragma mark - Public

+ (NSDictionary *)dictionaryKeyPathsForPropertyNames {
  return nil;
}

#pragma mark - Mapping

+ (NSDictionary *)dictionaryKeyPathsForPropertyNamesForClassAndSuperClasses {
  NSMutableDictionary *keyPathsMapping = [NSMutableDictionary new];
  
  Class klass = self;
  while (klass != [PKTModel class]) {
    NSDictionary *klassKeyPaths = [klass dictionaryKeyPathsForPropertyNames];
    if (klass) {
      [keyPathsMapping addEntriesFromDictionary:klassKeyPaths];
    }
    
    klass = [klass superclass];
  }
  
  return [keyPathsMapping copy];
}

- (void)updateFromDictionary:(NSDictionary *)dictionary {
  NSDictionary *keyPathMapping = [[self class] dictionaryKeyPathsForPropertyNamesForClassAndSuperClasses];
  
  for (NSString *propertyName in self.pkt_codablePropertyNames) {
    // Should this property be mapped?
    NSString *keyPath = [keyPathMapping objectForKey:propertyName];
    if (!keyPath) {
      keyPath = propertyName;
    }
    
    id value = [dictionary valueForKeyPath:keyPath];
    if (value) {
      if (value == NSNull.null) {
        // NSNull should be treated as nil
        value = nil;
      } else {
        // Is there is a value transformer for this property?
        NSValueTransformer *transformer = [[self class] valueTransformerForKey:propertyName dictionary:dictionary];
        if (transformer)  {
          value = [transformer transformedValue:value];
        }
      }
      
      [self setValue:value forKey:propertyName];
    }
  }
}

- (void)setNilValueForKey:(NSString *)key {
  [self setValue:@0 forKey:key];
}

#pragma mark - Value transformation

+ (NSValueTransformer *)valueTransformerForKey:(NSString *)key dictionary:(NSDictionary *)dictionary {
  // Try the <propertyName>ValueTransformerWithDictionary: selector
  NSString *transformerSelectorName = [key stringByAppendingString:@"ValueTransformerWithDictionary:"];
  NSValueTransformer *transformer = [self pkt_valueByPerformingSelectorWithName:transformerSelectorName withObject:dictionary];
  
  // Try the <propertyName>ValueTransformer selector
  if (!transformer) {
    transformerSelectorName = [key stringByAppendingString:@"ValueTransformer"];
    transformer = [self pkt_valueByPerformingSelectorWithName:transformerSelectorName];
  }
  
  return transformer;
}

#pragma mark - NSObject

- (NSUInteger)hash {
  NSUInteger value = 0;
  
  for (NSString *key in self.pkt_codablePropertyNames) {
    value ^= [[self valueForKey:key] hash];
  }
  
  return value;
}

- (BOOL)isEqual:(id)object {
  if (self == object) return YES;
  if (![object isMemberOfClass:self.class]) return NO;
  
  for (NSString *key in self.pkt_codablePropertyNames) {
    id selfValue = [self valueForKey:key];
    id objectValue = [object valueForKey:key];
    
    BOOL valuesEqual = ((selfValue == nil && objectValue == nil) || [selfValue isEqual:objectValue]);
    if (!valuesEqual) return NO;
  }
  
  return YES;
}

@end
