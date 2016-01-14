//
//  PLDLongTailInstitution.h
//  Plaid
//
//  Created by Simon Levy on 10/27/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PLDInstitution.h"

/**
 Object representing a serialized version of a long tail login input. This is used to present login fields to a user logging into a long-tail institution.
 
 @warning Values not returned will be nil.
 */
@interface PLDLongTailInstitutionLoginInput : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *label;
@property(nonatomic, readonly) NSString *type;

@end

/**
 Object representing a serialized version of a long tail institutions display colors.
 
 @warning Values not returned will be nil.
 */
@interface PLDLongTailInstitutionColors : NSObject

@property(nonatomic, readonly) UIColor *primary;
@property(nonatomic, readonly) UIColor *light;
@property(nonatomic, readonly) UIColor *darker;
@property(nonatomic, readonly) UIColor *dark;

@end

/**
 Object representing a serialized version of an institution.
 
 @warning Values not returned will be nil.
 */
@interface PLDLongTailInstitution : PLDInstitution

@property(nonatomic, readonly) NSArray *productsAvailable;  // NSArray<PlaidProduct>
@property(nonatomic, readonly) NSUInteger nameBreakPosition;

@property(nonatomic, readonly) PLDLongTailInstitutionLoginInput *usernameInput;
@property(nonatomic, readonly) PLDLongTailInstitutionLoginInput *passwordInput;
@property(nonatomic, readonly) NSArray *additionalLoginInputs;
@property(nonatomic, readonly) PLDLongTailInstitutionColors *colors;

/**
 Initializes a 'PLDLongTailInstitution' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of an institution in the Plaid system.
 
 @return A new PLDLongTailInstitution instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
