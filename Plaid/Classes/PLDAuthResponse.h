//
//  PLDAuthResponse.h
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import <Foundation/Foundation.h>

/**
 Object representing a serialized version of data from a response from the Plaid 'Auth' product.
 */
@interface PLDAuthResponse : NSObject

/**
 The accounts returned by the request.
 */
@property(nonatomic, readonly) NSArray *accounts;  // NSArray<PLDAccount *>

/**
 Initialized a 'PLDAuthResponse' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of an 'Auth' response in the Plaid system.
 
 @return A new PLDAuthResponse instance.
 */
- (instancetype)initWithResponse:(NSDictionary *)response;

@end
