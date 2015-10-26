//
//  PLDAuthResponse.m
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDAuthResponse.h"

#import "PLDAccount.h"

@implementation PLDAuthResponse {
  NSMutableArray *_accounts;
}

- (instancetype)initWithResponse:(NSDictionary *)response {
  if (self = [super init]) {
    NSArray *accounts = response[@"accounts"];
    _accounts = [NSMutableArray arrayWithCapacity:[accounts count]];
    for (NSDictionary *accountDict in accounts) {
      PLDAccount *account = [[PLDAccount alloc] initWithDictionary:accountDict];
      [_accounts addObject:account];
    }
  }
  return self;
}

@end
