//
//  Plaid.m
//  Plaid
//
//  Created by Simon Levy on 9/26/15.
//

#import "Plaid.h"

#import "PLDNetworkApi.h"

static Plaid *sInstance = nil;

static NSString * LinkHostForEnvironment(PlaidEnvironment environment) {
  switch (environment) {
    case PlaidEnvironmentTartan:
      return kPlaidLinkHostTartan;
    case PlaidEnvironmentProduction:
      return kPlaidLinkHostProduction;
    default:
      break;
  }
  return nil;
}

@implementation Plaid {
  PlaidEnvironment _environment;
  NSString *_publicKey;

  PLDNetworkApi *_networkApi;
}

@synthesize environment = _environment;

+ (Plaid *)sharedInstance {
  if (!sInstance) {
    sInstance = [[Plaid alloc] initWithEnvironment:PlaidEnvironmentTartan];
  }
  return sInstance;
}

- (void)setEnvironment:(PlaidEnvironment)environment {
  if (_environment != environment) {
    _networkApi = [[PLDNetworkApi alloc] initWithEnvironment:environment];
  }
  _environment = environment;
}

- (instancetype)initWithEnvironment:(PlaidEnvironment)environment {
  if (self = [super init]) {
    _networkApi = [[PLDNetworkApi alloc] initWithEnvironment:environment];
    _environment = environment;
  }
  return self;
}

- (void)setPublicKey:(NSString *)publicKey {
  NSAssert([publicKey length] > 0, @"Must set public token to a non-empty value");
  
  _publicKey = publicKey;
}

#pragma mark - Generic endpoints

- (void)getCategoryByCategoryId:(NSString *)categoryId
                     completion:(PlaidCompletion)completion {
  NSString *path = [NSString stringWithFormat:@"categories/%@", categoryId];
  [_networkApi executeRequestWithPath:path
                               method:@"GET"
                           parameters:nil
                           completion:^(NSDictionary *response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             PLDCategory *category =
                                [[PLDCategory alloc] initWithCategoryDictionary:response];
                             completion(category, nil);
                           }];
}

- (void)getCategoriesWithCompletion:(PlaidCompletion)completion {
  [_networkApi executeRequestWithPath:@"categories"
                               method:@"GET"
                           parameters:nil
                           completion:^(NSDictionary *response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             NSMutableArray *categories =
                                 [NSMutableArray arrayWithCapacity:response.count];
                             for (NSDictionary *category in response) {
                               PLDCategory *obj =
                                  [[PLDCategory alloc] initWithCategoryDictionary:category];
                               [categories addObject:obj];
                             }
                             completion(categories, nil);
                           }];
}

- (void)getInstitutionById:(NSString *)institutionId
                completion:(PlaidCompletion)completion {
  NSString *path = [NSString stringWithFormat:@"institutions/%@", institutionId];
  [_networkApi executeRequestWithPath:path
                               method:@"GET"
                           parameters:nil
                           completion:^(NSDictionary *response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             PLDInstitution *institution = [[PLDInstitution alloc] initWithDictionary:response];
                             completion(institution, nil);
                           }];
}

- (void)getInstitutionsWithCompletion:(PlaidCompletion)completion {
  [_networkApi executeRequestWithPath:@"institutions"
                               method:@"GET"
                           parameters:nil
                           completion:^(NSArray *response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[response count]];
                             for (NSDictionary *institution in response) {
                               [objects addObject:[[PLDInstitution alloc] initWithDictionary:institution]];
                             }
                             completion(objects, nil);
                           }];
}

