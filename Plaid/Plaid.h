//
//  Plaid.h
//  Plaid
//
//  Created by Simon Levy on 9/26/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLDAccount.h"
#import "PLDAuthentication.h"
#import "PLDAuthResponse.h"
#import "PLDConnectResponse.h"
#import "PLDCategory.h"
#import "PLDDefines.h"
#import "PLDInstitution.h"
#import "PLDTransaction.h"

@class PLDNetworkApi;

/*
 Completion handler called upon completion of actions for users that are already logged in.

 @param response The response of the action. This will in most cases be a serialized object or the raw response dictionary on success. This will be nil if error is populated.
 @param error If an error occurs, this will be not nil and populated with the corresponding error code that may be from the Plaid system.
 
 @see https://github.com/plaid/support/blob/master/errors.md for Plaid error codes.
 */
typedef void (^PlaidCompletion)(id response, NSError *error);

/*
 Completion handler called upon completion of actions involving logging a user in.
 
 On success, both authentication and response will contain non-nil values, and response may be a serialized object, depending on the context (see documentation of use in method documentation). Error will be nil.
 
 On error, both response and error will contain non-nil values and authentication will be nil. Response will include the raw response dictionary.

 @param authentication The authentication response of the action. This will be populated on success.
 @param response The response of the action. This will in most cases be a serialized object or the raw response dictionary.
 @param error If an error occurs, this will be not nil and populated with the corresponding error code that may be from the Plaid system.
 
 @see PLDAuthentication
 @see https://github.com/plaid/support/blob/master/errors.md for Plaid error codes.
 */
typedef void (^PlaidMfaCompletion)(PLDAuthentication *authentication, id response, NSError *error);

/**
  The 'Plaid' class contains methods to configure the global Parse framework and to access the Plaid API (https://plaid.com/docs/).
 
  The Plaid object is a single instance object that must be configured with a clientId and secret, obtained via https://dashboard.plaid.com/signup/ , to successfully execute requests.
 */
@interface Plaid : NSObject

///---------------------
/// @name Initialization
///---------------------

/*
 Creates and returns a 'Plaid' object.
 */
+ (Plaid *)sharedInstance;

/*
 The environment that this instance of 'Plaid' uses.
 
 @see PLDDefines.h to see options
 */
@property(nonatomic, assign) PlaidEnvironment environment;

/*
 The network API being used for this instance of 'Plaid'.
 */
@property(nonatomic, readonly) PLDNetworkApi *networkApi;

/*
 Configure this instance of 'Plaid' with a clientId and secret, whic is obtained via https://dashboard.plaid.com/signup/
 
 @param clientId The client id of the account using this instance.
 @param secret The secret of the account using this instance.
 */
- (void)setClientId:(NSString *)clientId secret:(NSString *)secret;

///---------------------
/// @name Auth product endpoints
///---------------------

/*
 Log a user into the 'Auth' Plaid product. This may require multi-factor authentication which then requires use of the |stepAuthUserWithAccessToken| method.
 
 This completion handler calls back with a serialized PLDAuthResponse object upon successful login.
 
 @param username The bank username of the user adding an account.
 @param password The bank password of the user adding an account.
 @param type The name of the bank the user intends to log into (i.e. wells, boa).
 @param options Additional options passed to Plaid. This allows forcing the MFA response to include a list of MFA options by passing @{ list: @(YES) }. Can be nil.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDAuthResponse in place of the response generic parameter if no multi-factor is required.
 
 @see PlaidMfaCompletion above
 @see https://plaid.com/docs/#add-auth-user for more documentation.
 */
- (void)addAuthUserWithUsername:(NSString *)username
                       password:(NSString *)password
                           type:(NSString *)type
                        options:(NSDictionary *)options
                     completion:(PlaidMfaCompletion)completion;

