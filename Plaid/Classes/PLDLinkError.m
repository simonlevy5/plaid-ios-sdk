//
//  PLDLinkError.m
//  PlaidLink
//
//  Created by Andres Ugarte on 1/14/16.
//

#import "PLDLinkError.h"

NSString *kLinkErrorDomain = @"com.plaid.link";

@implementation PLDLinkError

+ (PLDLinkError *)errorWithCode:(NSInteger)code {
  return [PLDLinkError errorWithDomain:kLinkErrorDomain code:code userInfo:nil];
}

- (NSString *)localizedDescription {
  PLDLinkErrorCode code = self.code;
  switch (code) {
    case kPLDLinkErrorInvalidKey:
      return @"Invalid Key";
    default:
      break;
  }
  return @"Please try connecting a different account";
}

- (NSString *)localizedFailureReason {
  PLDLinkErrorCode code = self.code;
  switch (code) {
    case kPLDLinkErrorInvalidKey:
      return @"The public key you provided was incorrect. Your public key is available from the Plaid dashboard.";
    default:
      break;
  }
  return @"There was an problem processing your request. Your account could not be connected at this time.";
}

- (NSString *)localizedRecoverySuggestion {
  PLDLinkErrorCode code = self.code;
  switch (code) {
    case kPLDLinkErrorInvalidKey:
      return @"Exit";
    default:
      break;
  }
  return @"Restart";
}

@end