- (void)getLongTailInstitutionsWithQuery:(NSString *)query
                                 product:(PlaidProduct)product
                              completion:(PlaidCompletion)completion {
  NSCharacterSet *alphaCharacters = [NSCharacterSet alphanumericCharacterSet];
  NSString *urlEncodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:alphaCharacters];
  NSString *path = [NSString stringWithFormat:@"institutions/search?q=%@", urlEncodedQuery];
  if (product) {
    path = [path stringByAppendingString:[NSString stringWithFormat:@"&p=%@", NSStringFromPlaidProduct(product)]];
  }
  [_networkApi executeRequestWithPath:path
                               method:@"GET"
                           parameters:nil
                           completion:^(id response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             
                             NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[response count]];
                             for (NSDictionary *institution in response) {
                               [objects addObject:[[PLDLongTailInstitution alloc] initWithDictionary:institution]];
                             }
                             completion(objects, nil);
  }];
}

- (void)getLongTailInstitutionsById:(NSString *)institutionId
                         completion:(PlaidCompletion)completion {
  NSString *path = [NSString stringWithFormat:@"institutions/search?id=%@", institutionId];
  [_networkApi executeRequestWithPath:path
                               method:@"GET"
                           parameters:nil
                           completion:^(id response, NSError *error) {
                             if (error) {
                               completion(nil, error);
                               return;
                             }
                             
                             NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[response count]];
                             for (NSDictionary *institution in response) {
                               [objects addObject:[[PLDLongTailInstitution alloc] initWithDictionary:institution]];
                             }
                             completion(objects, nil);
                           }];
}

#pragma mark - Plaid Link endpoints

- (void)addLinkUserForProduct:(PlaidProduct)product
                     username:(NSString *)username
                     password:(NSString *)password
                         type:(NSString *)type
                      options:(NSDictionary *)options
                   completion:(PlaidMfaCompletion)completion {
  [self addLinkUserForProduct:product
                     username:username
                     password:password
                          pin:nil
                         type:type
                      options:options
                   completion:completion];
}

- (void)addLinkUserForProduct:(PlaidProduct)product
                     username:(NSString *)username
                     password:(NSString *)password
                          pin:(NSString *)pin
                         type:(NSString *)type
                      options:(NSDictionary *)options
                   completion:(PlaidMfaCompletion)completion {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{
    @"env" : NSStringFromPlaidEnviroment(_environment),
    @"include_accounts": @(NO),
    @"institution_type": type,
    @"username": username,
    @"password": password,
    @"product": NSStringFromPlaidProduct(product),
    @"public_key": _publicKey,
  }];
  if (options[@"webhook"]) {
    parameters[@"webhook"] = options[@"webhook"];
  }
  if (pin) {
    parameters[@"pin"] = pin;
  }
  [_networkApi executeRequestWithHost:LinkHostForEnvironment(_environment)
                                 path:@"authenticate"
                               method:@"POST"
                           parameters:parameters
                           completion:^(id response, NSError *error) {
    if (error) {
      completion(nil, response, error);
      return;
    }
   
    PLDLinkAuthentication *authentication =
        [[PLDLinkAuthentication alloc] initWithProduct:product
                                              response:response];
    completion(authentication, response, error);
  }];
}



- (void)stepLinkUserForProduct:(PlaidProduct)product
                   publicToken:(NSString *)publicToken
                   mfaResponse:(id)mfaResponse
                       options:(NSDictionary *)options
                    completion:(PlaidMfaCompletion)completion {
  NSString *webhook = @"";
  if (options[@"webhook"]) {
    webhook = options[@"webhook"];
  }
  NSDictionary *parameters = @{
    @"env" : NSStringFromPlaidEnviroment(_environment),
    @"include_accounts": @(NO),
    @"mfa": mfaResponse,
    @"product": NSStringFromPlaidProduct(product),
    @"public_key": _publicKey,
    @"public_token": publicToken,
    @"webhook": webhook
  };
  [_networkApi executeRequestWithHost:LinkHostForEnvironment(_environment)
                                 path:@"authenticate/mfa"
                               method:@"POST"
                           parameters:parameters
                           completion:^(id response, NSError *error) {
    if (error) {
     completion(nil, response, error);
     return;
    }

    PLDLinkAuthentication *authentication =
        [[PLDLinkAuthentication alloc] initWithProduct:product
                                              response:response];
    completion(authentication, response, error);
  }];
}

@end
