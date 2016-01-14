//
//  UIColor+Utilities.m
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)

+ (UIColor *)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
  NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
  NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
  NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
  
  unsigned redInt = 0;
  NSScanner *rScanner = [NSScanner scannerWithString:redHex];
  [rScanner scanHexInt:&redInt];
  
  unsigned greenInt = 0;
  NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
  [gScanner scanHexInt:&greenInt];
  
  unsigned blueInt = 0;
  NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
  [bScanner scanHexInt:&blueInt];

  return [UIColor colorWithRgbaRed:redInt green:greenInt blue:blueInt alpha:alpha];
}

+ (UIColor *)colorWithRgbaRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)colorWithRgbaRed:(int)red green:(int)green blue:(int)blue {
  return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

@end
