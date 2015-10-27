//
//  PLDUnitTest.h
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#import <XCTest/XCTest.h>

@interface PLDUnitTest : XCTestCase

- (XCTestExpectation *)currentExpectation;
- (void)waitForTestExpectations;

@end
