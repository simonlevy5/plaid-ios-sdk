//
//  NSDictionary+Null.h
//  Plaid
//
//  Created by Simon Levy on 10/28/15.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Null)

/**
 Convenience method to check for NSNull objects in an NSDictionary. When JSON objects are serialized and contain the string "null" it is converted into an NSNull object.
 
 @param key The key to check for the NSNull object value.

 @return YES if the value is not an object of the class NSNull, or nil.
 */
- (BOOL)containsNonNullForKey:(id)key;

@end
