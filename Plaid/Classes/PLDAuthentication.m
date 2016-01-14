//
//  PLDAuthenticationSession.m
//  Plaid
//
//  Created by Simon Levy on 10/15/15.
//

#import "PLDAuthentication.h"

@implementation PLDMFAAuthenticationChoice

- (instancetype)initWithChoiceResponseDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _choice = dictionary[@"type"];
    _displayText = [NSString stringWithFormat:@"%@: %@", dictionary[@"type"], dictionary[@"mask"]];
  }
  return self;
}

@end

@implementation PLDMFAAuthenticationSelection

- (instancetype)initWithSelectionResponseDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _question = dictionary[@"question"];
    NSMutableArray *answers = [NSMutableArray array];
    for (NSString *answer in dictionary[@"answers"]) {
      [answers addObject:answer];
    }
    _answers = answers;
  }
  return self;
}

@end

@implementation PLDMFAAuthentication

- (instancetype)initWithMFAResponseDictionary:(NSDictionary *)responseDictionary {
  if (self = [super init]) {
    NSString *type = responseDictionary[@"type"];
    if ([type isEqualToString:@"list"]) {
      _type = kPLDMFATypeList;
      NSMutableArray *choices = [NSMutableArray array];
      for (NSDictionary *choice in responseDictionary[@"mfa"]) {
        [choices addObject:[[PLDMFAAuthenticationChoice alloc] initWithChoiceResponseDictionary:choice]];
      }
      _data = choices;
    } else if ([type isEqualToString:@"device"]) {
      _type = kPLDMFATypeCode;
      _data = responseDictionary[@"mfa"][@"message"];
    } else if ([type isEqualToString:@"questions"]) {
      _type = kPLDMFATypeQuestion;
      _data = [responseDictionary[@"mfa"] firstObject][@"question"];
    } else if ([type isEqualToString:@"selections"]) {
      _type = kPLDMFATypeSelection;
      NSMutableArray *selections = [NSMutableArray array];
      for (NSDictionary *selection in responseDictionary[@"mfa"]) {
        [selections addObject:[[PLDMFAAuthenticationSelection alloc] initWithSelectionResponseDictionary:selection]];
      }
      _data = selections;
    } else {
      NSAssert(NO, @"Type not found for MFA Authentication");
    }
  }
  return self;
}

@end

@implementation PLDAuthentication

- (instancetype)initWithProduct:(PlaidProduct)product response:(NSDictionary *)response {
  if (self = [super init]) {
    _product = product;
    _accessToken = response[@"access_token"];
    if (response[@"mfa"]) {
      _mfa = [[PLDMFAAuthentication alloc] initWithMFAResponseDictionary:response];
    }
  }
  return self;
}

@end
