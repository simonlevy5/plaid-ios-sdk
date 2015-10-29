//
//  PLDCategory.m
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import "PLDCategory.h"

@implementation PLDCategory

- (instancetype)initWithCategoryDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"id"];
    _type = dictionary[@"type"];
    _hierarchy = dictionary[@"hierarchy"];
  }
  return self;
}

- (instancetype)initWithTransactionDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"category_id"];
    _type = dictionary[@"type"][@"primary"];
    _hierarchy = dictionary[@"category"];
  }
  return self;
}

@end
