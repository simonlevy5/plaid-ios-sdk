//
//  PLDLongTailInstitution.m
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLongTailInstitution.h"

#import "UIColor+Utilities.h"

@implementation PLDLongTailInstitutionLoginInput

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _name = dictionary[@"username"];
    _label = dictionary[@"label"];
    _type = dictionary[@"type"];
  }
  return self;
}

@end

@implementation PLDLongTailInstitutionColors

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _primary = [self colorWithString:dictionary[@"primary"]];
    _darker = [self colorWithString:dictionary[@"darker"]];
  }
  return self;
}

// Expected format: "rgba(int, int, int, float)"
- (UIColor *)colorWithString:(NSString *)string {
  NSRange unnecessaryRange = [string rangeOfString:@"rgba"];
  NSUInteger start = unnecessaryRange.length;
  // Now (int, int, int, float)
  NSString *colors = [string substringFromIndex:start];
  colors = [colors stringByReplacingOccurrencesOfString:@"(" withString:@""];
  colors = [colors stringByReplacingOccurrencesOfString:@")" withString:@""];
  NSArray *split = [colors componentsSeparatedByString:@","];
  return [UIColor colorWithRgbaRed:[split[0] intValue]
                             green:[split[1] intValue]
                              blue:[split[2] intValue]
                             alpha:[split[3] intValue]];
}

@end

@implementation PLDLongTailInstitution

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"id"];
    _name = dictionary[@"name"];
    _nameBreakPosition = [dictionary[@"nameBreak"] unsignedIntegerValue];
    NSMutableArray *products = [NSMutableArray array];
    NSDictionary *productsDict = dictionary[@"products"];
    for (NSString *product in [productsDict allKeys]) {
      if ([[productsDict objectForKey:product] boolValue]) {
        [products addObject:@(PlaidProductFromNSString(product))];
      }
    }
    _productsAvailable = products;
    
    NSMutableArray *additionalInputs = [NSMutableArray array];
    for (NSDictionary *field in dictionary[@"fields"]) {
      PLDLongTailInstitutionLoginInput *input =
      [[PLDLongTailInstitutionLoginInput alloc] initWithDictionary:field];
      if ([input.name isEqualToString:@"username"]) {
        _usernameInput = input;
      } else if ([input.name isEqualToString:@"password"]) {
        _passwordInput = input;
      } else {
        [additionalInputs addObject:input];
      }
    }
    _additionalLoginInputs = additionalInputs;
    
    _forgottenPasswordURL = [NSURL URLWithString:dictionary[@"forgottenPassword"]];
    _accountLockedURL = [NSURL URLWithString:dictionary[@"accountLocked"]];
    _accountSetupURL = [NSURL URLWithString:dictionary[@"accountSetup"]];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dictionary[@"logo"] options:0];
    _logoImage = [UIImage imageWithData:data];
  }
  return self;
}

- (BOOL)isProductAvailable:(PlaidProduct)product {
  return [_productsAvailable containsObject:@(product)];
}

@end
