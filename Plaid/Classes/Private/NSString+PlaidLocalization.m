//
//  NSString+PlaidLocalization.m
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import "NSString+PlaidLocalization.h"

#import "PLDResourceBundle.h"

static NSString * const kStringsFile = @"Localizable";

@implementation NSString (PlaidLocalization)

+ (NSString *)stringWithPlaidIdentifier:(NSString *)identifier {
  NSBundle *resources = [PLDResourceBundle mainBundle];
  return [resources localizedStringForKey:identifier
                                    value:identifier
                                    table:kStringsFile];
}

@end
