//
//  NSObject+Null.m
//  Plaid
//
//  Created by Simon Levy on 10/28/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

- (BOOL)isNull {
  return [self isKindOfClass:[NSNull class]];
}

@end