/*
 Fetch data for a user logged into the 'Auth' Plaid product. This requires that the user has already authenticated into to 'Auth' product.
 
 @param accessToken Valid access token returned from |addAuthUserWithUsername|
 @param completion The completion handler called when the request finishes. This calls with an instance of PLDAuthResponse in place of the generic 'response' parameter.
 
 @see addAuthUserWithUsername to obtain accessToken
 @see https://plaid.com/docs/#retrieve-data
 */
- (void)getAuthUserWithAccessToken:(NSString *)accessToken
                        completion:(PlaidCompletion)completion;

/*
 Submit the next required step of multi-factor authentication using this method, if applicable.
 
 @param accessToken Access token returned from |addAuthUserWithUsername|. This is the access token only used during the multi-factor authentication process
 @param mfaResponse The response to the current multi-factor authentication challenge.
 @param options Additional options passed to Plaid. This is required when answering which multi-factor type to use.
 @param completion The completion handler called when the request finishes. This calls with an instance of PLDAuthResponse in place of the response generic parameter if no further multi-factor authentication is required.
 
 @see PlaidMfaCompletion above
 @see https://plaid.com/docs/#mfa-auth
 */
- (void)stepAuthUserWithAccessToken:(NSString *)accessToken
                        mfaResponse:(id)mfaResponse
                            options:(NSDictionary *)options
                         completion:(PlaidMfaCompletion)completion;
/*
 Update a user using the 'Auth' Plaid product. This is required when a user updates their username and/or password and is locked out of this product.
 
 @param accessToken The access token that was received when the user orignially logged in.
 @param username The new, valid bank username for the user logging in.
 @param password The new, avlid bank password for the user logging in.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDAuthResponse in place of the response generic parameter if no multi-factor is required
 
 @see PlaidMfaCompletion above
 @see https://plaid.com/docs/#update-auth-user
 */
- (void)patchAuthUserWithAccessToken:(NSString *)accessToken
                            username:(NSString *)username
                            password:(NSString *)password
                          completion:(PlaidMfaCompletion)completion;
/*
 Remove an user using the 'Auth' Plaid product from the Plaid system. This will revoke the access token passed in and is irrevocable.
 
 @param accessToken The access token for the user being revoked.
 @param completion The completion handler called when this request finishes. This will only contain an error if there is an error, otherwise the response will be empty.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#delete-auth-user
 */
- (void)deleteAuthUserWithAccessToken:(NSString *)accessToken
                           completion:(PlaidCompletion)completion;

///---------------------
/// @name Connect product endpoints
///---------------------

/*
 Log a user into the 'Connect' Plaid product. This may require multi-factor authentication which then requires use of the |stepAuthUserWithAccessToken::::| method.
 
 This completion handler calls back with a serialized PLDConnectResponse object upon successful login.
 
 @param username The bank username of the user adding an account
 @param password The bank password of the user adding an account
 @param type The name of the bank the user intends to log into (i.e. wells, boa)
 @param options Additional options passed to Plaid. See additional documentation link below for options.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDConnectResponse in place of the response generic parameter.
 
 @see PlaidMfaCompletion
 @see https://plaid.com/docs/#add-connect-user for more documentation.
 */
- (void)addConnectUserWithUsername:(NSString *)username
                          password:(NSString *)password
                              type:(NSString *)type
                           options:(NSDictionary *)options
                        completion:(PlaidMfaCompletion)completion;

/*
 Fetch data, which includes transactions and accounts, for a user logged into the 'Connect' Plaid product. This requires that the user has already authenticated into to 'Connect' product.

 @param accessToken Valid access token returned from |addAuthUserWithUsername|
 @param completion The completion handler called when the request finishes. This calls with an instance of PLDConnectResponse in place of the generic 'response' parameter.
 
 @see addAuthUserWithUsername to obtain accessToken
 @see PlaidCompletion
 @see https://plaid.com/docs/#retrieve-transactions
 */
- (void)getConnectUserWithAccessToken:(NSString *)accessToken
                              options:(NSDictionary *)options
                           completion:(PlaidCompletion)completion;

