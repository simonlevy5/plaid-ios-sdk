//
//  PLDResourceBundle.m
//  Pods
//
//  Created by Simon Levy on 1/14/16.
//
//

#import "PLDResourceBundle.h"

@implementation PLDResourceBundle

+ (NSBundle *)mainBundle {
  static NSBundle *resources;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle pathForResource:@"PLDResources" ofType:@"bundle"];
    resources = [NSBundle bundleWithPath:resourcePath];
  });
  return resources;
}

@end
