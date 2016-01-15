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
#import "PLDLinkError.h"
#import "PLDMacros.h"
#import "PLDNetworkApi.h"
#import "PLDUnitTest.h"

static NSString *const kTestUsername = @"plaid_test";
static NSString *const kTestUsernameSelections = @"plaid_selections";
static NSString *const kTestType = @"wells";
static NSString *const kTestAccessToken = @"test_wells";
static NSString *const kTestPassword = @"plaid_good";
static NSString *const kTestPin = @"1234";

@interface PlaidTests : PLDUnitTest
@end

@implementation PlaidTests {
  Plaid *_plaid;
}

- (void)setUp {
  [super setUp];

  _plaid = [Plaid sharedInstance];
  [_plaid setPublicKey:@"test_key"];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSettingNilAuthValues {
  XCTAssertThrows([_plaid setPublicKey:nil]);
}

- (void)testLinkAddUserSuccess {
  [_plaid setMockedResponse:[_plaid linkAuthResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       XCTAssertEqual([authentication class], [PLDLinkAuthentication class]);
                       XCTAssertTrue([[authentication accessToken] isEqualToString:@"test,wells,connected"]);
                       [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserWithOptionsSuccess {
  [_plaid setMockedResponse:[_plaid linkAuthResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:@{ @"webhook" : @"https://blah.com", @"random" : @(true) }
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       XCTAssertEqual([authentication class], [PLDLinkAuthentication class]);
                       XCTAssertTrue([[authentication accessToken] isEqualToString:@"test,wells,connected"]);
                       [expectation fulfill];
                     }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserWithPinSuccess {
  [_plaid setMockedResponse:[_plaid linkAuthResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                            pin:kTestPin
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       XCTAssertEqual([authentication class], [PLDLinkAuthentication class]);
                       XCTAssertTrue([[authentication accessToken] isEqualToString:@"test,wells,connected"]);
                       [expectation fulfill];
                     }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserMFAChooseDevice {
  [_plaid setMockedResponse:[_plaid linkAuthChooseDeviceWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"choose_device"
                                                 type:kPLDMFATypeList
                                                class:[NSArray class]];
                       XCTAssertTrue([[[authentication.mfa.data firstObject] choice]
                                         isKindOfClass:[NSString class]]);
                       [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserMFARequiresCode {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresCodeResponseWithType:kTestType]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_code"
                                                 type:kPLDMFATypeCode
                                                class:[NSString class]];
                       [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserMFAQuestions {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresQuestionsResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_questions"
                                                 type:kPLDMFATypeQuestion
                                                class:[NSString class]];
                       [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testLinkAddUserMFASelections {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresSelectionsResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid addLinkUserForProduct:PlaidProductAuth
                       username:kTestUsername
                       password:kTestPassword
                           type:kTestType
                        options:nil
                     completion:^(PLDAuthentication *authentication,
                                  id response,
                                  NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_selections"
                                                 type:kPLDMFATypeSelection
                                                class:[NSArray class]];
                       [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testLinkStepUserSuccess {
  [_plaid setMockedResponse:[_plaid linkAuthResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepLinkUserForProduct:PlaidProductAuth
                     publicToken:@"test,wells,requires_code"
                     mfaResponse:@"1234"
                         options:nil
                      completion:^(PLDAuthentication *authentication,
                                   id response,
                                   NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       XCTAssertEqual([authentication class], [PLDLinkAuthentication class]);
                       XCTAssertTrue([[authentication accessToken] isEqualToString:@"test,wells,connected"]);
                       [expectation fulfill];
                     }];
  [self waitForTestExpectations];
}

- (void)testLinkStepUserRequiresCode {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresCodeResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepLinkUserForProduct:PlaidProductAuth
                     publicToken:@"test,wells,choose_device"
                     mfaResponse:@{ @"type": @"email" }
                         options:nil
                      completion:^(PLDAuthentication *authentication,
                                   id response,
                                   NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_code"
                                                 type:kPLDMFATypeCode
                                                class:[NSString class]];
                       [expectation fulfill];
                     }];
  [self waitForTestExpectations];
}

- (void)testLinkStepUserRequiresQuestions {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresQuestionsResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepLinkUserForProduct:PlaidProductAuth
                     publicToken:@"test,wells,requires_code"
                     mfaResponse:@{ @"type": @"email" }
                         options:nil
                      completion:^(PLDAuthentication *authentication,
                                   id response,
                                   NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_questions"
                                                 type:kPLDMFATypeQuestion
                                                class:[NSString class]];
                       [expectation fulfill];
                     }];
  [self waitForTestExpectations];
}

- (void)testLinkStepUserRequiresSelections {
  [_plaid setMockedResponse:[_plaid linkAuthRequiresSelectionsResponseWithType:kTestType]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid stepLinkUserForProduct:PlaidProductAuth
                     publicToken:@"test,wells,requires_code"
                     mfaResponse:@{ @"type": @"email" }
                         options:nil
                      completion:^(PLDAuthentication *authentication,
                                   id response,
                                   NSError *error) {
                       strongify(self);
                       XCTAssertNil(error);
                       [self verifyLinkAuthentication:authentication
                                           withStatus:@"requires_selections"
                                                 type:kPLDMFATypeSelection
                                                class:[NSArray class]];
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

- (void)testGetLongTailInstitutionsWithQuery {
  [_plaid setMockedResponse:@[
    [_plaid randomLongTailInstitutionObject],
    [_plaid randomLongTailInstitutionObject]
  ]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getLongTailInstitutionsWithQuery:@"query"
                                   product:0
                                completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([[response firstObject] class], [PLDLongTailInstitution class]);
    XCTAssertGreaterThan([response count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetLongTailInstitutionsWithQueryAndFilter {
  [_plaid setMockedResponse:@[
    [_plaid randomLongTailInstitutionObject],
    [_plaid randomLongTailInstitutionObject]
  ]];

  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getLongTailInstitutionsWithQuery:@"query"
                                   product:PlaidProductConnect
                                completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([[response firstObject] class], [PLDLongTailInstitution class]);
    XCTAssertGreaterThan([response count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testGetLongTailInstitutionsById {
  [_plaid setMockedResponse:@[
    [_plaid randomLongTailInstitutionObject],
    [_plaid randomLongTailInstitutionObject]
  ]];
  
  XCTestExpectation *expectation = [self currentExpectation];
  weakify(self);
  [_plaid getLongTailInstitutionsById:@"id" completion:^(id response, NSError *error) {
    strongify(self);
    XCTAssertNotNil(response);
    XCTAssertEqual([[response firstObject] class], [PLDLongTailInstitution class]);
    XCTAssertGreaterThan([response count], 0);
    [expectation fulfill];
  }];
  [self waitForTestExpectations];
}

- (void)testErrorStringLoading {
  NSInteger missingCredentialsCode = 1005;
  PLDLinkError *error = [PLDLinkError errorWithCode:missingCredentialsCode];

  XCTAssertTrue([[error localizedDescription] isEqualToString:@"Credentials missing"]);
  XCTAssertTrue([[error localizedFailureReason]
                   isEqualToString:@"Please provide a username and password."]);
  XCTAssertTrue([[error localizedRecoverySuggestion] isEqualToString:@"Retry login"]);
}

- (void)testGenericErrorStringLoading {
  NSInteger unknownCode = 1255;
  PLDLinkError *error = [PLDLinkError errorWithCode:unknownCode];

  XCTAssertTrue([[error localizedDescription]
                    isEqualToString:@"Please try connecting a different account"]);
  XCTAssertTrue([[error localizedFailureReason]
                   isEqualToString:@"There was an problem processing your request. Your account could not be connected at this time."]);
  XCTAssertTrue([[error localizedRecoverySuggestion] isEqualToString:@"Restart"]);
}

#pragma mark - Utilities

- (void)verifyLinkAuthentication:(PLDAuthentication *)authentication
                      withStatus:(NSString *)status
                            type:(PLDMFAType)type
                           class:(Class)class {
  NSString *token = [NSString stringWithFormat:@"test,wells,%@", status];
  XCTAssertEqual([authentication class], [PLDLinkAuthentication class]);
  XCTAssertTrue([[authentication accessToken] isEqualToString:token]);
  XCTAssertEqual([[authentication mfa] type], type);
  XCTAssertTrue([[[authentication mfa] data] isKindOfClass:class]);
}

@end
