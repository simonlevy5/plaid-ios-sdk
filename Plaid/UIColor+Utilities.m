//
//  UIColor+Utilities.m
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)

+ (UIColor *)colorWithRgbaRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithRgbaRed:(int)red green:(int)green blue:(int)blue {
  return [self colorWithRgbaRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

@end
