//
//  PLDInstitution.h
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PLDDefines.h"

/**
 Object representing a serialized version of an institution.
 
 @warning Values not returned will be nil.
 */
@interface PLDInstitution : NSObject

@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) BOOL hasMfa;
@property(nonatomic, readonly) NSArray *mfaOptions;
@property(nonatomic, readonly) UIImage *logoImage;

/**
 The background color that represents the institutions color scheme.
 */
@property(nonatomic, readonly) UIColor *backgroundColor;

/**
 The URL that points to a site where the user can reset their password.
 */
@property(nonatomic, readonly) NSURL *forgottenPasswordURL;

/**
 The URL that points to a site where the user can unlock their account.
 */
@property(nonatomic, readonly) NSURL *accountLockedURL;

/**
 The URL that points to a site where the user can setup their account.
 */
@property(nonatomic, readonly) NSURL *accountSetupURL;

/**
 Initializes a 'PLDInstitution' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of an institution in the Plaid system.
 
 @return A new PLDInstitution instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 Determine if a product is available to this institution.
 
 @param product The product which is being determined eligible.
 @return BOOL YES if the product is available to this institution.
 */
- (BOOL)isProductAvailable:(PlaidProduct)product;

@end
