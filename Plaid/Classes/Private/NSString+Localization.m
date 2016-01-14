//
//  NSString+Localization.m
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import "NSString+Localization.h"

#import "PLDResourceBundle.h"

static NSString * const kStringsFile = @"Localizable";

@implementation NSString (Localization)

+ (NSString *)stringWithIdentifier:(NSString *)identifier {
  NSBundle *resources = [PLDResourceBundle mainBundle];
  return [resources localizedStringForKey:identifier
                                    value:identifier
                                    table:kStringsFile];
}

@end
