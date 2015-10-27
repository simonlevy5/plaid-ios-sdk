//
//  Plaid+Mocks.h
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#import <Foundation/Foundation.h>

#import "Plaid.h"

/**
 Interface to mock methods that are invoked by 'Plaid'.
 */
@interface Plaid (Mocks)

/**
 An example dictionary containing two accounts with random data in the expected return format of the 'auth' product endpoints.
 
 @returns NSDictionary containing the example JSON payload.
 @see https://plaid.com/docs/#data-overview
 */
- (NSDictionary *)exampleAuthResponse;

/**
 An example dictionary containing one account and one transaction with random data in the expected return format of the 'connect' product endpoints.
 
 @returns NSDictionary containing the example JSON payload.
 @see https://plaid.com/docs/#data-overview
 */
- (NSDictionary *)exampleConnectResponse;

/**
 An example dictionary containing a category object from the 'Plaid' API filled in with random data for testing.
 
 @returns NSDictionary containing the random JSON payload.
 @see https://plaid.com/docs/#libraries
 */
- (NSDictionary *)randomCategoryObject;

/**
 An example dictionary containing a institution object from the 'Plaid' API filled in with random data for testing.
 
 @returns NSDictionary containing the random JSON payload.
 @see https://plaid.com/docs/#institutions-by-id
 */
- (NSDictionary *)randomInstitutionObject;

/**
 Set the expected response to be returned from the network as a result of calling any 'Plaid' API method. The API normally returns a JSON document and is then serialized into an NSDictionary *.
 
 This is to test expected responses without hitting the network.
 
 @param mockedResponse The expected network callback from the Plaid API as an NSDictionary *.
 */
- (void)setMockedResponse:(id)mockedResponse;

@end
