//
//  PLDTransaction.h
//  Plaid
//
//  Created by Simon Levy on 10/22/15.
//

#import <Foundation/Foundation.h>

@class PLDCategory;

/**
 Object representing a serialized version of a contact on a transaction object.
 
 @warning Values not returned will be nil.
 */
@interface PLDTransactionContact : NSObject

@property(nonatomic, readonly) NSString *phoneNumber;

@end

/**
 Object representing a serialized version of a location on a transaction object.
 
 @warning Values not returned will be nil or zero.
 */
@interface PLDTransactionLocation : NSObject

@property(nonatomic, readonly) float latitude;
@property(nonatomic, readonly) float longitude;

@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *city;
@property(nonatomic, readonly) NSString *state;
@property(nonatomic, readonly) NSString *zip;

@end

/**
 Object representing a serialized version of a transaction object.
 
 @warning Values not returned will be nil or zero.
 @ see https://plaid.com/docs/#data-overview
 */
@interface PLDTransaction : NSObject

@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) NSString *accountId;
@property(nonatomic, readonly) NSString *pendingTransactionId;

@property(nonatomic, readonly) float amount;
@property(nonatomic, readonly) NSDate *date;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) PLDTransactionLocation *location;
@property(nonatomic, readonly) PLDTransactionContact *contact;

@property(nonatomic, readonly) BOOL isPending;
@property(nonatomic, readonly) PLDCategory *category;
@property(nonatomic, readonly) NSDictionary *score;

/**
 Initializes a 'PLDTransaction' object with a dictionary that should contain the JSON response from the Plaid API.
 
 @param dictionary The dictionary representation of a transaction in the Plaid system.
 
 @return A new PLDTransaction instance.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
