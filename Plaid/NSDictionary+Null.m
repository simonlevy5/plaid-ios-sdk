//
//  NSDictionary+Null.m
//  Plaid
//
//  Created by Simon Levy on 10/28/15.
//

#import "NSDictionary+Null.h"

@implementation NSDictionary (Null)

- (BOOL)containsNonNullForKey:(id)key {
  return ![self[key] isKindOfClass:[NSNull class]];
}

@end
