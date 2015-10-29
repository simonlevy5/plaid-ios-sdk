//
//  PLDTransaction.m
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import "PLDTransaction.h"

#import "PLDCategory.h"

@implementation PLDTransactionContact

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _phoneNumber = dictionary[@"phone"];
  }
  return self;
}

@end

@implementation PLDTransactionLocation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    if (dictionary[@"coordinates"]) {
      NSDictionary *coordinates = dictionary[@"coordinates"];
      _latitude = [coordinates[@"lat"] floatValue];
      _longitude = [coordinates[@"lon"] floatValue];
    }
    _address = dictionary[@"address"];
    _city = dictionary[@"city"];
    _state = dictionary[@"state"];
    _zip = dictionary[@"zip"];
  }
  return self;
}

@end

@implementation PLDTransaction

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"_id"];
    _accountId = dictionary[@"_account"];
    _pendingTransactionId = dictionary[@"_pendingTransaction"];

    _amount = [dictionary[@"amount"] floatValue];
    _date = dictionary[@"date"];
    _name = dictionary[@"name"];

    NSDictionary *meta = dictionary[@"meta"];
    NSDictionary *location = meta[@"location"];
    NSDictionary *contact = meta[@"contact"];
    if (location) {
      _location = [[PLDTransactionLocation alloc] initWithDictionary:location];
    }
    if (contact) {
      _contact = [[PLDTransactionContact alloc] initWithDictionary:contact];
    }

    _isPending = [dictionary[@"pending"] boolValue];
    _category = [[PLDCategory alloc] initWithTransactionDictionary:dictionary];
    _score = dictionary[@"score"];
  }
  return self;
}

@end
