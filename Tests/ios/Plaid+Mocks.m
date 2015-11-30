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

- (NSDictionary *)linkAuthResponseWithType:(NSString *)type {
  return [self linkResponseWithType:type status:@"connected" mfa:nil];
}

- (NSDictionary *)linkAuthChooseDeviceWithType:(NSString *)type {
  NSArray *mfa = @[
    @{
      @"type": @"email",
      @"mask": @"t..t@plaid.com"
    },
    @{
      @"type": @"phone",
      @"mask": @"xxx-xxx-5309"
    }
  ];
  return [self linkResponseWithType:type status:@"choose_device" mfa:mfa];
}

- (NSDictionary *)linkAuthRequiresCodeResponseWithType:(NSString *)type {
  NSString *mfa = @"Code sent to t..t@plaid.com";
  return [self linkResponseWithType:type status:@"requires_code" mfa:mfa];
}

- (NSDictionary *)linkAuthRequiresQuestionsResponseWithType:(NSString *)type {
  NSString *mfa = @"What type of bear is best?";
  return [self linkResponseWithType:type status:@"requires_questions" mfa:mfa];
}

- (NSDictionary *)linkAuthRequiresSelectionsResponseWithType:(NSString *)type {
  NSArray *mfa = @[
    @{
      @"question": @"What type of bear is best?",
      @"answers": @[
        @"false",
        @"black bear"
      ]
    },
  ];
  return [self linkResponseWithType:type status:@"requires_selections" mfa:mfa];
}

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

- (NSDictionary *)randomLongTailInstitutionObject {
  return @{
    @"id" : [NSString stringWithFormat:@"%d", rand()],
    @"name" : [NSString stringWithFormat:@"%d", rand()],
    @"products" : @{
      @"auth" : @(YES),
      @"balance" : @(YES),
      @"connect" : @(YES),
      @"info" : @(YES)
    },
    @"forgottenPassword" : [NSString stringWithFormat:@"http://www.%d.com", rand()],
    @"accountLocked" :  [NSString stringWithFormat:@"http://www.%d.com", rand()],
    @"accountSetup" :  [NSString stringWithFormat:@"http://www.%d.com", rand()],
    @"video" : [NSString stringWithFormat:@"%d", rand()],
    @"fields" : @[
      @{
        @"name" : @"username",
        @"label" : @"Username",
        @"type" : @"text"
      },
      @{
        @"name" : @"password",
        @"label" : @"Password",
        @"type" : @"password"
      }
    ],
    @"colors" : @{
      @"primary" : @"rgba(0,135,196,1)",
      @"darker" : @"rgba(0,84,122,1)",
      @"gradient" : @[
        @"rgba(0,135,196,1)",
        @"rgba(0,84,122,1)"
      ]
    },
    @"logo" : [self logoDataString],
    @"nameBreak" : @(rand()),
  };
}

- (void)setMockedResponse:(id)mockedResponse {
  id mockedNetwork = OCMPartialMock(self.networkApi);
  [[[mockedNetwork stub] andDo:^(NSInvocation *invocation) {
    PLDNetworkCompletion block;
    [invocation getArgument:&block atIndex:6];  // See PLDNetwork completion for indices. Note: First two are self and _cmd (NSInvocation).
    block(mockedResponse, nil);
  }] executeRequestWithHost:[OCMArg any]
      path:[OCMArg any] method:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
}

#pragma mark - Private

- (NSDictionary *)linkResponseWithType:(NSString *)type
                                status:(NSString *)status
                                   mfa:(id)mfa {
  if (!mfa) {
    mfa = @"null";
  }
  return @{
    @"status" : status,
    @"public_token" : [self publicTokenWithType:type status:status],
    @"institution_data" : @{},
    @"mfa" : mfa,
    @"request_id" : [NSString stringWithFormat:@"%d", rand()]
  };
}

- (NSString *)publicTokenWithType:(NSString *)type status:(NSString *)status {
  return [NSString stringWithFormat:@"test,%@,%@", type, status];
}

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

- (NSString *)logoDataString {
  return @"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";
}

@end
