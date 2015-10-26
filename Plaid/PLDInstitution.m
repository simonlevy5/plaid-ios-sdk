//
//  PLDInstitution.m
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDInstitution.h"

@implementation PLDInstitution

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"id"];
    _name = dictionary[@"name"];
    _type = dictionary[@"type"];
    _hasMfa = [dictionary[@"has_mfa"] boolValue];
    _mfaOptions = dictionary[@"mfa"];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ - name: %@ type: %@ hasMfa: %d",
              [super description], _name, _type, _hasMfa];
}

- (UIColor *)backgroundColor {
  NSDictionary *colors = [PLDInstitution backgroundColors];
  UIColor *bankColor = [colors objectForKey:self.type];
  return bankColor != nil ? bankColor : [UIColor redColor];
}

+ (NSDictionary *)backgroundColors {
  static NSDictionary *backgroundColors = nil;
  static dispatch_once_t oncePredicate;

  dispatch_once(&oncePredicate, ^{
    backgroundColors = @{
      @"amex": [self colorWithRed:0 green:135 blue:196],
      @"bofa": [self colorWithRed:233 green:45 blue:13],
      @"capone360": [self colorWithRed:161 green:40 blue:49],
      @"chase": [self colorWithRed:23 green:93 blue:165],
      @"citi": [self colorWithRed:9 green:40 blue:105],
      @"fidelity": [self colorWithRed:63 green:152 blue:26],
      @"nfcu": [self colorWithRed:10 green:68 blue:125],
      @"pnc": [self colorWithRed:14 green:105 blue:170],
      @"schwab": [self colorWithRed:0 green:140 blue:218],
      @"suntrust": [self colorWithRed:0 green:74 blue:128],
      @"svb": [self colorWithRed:0 green:160 blue:228],
      @"td": [self colorWithRed:33 green:170 blue:33],
      @"us": [self colorWithRed:12 green:32 blue:116],
      @"usaa": [self colorWithRed:0 green:54 blue:91],
      @"wells": [self colorWithRed:230 green:34 blue:39]};
  });

  return backgroundColors;
}

+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue {
  return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

@end
