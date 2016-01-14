//
//  UIColor+Utilities.h
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

/**
 Create a UIColor with a hexadecimal string, such as #00AAFF.
 
 @param hex Hexadecimal string representing a color.
 @param alpha The alpha value to use when creating this color.
 
 @return UIColor object representing the hexadecimal string.
 */
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

/**
 Create a UIColor with 8-bit red, green, and blue values and an alpha value.
 
 @param red The 8-bit red value.
 @param green The 8-bit green value.
 @param blue The 8-bit blue value.
 @param alpha The alpha value for this color.
 
 @return UIColor representing the input 8-bit color values.
 */
+ (UIColor *)colorWithRgbaRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

/**
 Create a UIColor with 8-bit red, green, and blue values and an alpha value.
 
 @param red The 8-bit red value.
 @param green The 8-bit green value.
 @param blue The 8-bit blue value.

 @return UIColor representing the input 8-bit color values.
 */
+ (UIColor *)colorWithRgbaRed:(int)red green:(int)green blue:(int)blue;

@end
