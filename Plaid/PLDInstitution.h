//
//  PLDInstitution.h
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
 Initializes a 'PLDInstitution' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of an institution in the Plaid system.
 
 @return A new PLDInstitution instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 The background color that represents the institutions color scheme.

 @return The UIColor that best represents this institution.
 */
- (UIColor *)backgroundColor;

@end
