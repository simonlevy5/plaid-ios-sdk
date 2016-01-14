//
//  PLDNetworkApi.m
//  Plaid
//
//  Created by Simon Levy on 9/30/15.
//

#import "PLDNetworkApi.h"

#import "PLDLinkError.h"

static NSString * const kPlaidTartanHost = @"https://tartan.plaid.com/";
static NSString * const kPlaidProductionHost = @"https://api.plaid.com/";

NSString * kPlaidLinkHostTartan = @"https://link-tartan.plaid.com/";
NSString * kPlaidLinkHostProduction = @"https://link.plaid.com/";

static NSString * const kPlaidErrorDomain = @"com.parse";

@implementation PLDNetworkApi {
  NSString *_host;
}

- (instancetype)initWithEnvironment:(PlaidEnvironment)environment {
  if (self = [super init]) {
    switch (environment) {
      case PlaidEnvironmentTartan:
        _host = kPlaidTartanHost;
        break;
      case PlaidEnvironmentProduction:
        _host = kPlaidProductionHost;
        break;
      default:
        NSAssert(NO, @"Plaid environment doesn't exist.");
        break;
    }
  }
  return self;
}

- (void)executeRequestWithPath:(NSString *)path
                        method:(NSString *)method
                    parameters:(NSDictionary *)parameters
                    completion:(PLDNetworkCompletion)completion {
  [self executeRequestWithHost:_host
                          path:path
                        method:method
                    parameters:parameters
                    completion:completion];
}

- (void)executeRequestWithHost:(NSString *)host
                          path:(NSString *)path
                        method:(NSString *)method
                    parameters:(NSDictionary *)parameters
                    completion:(PLDNetworkCompletion)completion {
  NSString *urlString = [NSString stringWithFormat:@"%@%@", host, path];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  request.HTTPMethod = method;
  if (parameters) {
    NSError *jsonSerializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:0
                                                     error:&jsonSerializationError];
    if (jsonSerializationError) {
      completion(nil, jsonSerializationError);
      return;
    }
    request.HTTPBody = data;
  }

  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request
             completionHandler:^(NSData *data,
                                 NSURLResponse *response,
                                 NSError *error) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, error);
      });
      return;
    }

    NSError *jsonParsingError = nil;
    id responseData = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&jsonParsingError];
    if (jsonParsingError) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, jsonParsingError);
      });
      return;
    }

    NSError *plaidError = [self errorFromResponse:response data:responseData];
    if (plaidError) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, plaidError);
      });
      return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      completion(responseData, nil);
    });
  }] resume];
}

- (NSError *)errorFromResponse:(NSURLResponse *)response data:(id)responseData {
  if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
    return nil;
  }
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode < 400) {
    return nil;
  }

  // Plaid Link error
  NSString *errorString = responseData[@"error"];
  if ([errorString length] > 0) {
    NSInteger plaidLinkErrorCode = [responseData[@"code"] integerValue];
    return [PLDLinkError errorWithCode:plaidLinkErrorCode];
  }

  NSInteger plaidErrorCode = [responseData[@"code"] integerValue];
  NSDictionary *underlyingUserInfo = @{
    NSLocalizedDescriptionKey : responseData[@"resolve"]
  };
  NSError *underlyingError = [[NSError alloc] initWithDomain:kPlaidErrorDomain
                                                        code:plaidErrorCode
                                                    userInfo:underlyingUserInfo];
  NSDictionary *userInfo = @{
    NSLocalizedDescriptionKey : responseData[@"message"],
    NSLocalizedRecoverySuggestionErrorKey : responseData[@"resolve"],
    NSUnderlyingErrorKey : underlyingError
  };
  return [NSError errorWithDomain:kPlaidErrorDomain code:httpResponse.statusCode userInfo:userInfo];
}

@end
