//
//  PKTContactItemFieldValue.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 28/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "PKTItemFieldValue.h"

@class PKTProfile;

@interface PKTContactItemFieldValue : PKTItemFieldValue

@property (nonatomic, strong) PKTProfile *profile;

@end
