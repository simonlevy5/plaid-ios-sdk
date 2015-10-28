//
//  UIColor+Utilities.h
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

+ (UIColor *)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithRgbaRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
+ (UIColor *)colorWithRgbaRed:(int)red green:(int)green blue:(int)blue;

@end
