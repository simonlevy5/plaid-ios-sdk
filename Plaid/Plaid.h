//  Plaid.h
//  Plaid
//
//  Created by Simon Levy on 9/26/15.
//

#import <Foundation/Foundation.h>

#import "PLDAccount.h"
#import "PLDAuthentication.h"
#import "PLDAuthResponse.h"
#import "PLDConnectResponse.h"
#import "PLDCategory.h"
#import "PLDDefines.h"
#import "PLDInstitution.h"
#import "PLDLinkAuthentication.h"
#import "PLDLongTailInstitution.h"
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
  The 'Plaid' class contains methods to configure the global Plaid framework and to access the Plaid API (https://plaid.com/docs/).
 
  The Plaid object is a single instance object that must be configured with a public key, obtained via https://dashboard.plaid.com/signup/ , to successfully execute requests.
 
  Example adding a user to Plaid:
 
    #import "Plaid.h"

    Plaid *plaid = [Plaid sharedInstance];
    [plaid setPublicKey:@"your_public_key"];
 
    [plaid addLinkUserForProduct:PlaidProductConnect
                        username:@"username"
                        password:@"test"
                            type:@"wells"
                         options:nil
                      completion:^(PLDAuthentication *authentication,
                                   id response,
                                   NSError *error) {
      if (error) {
        // An error occured.
        return;
      }
      if (authentication.mfa) {
        // MFA is required. Collect MFA challenge response and submit using stepLinkUser
        return;
      }
      
      // This is a public token that can be passed to exchangeToken to receive a valid access token.
      NSString *publicToken = authentication.accessToken;
      // Pass publicToken to server and exchange for an accessToken.
    }];
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

/**
 Configure this instance of 'Plaid' with a public token used to complete Plaid Link. This can be obtained via https://dashboard.plaid.com/signup/
 
 @param publicKey The public token
 */
- (void)setPublicKey:(NSString *)publicKey;

///---------------------
/// @name Generic product endpoints. These allow explicitly choosing the product.
///---------------------

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
 Search long-tail institutions, which are not returned by the getInstitutions method. This returns an array of PLDLongTailInstitution objects on success.
 
 @param query The query string to match against the full list of institutions. This includes partial matches.
 @param product An optional filter by Plaid product. Pass 0, or PlaidProductUnknown to not filter.
 @param completion The completion handler called when this request finishes. This will contain an array of PLDLongTailInstitution objects on success.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#institution-search
 */
- (void)getLongTailInstitutionsWithQuery:(NSString *)query
                                 product:(PlaidProduct)product
                              completion:(PlaidCompletion)completion;

/*
 Search long-tail institutions by the identifier of an institution (e.g. bofa). This returns an array of PLDLongTailInstitution objects on success.
 
 @param institutionId The id of a single institution for lookup.
 @param completion The completion handler called when this request finishes. This will contain an array of PLDInstitution objects on success.
 
 @see PlaidCompletion
 @see https://plaid.com/docs/#institution-search
 */
- (void)getLongTailInstitutionsById:(NSString *)institutionId
                         completion:(PlaidCompletion)completion;

///---------------------
/// @name Plaid Link endpoints. This allows login via Plaid Link.
///---------------------

/**
 Log a user into the Plaid Link product.
 
 This completion handler calls back with a serialized PLDAuthResponse object upon successful login.
 
 @param username The bank username of the user adding an account.
 @param password The bank password of the user adding an account.
 @param type The name of the bank the user intends to log into (i.e. wells, boa).
 @param options Additional options passed to Plaid. This allows adding a webhook with the dictionary @{ @"webhook" : @"webhook_url" }. Can be nil.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDAuthResponse in place of the response generic parameter if no multi-factor is required.
 */
- (void)addLinkUserForProduct:(PlaidProduct)product
                     username:(NSString *)username
                     password:(NSString *)password
                         type:(NSString *)type
                      options:(NSDictionary *)options
                   completion:(PlaidMfaCompletion)completion;

/**
 Log a user into the Plaid Link product. This is for institutions that explicitly require a pin code to login.
 
 @param username The bank username of the user adding an account.
 @param password The bank password of the user adding an account.
 @param pin The bank pin code of the user adding the account (usaa only).
 @param type The name of the bank the user intends to log into (i.e. wells, boa).
 @param options Additional options passed to Plaid. This allows adding a webhook with the dictionary @{ @"webhook" : @"webhook_url" }. Can be nil.
 @param completion The completion handler called when this request finishes. This calls with an instance of PLDAuthResponse in place of the response generic parameter if no multi-factor is required.
 */
- (void)addLinkUserForProduct:(PlaidProduct)product
                     username:(NSString *)username
                     password:(NSString *)password
                          pin:(NSString *)pin
                         type:(NSString *)type
                      options:(NSDictionary *)options
                   completion:(PlaidMfaCompletion)completion;

/*
 Submit the next required step of multi-factor authentication using this method, if applicable, for the Plaid Link product.
 
 @param product The Plaid product being used.
 @param publicToken Public token returned from |addLinkUserForProduct|. This is the public token only used during the multi-factor authentication process.
 @param mfaResponse The response to the current multi-factor authentication challenge.
 @param options Additional options passed to Plaid.
 @param completion The completion handler called when the request finishes.
 
 @see PlaidMfaCompletion
 */
- (void)stepLinkUserForProduct:(PlaidProduct)product
                   publicToken:(NSString *)publicToken
                   mfaResponse:(id)mfaResponse
                       options:(NSDictionary *)options
                    completion:(PlaidMfaCompletion)completion;

@end
