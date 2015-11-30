//
//  PLDNetworkApi+Mocks.h
//  Plaid Tests
//
//  Created by Simon Levy on 11/30/15.
//
//

#import <Foundation/Foundation.h>

#import "PLDNetworkApi.h"

@interface PLDNetworkApi (Mocks)

/**
 An example dictionary containing an error that would be returned from Plaid Link.
 
 @returns NSDictionary containing the example JSON version of an error.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkError;

/**
 An example dictionary containing an API error that could be returned from the Plaid API.
 
 @returns NSDictionary containing the error as JSON.
 @see https://plaid.com/docs/#response-codes
 */
- (NSDictionary *)randomApiError;

/**
 Set the expected response to be returned from the network.
 
 This is to test expected responses without hitting the network.
 
 @param data The expected raw data blob returned from the network.
 @param responseCode The HTTP response code to return.
 @param error NSError The error object to return from the network.
 */
- (void)setMockedNetworkData:(id)data responseCode:(NSUInteger)responseCode error:(NSError *)error;

/**
 Reset NSURLSession mock to it's initial state so other scenarios work as expected.
 */
- (void)stopMocking;

@end