/*
 Submit the next required step of multi-factor authentication using this method, if applicable.
 
 @param accessToken Access token returned from |addAuthUserWithUsername|. This is the access token only used during the multi-factor authentication process
 @param mfaResponse The response to the current multi-factor authentication challenge.
 @param options Additional options passed to Plaid. This is required when answering which multi-factor type to use.
 @param completion The completion handler called when the request finishes. This calls with an instance of PLDConnectResponse in place of the response generic parameter if no further multi-factor authentication is required.
 
 @see PlaidMfaCompletion
 @see https://plaid.com/docs/#mfa-authentication
 */
- (void)stepConnectUserWithAccessToken:(NSString *)accessToken
                           mfaResponse:(id)mfaResponse
                               options:(NSDictionary *)options
                            completion:(PlaidMfaCompletion)completion;

/*
 Update a user using the 'Connect' Plaid product. This is required when a user updates their username and/or password and is locked out of this product.
 
 @param accessToken The access token that was received when the user orignially logged in.
 @param username The new, valid bank username for the user logging in.
 @param password The new, avlid bank password for the user logging in.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDConnectResponse in place of the response generic parameter if no multi-factor is required
 
 @see PlaidMfaCompletion
 @see https://plaid.com/docs/#update-user
 */
- (void)patchConnectUserWithAccessToken:(NSString *)accessToken
                               username:(NSString *)username
                               password:(NSString *)password
                             completion:(PlaidMfaCompletion)completion;

/*
 Remove an user using the 'Connect' Plaid product from the Plaid system. This will revoke the access token passed in and is irrevocable.
 
 @param accessToken The access token for the user being revoked.
 @param completion The completion handler called when this request finishes. This will only contain an error if there is an error, otherwise the response will be empty.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#delete-user
 */
- (void)deleteConnectUserWithAccessToken:(NSString *)accessToken
                              completion:(PlaidCompletion)completion;

///---------------------
/// @name Generic product endpoints. These allow explicitly choosing the product.
///---------------------

/*
 Log a user into a Plaid product. This may require multi-factor authentication which then requires use of the |stepAuthUserWithAccessToken| method.
 
 This completion handler calls back with a response dictionary object upon successful login.
 
 @param product The Plaid product to log a user into.
 @param username The bank username of the user adding an account.
 @param password The bank password of the user adding an account.
 @param type The name of the bank the user intends to log into (i.e. wells, boa).
 @param options Additional options passed to Plaid. See additional documentation link below for options.
 @param completion The completion handler called when this request finishes.
 
 @see PlaidMfaCompletion
 */
- (void)addUserForProduct:(PlaidProduct)product
                 username:(NSString *)username
                 password:(NSString *)password
                     type:(NSString *)type
                  options:(NSDictionary *)options
               completion:(PlaidMfaCompletion)completion;

/*
 Fetch data for a user logged into a Plaid product. This requires that the user has already authenticated into to the product being used.
 
 @param product The Plaid product being used.
 @param accessToken Valid access token returned from |addAuthUserWithUsername|.
 @param completion The completion handler called when the request finishes.
 
 @see addAuthUserWithUsername to obtain accessToken
 @see PlaidCompletion
 */
- (void)getUserForProduct:(PlaidProduct)product
              accessToken:(NSString *)accessToken
                  options:(NSDictionary *)options
               completion:(PlaidCompletion)completion;

/*
 Submit the next required step of multi-factor authentication using this method, if applicable.
 
 @param product The Plaid product being used.
 @param accessToken Access token returned from |addAuthUserWithUsername|. This is the access token only used during the multi-factor authentication process.
 @param mfaResponse The response to the current multi-factor authentication challenge.
 @param options Additional options passed to Plaid. This is required when answering which multi-factor type to use.
 @param completion The completion handler called when the request finishes.
 
 @see PlaidMfaCompletion
 */
