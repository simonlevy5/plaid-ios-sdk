//
//  PLDLinkAuthentication.h
//  Pods
//
//  Created by Simon Levy on 11/24/15.
//
//

#import <Foundation/Foundation.h>

#import "PLDAuthentication.h"

@interface PLDLinkMFAAuthenticationChoice : PLDMFAAuthenticationChoice
@end

@interface PLDLinkMFAAuthenticationSelection : PLDMFAAuthenticationSelection
@end

@interface PLDLinkMFAAuthentication : PLDMFAAuthentication
@end

/**
 A current representation of a user's state when authenticating using Plaid Link. This object is only
 returned upon a successful authentication or authentication step and is immutable.
 
 @see PLDAuthentication
 @see https://github.com/plaid/link
 */
@interface PLDLinkAuthentication : PLDAuthentication
@end
