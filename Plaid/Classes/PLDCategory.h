//
//  PLDCategory.h
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import <Foundation/Foundation.h>

/**
 Object representing a serialized version of a transactional category.
 
 @warning Values not returned will be nil.
 */
@interface PLDCategory : NSObject

@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) NSString *type;

/**
 The hierarchy of category types for this category. View link for possible values.
 
 @see https://github.com/plaid/Support/blob/master/categories.md
 */
@property(nonatomic, readonly) NSArray *hierarchy;  // NSArray<NSString *>

/**
 Initializes a 'PLDCategory' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of a category object in the Plaid system.
 
 @return A new PLDCategory instance.
 */
- (instancetype)initWithCategoryDictionary:(NSDictionary *)dictionary;

/**
 Initializes a 'PLDCategory' object with a dictionary that should contain a JSON response from the connect product from the Plaid API.
 
 @param dictionary The dictionary representation of a transaction in the Plaid system.
 
 @return A new PLDCategory instance.
 */
- (instancetype)initWithTransactionDictionary:(NSDictionary *)dictionary;

@end