- (void)stepUserForProduct:(PlaidProduct)product
               accessToken:(NSString *)accessToken
               mfaResponse:(id)mfaResponse
                   options:(NSDictionary *)options
                completion:(PlaidMfaCompletion)completion;

/*
 Update a user using a Plaid product. This is required when a user updates their username and/or password and is locked out of this product.
 
 @param product The Plaid product being used.
 @param accessToken The access token that was received when the user orignially logged in.
 @param username The new, valid bank username for the user logging in.
 @param password The new, avlid bank password for the user logging in.
 @param completion The completion handler called when this request finishes.

 @see PlaidMfaCompletion
 */
- (void)patchUserForProduct:(PlaidProduct)product
                accessToken:(NSString *)accessToken
                   username:(NSString *)username
                   password:(NSString *)password
                 completion:(PlaidMfaCompletion)completion;

/*
 Remove an user using a Plaid product from the Plaid system. This will revoke the access token passed in and is irrevocable.
 
 @param product The Plaid product being used.
 @param accessToken The access token for the user being revoked.
 @param completion The completion handler called when this request finishes. This will only contain an error if there is an error, otherwise the response will be empty.
 
 @see PlaidCompletion
 */
- (void)deleteUserForProduct:(PlaidProduct)product
                 accessToken:(NSString *)accessToken
                  completion:(PlaidCompletion)completion;

/*
 Get a specific category from the Plaid system by its category id.
 
 @param categoryId The id of the category to fetch.
 @param completion The completion handler called when this request finishes. This will contain an instance of PLDCategory on success.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#categories-by-id
 */
- (void)getCategoryByCategoryId:(NSString *)categoryId
                     completion:(PlaidCompletion)completion;

/*
 Get a list of all categories in the Plaid system.
 
 @param completion The completion handler called when this request finishes. This will contain an array of PLDCategory objects on success.
 
 @see https://plaid.com/docs/#all-categories
 */
- (void)getCategoriesWithCompletion:(PlaidCompletion)completion;

/*
 Get a specific institution, or bank, from the Plaid system.
 
 @param institutionId The id of the institution to fetch.
 @param completion The completion handler called when this request finishes. This will contain an instance of PLDInstitution on success.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#institutions-by-id
 */
- (void)getInstitutionById:(NSString *)institutionId
                completion:(PlaidCompletion)completion;

/*
 Get a list of all institutions in the Plaid system.
 
 @param completion The completion handler called when this request finishes. This will contain an array of PLDInstitution objects on success.
 
 @see https://plaid.com/docs/#institutions
 */
- (void)getInstitutionsWithCompletion:(PlaidCompletion)completion;

/*
 Exchange a public token obtained from the Plaid Link product for an access token.
 
 @param publicToken The public token returned from successfully logging in via Plaid Link.
 @param completion The completion handler called when this request finishes. This will contain the access token on success.
 
 @see PlaidCompletion
 @see https://github.com/plaid/link#exchange_token-endpoint
 */
- (void)exchangePublicToken:(NSString *)publicToken completion:(PlaidCompletion)completion;

/*
 Get the real time balance of a user's accounts. This may be used for exists users that were added via any of Plaid's products.
 
 @param accessToken The access token of the user whose account is being queried.
 @param completion The completion handler called when this request finishes. This will contain an array of PLDAccount objects on success.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#retrieve-balance
 */
- (void)getBalanceWithAccessToken:(NSString *)accessToken
                       completion:(PlaidCompletion)completion;

/*
 Upgrade a user that has already been added to any of Plaid's existing products to be able to use the functionality of one of Plaid's other products.
 
 @param accessToken The access token for an already logged in user.
 @param upgradeTo The product to extend the functionality of the existing user to.
 @param completion The completion handler called when this request finishes.
 
 @see PlaidMfaCompletion
 @see https://plaid.com/docs/#upgrade
 */
- (void)upgradeUserWithAccessToken:(NSString *)accessToken
                         upgradeTo:(PlaidProduct)upgradeTo
                        completion:(PlaidMfaCompletion)completion;

@end
