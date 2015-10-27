//
//  PLDUnitTest.m
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#import "PLDUnitTest.h"

static NSTimeInterval const kAsyncTimeout = 5.0;

@implementation PLDUnitTest

- (XCTestExpectation *)currentExpectation {
  NSInvocation *invocation = self.invocation;
  NSString *selectorName =
      invocation ? NSStringFromSelector(invocation.selector) : @"testExpectation";
  return [self expectationWithDescription:selectorName];
}

- (void)waitForTestExpectations {
  [self waitForExpectationsWithTimeout:kAsyncTimeout handler:nil];
}

@end
