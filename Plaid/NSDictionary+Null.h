//
//  NSDictionary+Null.h
//  Plaid
//
//  Created by Simon Levy on 10/28/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Null)

- (BOOL)containsNonNullForKey:(id)key;

@end
