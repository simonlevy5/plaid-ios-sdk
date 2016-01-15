//
//  PLDLinkError.m
//  PlaidLink
//
//  Created by Andres Ugarte on 1/14/16.
//

#import "PLDLinkError.h"

#import "NSString+PlaidLocalization.h"

NSString *kLinkErrorDomain = @"com.plaid.link";

@implementation PLDLinkError

+ (PLDLinkError *)errorWithCode:(NSInteger)code {
  return [PLDLinkError errorWithDomain:kLinkErrorDomain code:code userInfo:nil];
}

- (NSString *)localizedDescription {
  PLDLinkErrorCode code = self.code;
  NSString *messageIdentifier = [NSString stringWithFormat:@"error_%li_title", (long)code];
  NSString *message = [NSString stringWithPlaidIdentifier:messageIdentifier];
  if ([message isEqualToString:messageIdentifier]) {
    message = [NSString stringWithPlaidIdentifier:@"error_generic_title"];
  }
  return message;
}

- (NSString *)localizedFailureReason {
  PLDLinkErrorCode code = self.code;
  NSString *messageIdentifier = [NSString stringWithFormat:@"error_%li_reason", (long)code];
  NSString *message = [NSString stringWithPlaidIdentifier:messageIdentifier];
  if ([message isEqualToString:messageIdentifier]) {
    message = [NSString stringWithPlaidIdentifier:@"error_generic_reason"];
  }
  return message;
}

- (NSString *)localizedRecoverySuggestion {
  PLDLinkErrorCode code = self.code;
  NSString *messageIdentifier = [NSString stringWithFormat:@"error_%li_recovery", (long)code];
  NSString *message = [NSString stringWithPlaidIdentifier:messageIdentifier];
  if ([message isEqualToString:messageIdentifier]) {
    message = [NSString stringWithPlaidIdentifier:@"error_generic_recovery"];
  }
  return message;
}

@end
