//
//  PLDAccount.m
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import "PLDAccount.h"

@implementation PLDAccountBalance

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _availableAmount = [dictionary[@"available"] floatValue];
    _currentAmount = [dictionary[@"current"] floatValue];
    _limit = [dictionary[@"limit"] floatValue];
  }
  return self;
}

@end

@implementation PLDAccountNumbers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _account = dictionary[@"account"];
    _routing = dictionary[@"routing"];
    _wireRouting = dictionary[@"wireRouting"];
  }
  return self;
}

@end

@implementation PLDAccount

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"_id"];
    _itemId = dictionary[@"_item"];
    _userId = dictionary[@"_user"];
    
    NSDictionary *meta = dictionary[@"meta"];
    _name = meta[@"name"];
    _number = meta[@"number"];
    
    _balance = [[PLDAccountBalance alloc] initWithDictionary:dictionary[@"balance"]];
    _accountNumbers = [[PLDAccountNumbers alloc] initWithDictionary:dictionary[@"numbers"]];

    _institutionType = dictionary[@"institution_type"];
    _type = dictionary[@"type"];
    _subtype = dictionary[@"subtype"];
  }
  return self;
}

@end
