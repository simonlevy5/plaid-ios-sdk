//
//  PLDInstitution.m
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//

#import "PLDInstitution.h"

#import "UIColor+Utilities.h"

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
              [super description], self.name, self.type, self.hasMfa];
}

- (UIColor *)backgroundColor {
  // We use hardcoded values because some of the colors returned by the API are off.
  // TODO: Use API's color as fallback.
  NSDictionary *colors = [PLDInstitution backgroundColors];
  UIColor *bankColor = [colors objectForKey:self.type];
  return bankColor != nil ? bankColor : [UIColor darkGrayColor];
}

+ (NSDictionary *)backgroundColors {
  static NSDictionary *backgroundColors = nil;
  static dispatch_once_t oncePredicate;

  dispatch_once(&oncePredicate, ^{
    backgroundColors = @{
      @"amex": [UIColor colorWithRgbaRed:0 green:135 blue:196],
      @"bofa": [UIColor colorWithRgbaRed:233 green:45 blue:13],
      @"capone360": [UIColor colorWithRgbaRed:161 green:40 blue:49],
      @"chase": [UIColor colorWithRgbaRed:23 green:93 blue:165],
      @"citi": [UIColor colorWithRgbaRed:9 green:40 blue:105],
      @"fidelity": [UIColor colorWithRgbaRed:63 green:152 blue:26],
      @"nfcu": [UIColor colorWithRgbaRed:10 green:68 blue:125],
      @"pnc": [UIColor colorWithRgbaRed:14 green:105 blue:170],
      @"schwab": [UIColor colorWithRgbaRed:0 green:140 blue:218],
      @"suntrust": [UIColor colorWithRgbaRed:0 green:74 blue:128],
      @"svb": [UIColor colorWithRgbaRed:0 green:160 blue:228],
      @"td": [UIColor colorWithRgbaRed:33 green:170 blue:33],
      @"us": [UIColor colorWithRgbaRed:12 green:32 blue:116],
      @"usaa": [UIColor colorWithRgbaRed:0 green:54 blue:91],
      @"wells": [UIColor colorWithRgbaRed:230 green:34 blue:39]};
  });

  return backgroundColors;
}

@end