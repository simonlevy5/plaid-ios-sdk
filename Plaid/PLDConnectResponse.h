//
//  PLDConnectResponse.h
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import <Foundation/Foundation.h>

/**
 Object representing a serialized version of data from a response from the Plaid 'Connect' product.
 */
@interface PLDConnectResponse : NSObject

/**
 The accounts returned by the request.
 */
@property(nonatomic, readonly) NSArray *accounts;  // NSArray<PLDAccount *>

/**
 The transactions returned by the request.
 */
@property(nonatomic, readonly) NSArray *transactions;  // NSArray<PLDTransaction *>

/**
 Initialized a 'PLDConnectResponse' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of a 'Connect' response in the Plaid system.
 
 @return A new PLDConnectResponse instance.
 */
- (instancetype)initWithResponse:(NSDictionary *)response;

@end
