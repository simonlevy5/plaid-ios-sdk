//
//  PlaidTests.m
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "Plaid.h"
#import "Plaid+Mocks.h"
#import "PLDMacros.h"
#import "PLDNetworkApi.h"
#import "PLDUnitTest.h"

static NSString *const kTestUsername = @"plaid_test";
static NSString *const kTestUsernameSelections = @"plaid_selections";
static NSString *const kTestType = @"wells";
static NSString *const kTestAccessToken = @"test_wells";
static NSString *const kTestPassword = @"plaid_good";

@interface PlaidTests : PLDUnitTest
@end

@implementation PlaidTests {
  Plaid *_plaid;
}

- (void)setUp {
  [super setUp];

  _plaid = [Plaid sharedInstance];
  [_plaid setClientId:@"test_id" secret:@"test_secret"];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSettingNilAuthValues {
  XCTAssertThrows([_plaid setClientId:nil secret:nil]);
  XCTAssertThrows([_plaid setClientId:@"" secret:nil]);
  XCTAssertThrows([_plaid setClientId:nil secret:@""]);
}

- (void)testAddAuthUser {
  [_plaid setMockedResponse:[_plaid exampleAuthResponse]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addAuthUserWithUsername:kTestUsername
                         password:kTestPassword
                             type:kTestType
                          options:nil
                       completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                        strongify(self);
                        XCTAssertNil(error);
                        XCTAssertNotNil(authentication);
                        XCTAssertEqual([response class], [PLDAuthResponse class]);
                        XCTAssertGreaterThan([[response accounts] count], 0);
                        [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testStepAuthUser {
  [_plaid setMockedResponse:[_plaid exampleAuthResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepAuthUserWithAccessToken:kTestAccessToken
                          mfaResponse:@"test"
                              options:nil
                           completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                             strongify(self);
                             XCTAssertNil(error);
                             XCTAssertNotNil(authentication);
                             XCTAssertEqual([response class], [PLDAuthResponse class]);
                             XCTAssertGreaterThan([[response accounts] count], 0);
                             [expectation fulfill];
                           }];
  [self waitForTestExpectations];
}

- (void)testGetAuthUser {
  [_plaid setMockedResponse:[_plaid exampleAuthResponse]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getAuthUserWithAccessToken:kTestAccessToken completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertGreaterThan([[response accounts] count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testPatchAuthUser {
  [_plaid setMockedResponse:[_plaid exampleAuthResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid patchAuthUserWithAccessToken:kTestAccessToken
                              username:kTestUsername
                              password:kTestPassword
                            completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                              strongify(self);
                              XCTAssertNotNil(response);
                              XCTAssertNotNil(authentication);
                              XCTAssertGreaterThan([[response accounts] count], 0);
                              [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testDeleteAuthUser {
  [_plaid setMockedResponse:@{}];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid deleteAuthUserWithAccessToken:kTestAccessToken completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testAddConnectUser {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addConnectUserWithUsername:kTestUsername
                            password:kTestPassword
                                type:kTestType
                             options:nil
                          completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                            strongify(self);
                            XCTAssertNotNil(response);
                            XCTAssertNotNil(authentication);
                            XCTAssertGreaterThan([[response accounts] count], 0);
                            XCTAssertGreaterThan([[response transactions] count], 0);
                            [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetConnectUser {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addConnectUserWithUsername:kTestUsername
                            password:kTestPassword
                                type:kTestType
                             options:nil
                          completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                            strongify(self);
                            XCTAssertNotNil(response);
                            XCTAssertNotNil(authentication);
                            XCTAssertGreaterThan([[response accounts] count], 0);
                            XCTAssertGreaterThan([[response transactions] count], 0);
                            [expectation fulfill];
                          }];
  [self waitForTestExpectations];
}

- (void)testStepConnectUser {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepConnectUserWithAccessToken:kTestAccessToken
                             mfaResponse:@"test"
                                 options:nil
                              completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                                strongify(self);
                                XCTAssertNotNil(response);
                                XCTAssertNotNil(authentication);
                                XCTAssertGreaterThan([[response accounts] count], 0);
                                XCTAssertGreaterThan([[response transactions] count], 0);
                                [expectation fulfill];
                              }];
  [self waitForTestExpectations];
}

- (void)testPatchConnectUser {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid patchConnectUserWithAccessToken:kTestAccessToken
                                 username:kTestUsername
                                 password:kTestPassword
                               completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                                 strongify(self);
                                 XCTAssertNotNil(response);
                                 XCTAssertNotNil(authentication);
                                 XCTAssertGreaterThan([[response accounts] count], 0);
                                 XCTAssertGreaterThan([[response transactions] count], 0);
                                 [expectation fulfill];
                          }];
  [self waitForTestExpectations];
}

- (void)testDeleteConnectUser {
  [_plaid setMockedResponse:@{}];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid deleteAuthUserWithAccessToken:kTestAccessToken
                             completion:^(id response, NSError *error) {
                               strongify(self);
                               XCTAssertNotNil(response);
                               [expectation fulfill];
                          }];
  [self waitForTestExpectations];
}

- (void)testGetCategoryById {
  [_plaid setMockedResponse:[_plaid randomCategoryObject]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getCategoryByCategoryId:@"103910" completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([response class], [PLDCategory class]);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetCategories {
  [_plaid setMockedResponse:@[
    [_plaid randomCategoryObject],
    [_plaid randomCategoryObject]
  ]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getCategoriesWithCompletion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([[response firstObject] class], [PLDCategory class]);
    XCTAssertGreaterThan([response count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetInstitutionById {
  [_plaid setMockedResponse:[_plaid randomInstitutionObject]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getInstitutionById:@"204924" completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([response class], [PLDInstitution class]);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetInstitution {
  [_plaid setMockedResponse:@[
    [_plaid randomInstitutionObject],
    [_plaid randomInstitutionObject]
  ]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getInstitutionsWithCompletion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([[response firstObject] class], [PLDInstitution class]);
    XCTAssertGreaterThan([response count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testExchangePublicToken {
  [_plaid setMockedResponse:@{ @"access_token" : @"test_access_token" }];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid exchangePublicToken:@"public_token" completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response[@"access_token"]);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetBalance {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getBalanceWithAccessToken:kTestAccessToken completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response[@"accounts"]);
    XCTAssertNotNil(response[@"transactions"]);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testUpgradeUser {
  [_plaid setMockedResponse:[_plaid exampleConnectResponse]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid upgradeUserWithAccessToken:kTestAccessToken
                           upgradeTo:PlaidProductConnect
                          completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                            strongify(self);
                            XCTAssertNotNil(response);
                            XCTAssertNotNil(authentication);
                            XCTAssertNotNil(response[@"accounts"]);
                            XCTAssertNotNil(response[@"transactions"]);
                            [expectation fulfill];
                          }];
  [self waitForTestExpectations];
}

@end
