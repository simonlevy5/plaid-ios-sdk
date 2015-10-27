//
//  Plaid+Mocks.m
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#import "Plaid+Mocks.h"

#import <OCMock/OCMock.h>

#import "PLDNetworkApi.h"

@implementation Plaid (Mocks)

- (NSDictionary *)exampleAuthResponse {
  return @{
    @"access_token" : @"test_wells",
    @"accounts" : @[
      [self randomAccountObject],
      [self randomAccountObject],
    ],
  };
}

- (NSDictionary *)exampleConnectResponse {
  return @{
    @"access_token" : @"test_wells",
    @"accounts" : @[
      [self randomAccountObject]
    ],
    @"transactions" : @[
      [self randomConnectResponse]
    ]
  };
}

- (NSDictionary *)randomCategoryObject {
  return @{
    @"type" : @"place",
    @"hierarchy" : @[
       @"Recreation",
       @"Arts & Entertainment",
       @"Circuses and Carnivals"
    ],
    @"id" : [NSString stringWithFormat:@"%d", rand()]
  };
}

- (NSDictionary *)randomInstitutionObject {
  return @{
    @"id" : [NSString stringWithFormat:@"%d", rand()],
    @"name" : [NSString stringWithFormat:@"%d", rand()],
    @"type" : [NSString stringWithFormat:@"%d", rand()],
    @"has_mfa" : @(YES),
    @"mfa" : @[
      @"code"
    ]
  };
}

- (void)setMockedResponse:(id)mockedResponse {
  id mockedNetwork = OCMPartialMock(self.networkApi);
  [[[mockedNetwork stub] andDo:^(NSInvocation *invocation) {
    PLDNetworkCompletion block;
    [invocation getArgument:&block atIndex:5];  // See PLDNetwork completion for indices. Note: First two are self and _cmd (NSInvocation).
    block(mockedResponse, nil);
  }] executeRequestWithPath:[OCMArg any]
   method:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
}

#pragma mark - Private

- (NSDictionary *)randomAccountObject {
  return @{
    @"_id" : [NSString stringWithFormat:@"_%d", rand()],
    @"_item" : [NSString stringWithFormat:@"_%d", rand()],
    @"_user" : [NSString stringWithFormat:@"_%d", rand()],
    @"balance" : @{
        @"available" : @(rand()),
        @"current" : @(rand()),
    },
    @"institution_type" : @"fake_institution",
    @"meta" : @{
      @"limit": @(rand()),
      @"number" : [NSString stringWithFormat:@"%d", rand()],
      @"name" : @"Plaid Credit Card"
    },
    @"subtype" : @"credit",
    @"type" : @"credit",
  };
}

- (NSDictionary *)randomConnectResponse {
  return @{
    @"_account" : [NSString stringWithFormat:@"_%d", rand()],
    @"_id" : [NSString stringWithFormat:@"_%d", rand()],
    @"amount" : @(rand()),
    @"date" : @"",
    @"name" : @"Golden Crepes",
    @"meta" : @{
      @"location" : @{
        @"coordinates" : @{
          @"lat" : @(40.740352),
          @"long" : @(-74.001761)
        },
        @"state" : @"NY",
        @"city" : @"New York",
        @"address" : @"262 W 15th St"
      }
    },
    @"pending" : @(NO),
    @"score" : @{
      @"master" : @(1),
      @"detail" : @{
        @"address" : @(1),
        @"city" : @(1),
        @"name" : @(1),
        @"state" : @(1)
      }
    },
    @"type" : @{
      @"primary" : @"place"
    },
    @"category" : @[
      @"Food and Drink",
      @"Restaurants"
    ],
    @"category_id" : [NSString stringWithFormat:@"%d", rand()],
  };
}

@end
