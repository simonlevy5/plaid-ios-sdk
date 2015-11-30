//
//  PLDNetworkTests.m
//  Plaid Tests
//
//  Created by Simon Levy on 11/30/15.
//
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "Plaid.h"
#import "PLDMacros.h"
#import "PLDNetworkApi+Mocks.h"
#import "PLDUnitTest.h"

static NSString * const kTestHost = @"https://tartan.plaid.com/";
static NSString * const kTestPath = @"connect";
static NSString * const kTestMethod = @"POST";

@interface PLDNetworkTests : PLDUnitTest
@end

@implementation PLDNetworkTests {
  PLDNetworkApi *_networkApi;
}

- (void)setUp {
  [super setUp];
  
  _networkApi = [[PLDNetworkApi alloc] initWithEnvironment:PlaidEnvironmentTartan];
}

- (void)tearDown {
  [_networkApi stopMocking];
  _networkApi = nil;
  
  [super tearDown];
}

- (void)testApiError {
  [_networkApi setMockedNetworkData:[_networkApi randomApiError] responseCode:500 error:nil];

  XCTestExpectation *expectation = [self currentExpectation];
  [_networkApi executeRequestWithHost:kTestHost
                                 path:kTestPath
                               method:kTestMethod
                           parameters:nil
                           completion:^(id response, NSError *error) {
                             XCTAssertNil(response);
                             XCTAssertNotNil(error);
                             [expectation fulfill];
                           }];
  [self waitForTestExpectations];
}

- (void)testLinkError {
  [_networkApi setMockedNetworkData:[_networkApi linkError] responseCode:500 error:nil];
  
  XCTestExpectation *expectation = [self currentExpectation];
  [_networkApi executeRequestWithHost:kTestHost
                                 path:kTestPath
                               method:kTestMethod
                           parameters:nil
                           completion:^(id response, NSError *error) {
                             XCTAssertNil(response);
                             XCTAssertNotNil(error);
                             [expectation fulfill];
                           }];
  [self waitForTestExpectations];
}

@end
