//
//  PLDAuthentication.h
//  Plaid
//
//  Created by Simon Levy on 10/15/15.
//

#import <Foundation/Foundation.h>

#import "PLDDefines.h"

/**
 The types of multi-factor authentication that may be required to authenticate a user.
 */
typedef NS_ENUM(NSUInteger, PLDMFAType) {
  kPLDMFATypeList,
  kPLDMFATypeCode,
  kPLDMFATypeSelection,
  kPLDMFATypeQuestion
};

/**
 A single authentication choice presented when the multi-factor authentication type is 'kPLDMFATypeList'.
 
 The user will be presented with many choices, and should choose one to proceed.
 */
@interface PLDMFAAuthenticationChoice : NSObject

/**
 The text that fully describes this choice, such as 'Phone (xxx-xxx-5390)'.
 */
@property(nonatomic, readonly) NSString *displayText;
/**
 The underlying system value of this choice used to tell the Plaid system which choice was selected, such as 'phone'.
 */
@property(nonatomic, readonly) id choice;

@end

/**
 A single authentication challenge in the form of a question that has a multiple choice list of answers.
 
 The user will be presented with one question that has one correct answer.
 */
@interface PLDMFAAuthenticationSelection : NSObject

/**
 The authentication challenge question string.
 */
@property(nonatomic, readonly) NSString *question;

/**
 The possible answers to the challenge question.
 */
@property(nonatomic, readonly) NSArray *answers;

@end

/**
 Represents a multi-factor authentication step. This exposes the challenge presented to the user to complete the step.
 
 The class of the data property is determined by the type property. The following classes are possible:
  1) type: kPLDMFATypeList
     data class: NSArray<PLDMFAAuthenticationChoice *>
  2) type: kPLDMFATypeCode
     data class: NSString * - A message to be presented to the user with instructions.
  3) type: kPLDMFATypeSelection
     data class: NSArray<PLDMFAAuthenticationSelection *>
  4) type:kPLDMFATypeQuestion
     data class: NSString * A question the user must answer as the challenge.
 */
@interface PLDMFAAuthentication : NSObject

/**
 The data for this multi-factor authentication challenge. See class definition for possible types.
 */
@property(nonatomic, readonly) id data;

/**
 The type of multi-factor authentication challenge being presented.
 */
@property(nonatomic, readonly) PLDMFAType type;

@end

/**
 A current representation of a user's state when authenticating using Plaid. This object is only
 returned upon a successful authentication or authentication step and is immutable.
 
 If a multi-factor authentication step is required, the mfa property will be non-nil.
 
 @warning Access token may only be an access token for use during the multi-factor authentication process.
 */
@interface PLDAuthentication : NSObject

/**
 The current access token for this authentication. It may be valid for only performing more steps. If 'mfa' is nil, this is a valid authentication token for accessing the Plaid system for a given user. This is always non-nil.
 */
@property(nonatomic, readonly) NSString *accessToken;
/**
 The Plaid product that this authentication applies to.
 */
@property(nonatomic, readonly) PlaidProduct product;

/**
 The multi-factor authentication step required, if necessary. This may be nil if no step is required.
 */
@property(nonatomic, readonly) PLDMFAAuthentication *mfa;


/**
 Initialize an instance of 'PLDAuthentication' to represent the current state of authentication after a request.
 
 @param product The Plaid product being logged into.
 @param response The JSON response from the Plaid server from an authentication request.
 
 @return A new instance.
 */
- (instancetype)initWithProduct:(PlaidProduct)product response:(NSDictionary *)response;

@end
