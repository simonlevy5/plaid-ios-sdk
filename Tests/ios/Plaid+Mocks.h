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
 An example dictionary containing a successful authentication response that is returned from Plaid Link. This assumes the user successfully authenticated.
 
 @param The type of financial instutition being authenticated to.
 @returns NSDictionary containing the example JSON payload.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkAuthResponseWithType:(NSString *)type;

/**
 An example dictionary containing an mfa response that is returned from Plaid Link during authentication. This assumes the user must next choose a mfa device.
 
 @param The type of financial instutition being authenticated to.
 @returns NSDictionary containing the example JSON payload.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkAuthChooseDeviceWithType:(NSString *)type;

/**
 An example dictionary containing an mfa response that is returned from Plaid Link during authentication. This assumes the user just submitted their mfa code.
 
 @param The type of financial instutition being authenticated to.
 @returns NSDictionary containing the example JSON payload.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkAuthRequiresCodeResponseWithType:(NSString *)type;

/**
 An example dictionary containing an mfa response that is returned from Plaid Link during authentication. This assumes the user must next answer a security question.
 
 @param The type of financial instutition being authenticated to.
 @returns NSDictionary containing the example JSON payload.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkAuthRequiresQuestionsResponseWithType:(NSString *)type;

/**
  An example dictionary containing an mfa response that is returned from Plaid Link during authentication. This assumes the user must next answer multiple-choice security questions.
 
 @param The type of financial instutition being authenticated to.
 @returns NSDictionary containing the example JSON payload.
 @see https://github.com/plaid/link
 */
- (NSDictionary *)linkAuthRequiresSelectionsResponseWithType:(NSString *)type;

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
 An example dictionary containing a long tail institution object from the 'Plaid' API filled in with random data for testing.
 
 @returns NSDictionary containing the random JSON payload.
 @see https://plaid.com/docs/#institution-search
 */
- (NSDictionary *)randomLongTailInstitutionObject;

/**
 Set the expected response to be returned from the network as a result of calling any 'Plaid' API method. The API normally returns a JSON document and is then serialized into an NSDictionary *.
 
 This is to test expected responses without hitting the network.
 
 @param mockedResponse The expected network callback from the Plaid API as an NSDictionary *.
 */
- (void)setMockedResponse:(id)mockedResponse;

@end
