//
//  PLDAccount.h
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import <Foundation/Foundation.h>

/**
 Object representing a serialized version of an account balance.
 
 @warning Values not returned will be zero.
 */
@interface PLDAccountBalance : NSObject

@property(nonatomic, readonly) float availableAmount;
@property(nonatomic, readonly) float currentAmount;
@property(nonatomic, readonly) float limit;

@end

/**
 Object representing a serialized version of account numbers associated with an account.
 
 @warning Values not returned will be nil.
 */
@interface PLDAccountNumbers : NSObject

@property(nonatomic, readonly) NSString *routing;
@property(nonatomic, readonly) NSString *account;
@property(nonatomic, readonly) NSString *wireRouting;

@end

/**
 Object representing a serialized version of an account.
 
 @see https://plaid.com/docs/#data-overview
 */
@interface PLDAccount : NSObject

@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) NSString *itemId;
@property(nonatomic, readonly) NSString *userId;

@property(nonatomic, readonly) PLDAccountBalance *balance;

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *number;

@property(nonatomic, readonly) PLDAccountNumbers *accountNumbers;

@property(nonatomic, readonly) NSString *institutionType;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) NSString *subtype;

/**
 Initializes a 'PLDAccount' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of an account object in the Plaid system.
 
 @return A new PLDAccount instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
