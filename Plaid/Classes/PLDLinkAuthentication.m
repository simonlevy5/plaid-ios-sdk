//
//  PLDLinkAuthentication.m
//  Pods
//
//  Created by Simon Levy on 11/24/15.
//
//

#import "PLDLinkAuthentication.h"

@interface PLDLinkMFAAuthenticationChoice ()

@property(nonatomic) NSString *displayText;
@property(nonatomic) id choice;

@end

@implementation PLDLinkMFAAuthenticationChoice
@synthesize choice, displayText;

- (instancetype)initWithChoiceResponseDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                         options:0
                                                           error:&error];
    NSAssert(!error, @"Unable to parse MFA choice");
    self.choice = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.displayText = [NSString stringWithFormat:@"%@: %@", dictionary[@"type"], dictionary[@"mask"]];
  }
  return self;
}

@end

@interface PLDLinkMFAAuthenticationSelection ()

@property(nonatomic) NSString *question;
@property(nonatomic, copy) NSArray *answers;

@end

@implementation PLDLinkMFAAuthenticationSelection
@synthesize answers, question;

- (instancetype)initWithSelectionResponseDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    self.question = dictionary[@"question"];
    NSMutableArray *answersData = [NSMutableArray array];
    for (NSString *answer in dictionary[@"answers"]) {
      [answersData addObject:answer];
    }
    self.answers = answersData;
  }
  return self;
}

@end

@interface PLDLinkMFAAuthentication ()

@property(nonatomic) id data;
@property(nonatomic) PLDMFAType type;

@end

@implementation PLDLinkMFAAuthentication
@synthesize data, type;

- (instancetype)initWithMFAResponseDictionary:(NSDictionary *)responseDictionary {
  if (self = [super init]) {
    NSString *status = responseDictionary[@"status"];
    if ([status isEqualToString:@"choose_device"]) {
      self.type = kPLDMFATypeList;
      NSMutableArray *choices = [NSMutableArray array];
      for (NSDictionary *choice in responseDictionary[@"mfa"]) {
        [choices addObject:[[PLDLinkMFAAuthenticationChoice alloc] initWithChoiceResponseDictionary:choice]];
      }
      self.data = choices;
    } else if ([status isEqualToString:@"requires_code"]) {
      self.type = kPLDMFATypeCode;
      self.data = responseDictionary[@"mfa"];
    } else if ([status isEqualToString:@"requires_questions"]) {
      self.type = kPLDMFATypeQuestion;
      self.data = [responseDictionary[@"mfa"] firstObject];
    } else if ([status isEqualToString:@"requires_selections"]) {
      self.type = kPLDMFATypeSelection;
      NSMutableArray *selections = [NSMutableArray array];
      for (NSDictionary *selection in responseDictionary[@"mfa"]) {
        [selections addObject:[[PLDLinkMFAAuthenticationSelection alloc] initWithSelectionResponseDictionary:selection]];
      }
      self.data = selections;
    } else {
      NSAssert(NO, @"Type not found for MFA Authentication");
    }
  }
  return self;
}

@end

@implementation PLDLinkAuthentication {
  PlaidProduct _product;
  NSString *_publicToken;
  id _mfa;
}
@synthesize product = _product;
@synthesize accessToken = _publicToken;
@synthesize mfa = _mfa;

- (instancetype)initWithProduct:(PlaidProduct)product
                       response:(NSDictionary *)response {
  if (self = [super init]) {
    _product = product;
    _publicToken = response[@"public_token"];
    NSString *status = response[@"status"];
    if (response[@"mfa"] && ![status isEqualToString:@"connected"]) {
      _mfa = [[PLDLinkMFAAuthentication alloc] initWithMFAResponseDictionary:response];
    }
  }
  return self;
}

@end
