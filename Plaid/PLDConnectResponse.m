//
//  PLDConnectResponse.m
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import "PLDConnectResponse.h"

#import "PLDAccount.h"
#import "PLDTransaction.h"

@implementation PLDConnectResponse {
  NSMutableArray *_accounts;
  NSMutableArray *_transactions;
}

- (instancetype)initWithResponse:(NSDictionary *)response {
  if (self = [super init]) {
    NSArray *accounts = response[@"accounts"];
    _accounts = [NSMutableArray arrayWithCapacity:[accounts count]];
    for (NSDictionary *accountDict in accounts) {
      PLDAccount *account = [[PLDAccount alloc] initWithDictionary:accountDict];
      [_accounts addObject:account];
    }
    
    NSArray *transactions = response[@"transactions"];
    _transactions = [NSMutableArray arrayWithCapacity:[transactions count]];
    for (NSDictionary *transactionDict in transactions) {
      PLDTransaction *transaction =
          [[PLDTransaction alloc] initWithDictionary:transactionDict];
      [_transactions addObject:transaction];
    }
  }
  return self;
}

@end
