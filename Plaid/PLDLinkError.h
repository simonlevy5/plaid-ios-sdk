//
//  PLDLinkError.h
//  PlaidLink
//
//  Created by Andres Ugarte on 1/14/16.
//

#import <Foundation/Foundation.h>

extern NSString *kLinkErrorDomain;

typedef NS_ENUM(NSInteger, PLDLinkErrorCode) {
  kPLDLinkErrorUnknown = -1,

  kPLDLinkErrorInvalidKey = 0,

  kPLDLinkErrorCredentialsMissing = 1005,
  kPLDLinkErrorSandboxError = 1109,
  kPLDLinkErrorAdditionLimitExceeded = 1112,
  kPLDLinkErrorIncorrectCredentials = 1200,
  kPLDLinkErrorIncorrectUsername = 1201,
  kPLDLinkErrorIncorrectPassowrd = 1202,
  kPLDLinkErrorIncorrectSecurityCode = 1203,
  kPLDLinkErrorAccountNotAuthorized = 1206,
  kPLDLinkErrorAccountNotSupportedMFA = 1208,
  kPLDLinkErrorIncorrectPIN = 1209,
  kPLDLinkErrorRestrictedSafePass = 1211,

  kPLDLinkErrorAccountNotSupported1207 = 1207,
  kPLDLinkErrorAccountNotSupported1210 = 1210,
  kPLDLinkErrorAccountNotSupported1212 = 1212,

  kPLDLinkErrorNoEligibleAccounts1302 = 1302,
  kPLDLinkErrorNoEligibleAccounts1303 = 1303,
  kPLDLinkErrorNoEligibleAccounts1700 = 1700,
  kPLDLinkErrorNoEligibleAccounts1701 = 1701,
  kPLDLinkErrorNoEligibleAccounts1702 = 1702,
  kPLDLinkErrorNoEligibleAccounts1800 = 1800,
};

@interface PLDLinkError : NSError

+ (PLDLinkError *)errorWithCode:(NSInteger)code;

@end

