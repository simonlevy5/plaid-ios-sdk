//
//  PLDNetworkApi+Mocks.m
//  Plaid Tests
//
//  Created by Simon Levy on 11/30/15.
//
//

#import "PLDNetworkApi+Mocks.h"

#import <OCMock/OCMock.h>

@implementation PLDNetworkApi (Mocks)

- (NSDictionary *)linkError {
  return @{
    @"error" : @"Internal server error",
    @"requestId" : [NSString stringWithFormat:@"%d", rand()]
  };
}

- (NSDictionary *)randomApiError {
  return @{
    @"code" : @(500),
    @"message" : @"Error message",
    @"resolve" : @"Fix the error"
  };
}

- (void)setMockedNetworkData:(id)data responseCode:(NSUInteger)responseCode error:(NSError *)error {
  if (data) {
    NSError *jsonError;
    data = [NSJSONSerialization dataWithJSONObject:data options:0 error:&jsonError];
  }

  NSURL *url = [NSURL URLWithString:@""];
  NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                        statusCode:responseCode
                                                       HTTPVersion:@""
                                                      headerFields:nil];
  NSURLSession *session = [NSURLSession sharedSession];
  id mockedSession = OCMPartialMock(session);
  [[[mockedSession stub] andDo:^(NSInvocation *invocation) {
    void (^block)(NSData * __nullable data,
                  NSURLResponse * __nullable response,
                  NSError * __nullable error);
    [invocation getArgument:&block atIndex:3];
    block(data, response, error);
  }] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
}

- (void)stopMocking {
  NSURLSession *session = [NSURLSession sharedSession];
  id mockedSession = OCMPartialMock(session);
  [mockedSession stopMocking];
}

@end
