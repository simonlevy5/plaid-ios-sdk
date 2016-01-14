//
//  PLDInstitution.m
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//

#import "PLDInstitution.h"

#import "UIColor+Utilities.h"

@implementation PLDInstitution

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    _id = dictionary[@"id"];
    _name = dictionary[@"name"];
    _type = dictionary[@"type"];
    _hasMfa = [dictionary[@"has_mfa"] boolValue];
    _mfaOptions = dictionary[@"mfa"];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ - name: %@ type: %@ hasMfa: %d",
              [super description], self.name, self.type, self.hasMfa];
}

- (UIColor *)backgroundColor {
  // We use hardcoded values because some of the colors returned by the API are off.
  // TODO: Use API's color as fallback.
  NSDictionary *colors = [PLDInstitution backgroundColors];
  UIColor *bankColor = [colors objectForKey:self.type];
  return bankColor != nil ? bankColor : [UIColor darkGrayColor];
}

- (NSURL *)forgottenPasswordURL {
  NSDictionary *urls = [PLDInstitution forgottenPasswordURLs];
  NSString *bankURLString = [urls objectForKey:self.type];
  return bankURLString != nil ? [NSURL URLWithString:bankURLString] : nil;
}

- (NSURL *)accountLockedURL {
  NSDictionary *urls = [PLDInstitution accountLockedURLs];
  NSString *bankURLString = [urls objectForKey:self.type];
  return bankURLString != nil ? [NSURL URLWithString:bankURLString] : nil;
}

- (NSURL *)accountSetupURL {
  NSDictionary *urls = [PLDInstitution accountSetupURLS];
  NSString *bankURLString = [urls objectForKey:self.type];
  return bankURLString != nil ? [NSURL URLWithString:bankURLString] : nil;
}

- (BOOL)isProductAvailable:(PlaidProduct)product {
  NSDictionary *bankProductMapping = [PLDInstitution productAvailabilityMapping];
  NSArray *availableProducts = [bankProductMapping objectForKey:self.type];
  return [availableProducts containsObject:NSStringFromPlaidProduct(product)];
}

+ (NSDictionary *)backgroundColors {
  static NSDictionary *backgroundColors = nil;
  static dispatch_once_t oncePredicate;

  dispatch_once(&oncePredicate, ^{
    backgroundColors = @{
      @"amex": [UIColor colorWithRgbaRed:0 green:135 blue:196],
      @"bofa": [UIColor colorWithRgbaRed:233 green:45 blue:13],
      @"capone360": [UIColor colorWithRgbaRed:161 green:40 blue:49],
      @"chase": [UIColor colorWithRgbaRed:23 green:93 blue:165],
      @"citi": [UIColor colorWithRgbaRed:9 green:40 blue:105],
      @"fidelity": [UIColor colorWithRgbaRed:63 green:152 blue:26],
      @"nfcu": [UIColor colorWithRgbaRed:10 green:68 blue:125],
      @"pnc": [UIColor colorWithRgbaRed:14 green:105 blue:170],
      @"schwab": [UIColor colorWithRgbaRed:0 green:140 blue:218],
      @"suntrust": [UIColor colorWithRgbaRed:0 green:74 blue:128],
      @"svb": [UIColor colorWithRgbaRed:0 green:160 blue:228],
      @"td": [UIColor colorWithRgbaRed:33 green:170 blue:33],
      @"us": [UIColor colorWithRgbaRed:12 green:32 blue:116],
      @"usaa": [UIColor colorWithRgbaRed:0 green:54 blue:91],
      @"wells": [UIColor colorWithRgbaRed:230 green:34 blue:39]};
  });

  return backgroundColors;
}

+ (NSDictionary *)forgottenPasswordURLs {
  static NSDictionary *forgottenPasswordURLs = nil;
  static dispatch_once_t oncePredicate;

  dispatch_once(&oncePredicate, ^{
    forgottenPasswordURLs = @{
      @"amex": @"https://www209.americanexpress.com/oms/admin/unauth/passwordoptions.do?ssolang=en_US&ssobrand=SOMSET&mkt=001&SSOURL=http%3A%2F%2Fwww.americanexpress.com%2F",
      @"bofa": @"https://secure.bankofamerica.com/login/reset/entry/forgotPwdScreen.go",
      @"capone360": @"https://secure.capitalone360.com/myaccount/banking/forgot_cif_input.vm",
      @"chase": @"https://chaseonline.chase.com/Public/Reidentify/ReidentifyFilterView.aspx?LOB=RBGLogon",
      @"citi": @"https://online.citibank.com/US/JSO/uidn/RequestUserIDReminder.do",
      @"fidelity": @"https://fps.fidelity.com/ftgw/Fps/Fidelity/RtlCust/Resolve/Init",
      @"nfcu": @"https://www.navyfederal.org/forgot_password.html",
      @"pnc": @"https://www.onlinebanking.pnc.com/alservlet/ForgotUserIdServlet",
      @"schwab": @"https://client.schwab.com/Areas/Login/ForgotPassword/FYPIdentification.aspx",
      @"suntrust": @"https://onlinebanking.suntrust.com/UI/login#/forgotcredentials",
      @"svb": @"https://www.svb.com",
      @"td": @"https://onlinebanking.tdbank.com/default.asp",
      @"us": @"https://onlinebanking.usbank.com/Auth/LoginAssistanceDesktop/ContinueLas",
      @"usaa": @"https://www.usaa.com/inet/ent_proof/proofingEvent?action=Init&event=forgotPassword&wa_ref=pub_auth_nav_forgotpwd",
      @"wells": @"https://online.wellsfargo.com/das/channel/identifyDisplay"
    };
  });
  
  return forgottenPasswordURLs;
}

+ (NSDictionary *)accountLockedURLs {
  static NSDictionary *accountLockedURLs = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    accountLockedURLs = @{
      @"amex": @"https://online.americanexpress.com/myca/fuidfyp/us/action?request_type=NewPassword&AccountRevoked=1&brand=&ReqSource=https%3A%2F%2Fonline.americanexpress.com%2Fmyca%2Facctmgmt%2Fus%2Fmyaccountsummary.do%3Frequest_type%3Dauthreg_acctAccountSummary%26Face%3Den_US%26omnlogin%3Dus_homepage_myca&Face=en_US",
      @"bofa": @"https://securemessaging.bankofamerica.com/srt/help.do?appid=12",
      @"capone360": @"https://secure.capitalone360.com/myaccount/banking/forgotpassword?execution=e2s1&stateId=collectsecurityinfo",
      @"chase": @"https://chaseonline.chase.com/Public/Error.aspx?logonReason=sso_logon_loc&LOB=RBGLogon",
      @"citi": @"https://online.citibank.com/US/JSO/signon/uname/Next.do",
      @"fidelity": @"http://wps.fidelity.com/servlets/Help/newlog/trouble.html#question3",
      @"nfcu": @"https://www.navyfederal.org/",
      @"pnc": @"https://www.pnc.com",
      @"schwab": @"https://client.schwab.com/Login/SignOn/CustomerCenterLogin.aspx",
      @"suntrust": @"https://www.suntrust.com",
      @"svb": @"http://www.svb.com",
      @"td": @"http://www.tdbank.com/tdhelps/default.aspx/locked-out-of-account/v/38725563/",
      @"us": @"https://onlinebanking.usbank.com/Auth/LoginAssistanceDesktop/LoadLoginAssistance",
      @"usaa": @"https://mobile.usaa.com/inet/ent_auth_password/locked?akredirect=true",
      @"wells": @"https://www.wellsfargo.com/help/faqs/sign-on"
    };
  });
  
  return accountLockedURLs;
}

+ (NSDictionary *)accountSetupURLS {
  static NSDictionary *accountSetupURLs = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    accountSetupURLs = @{
      @"amex": @"https://www.americanexpress.com",
      @"bofa": @"https://secure.bankofamerica.com",
      @"capone360": @"https://secure.capitalone360.com",
      @"chase": @"https://chaseonline.chase.com",
      @"citi": @"https://online.citibank.com",
      @"fidelity": @"https://login.fidelity.com/ftgw/Fas/Fidelity/RtlCust/Login/Init",
      @"nfcu": @"https://www.navyfederal.org/",
      @"pnc": @"https://www.pnc.com",
      @"schwab": @"https://client.schwab.com/Login/SignOn/CustomerCenterLogin.aspx",
      @"suntrust": @"https://onlinebanking.suntrust.com/UI/login#/enrollment",
      @"svb": @"http://www.svb.com",
      @"td": @"https://onlinebanking.tdbank.com",
      @"us": @"https://onlinebanking.usbank.com",
      @"usaa": @"https://www.usaa.com/inet/ent_logon/Logon",
      @"wells": @"https://online.wellsfargo.com"
    };
  });

  return accountSetupURLs;
}

+ (NSDictionary *)productAvailabilityMapping {
  static NSDictionary *productAvailabilityMapping = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    productAvailabilityMapping = @{
     @"amex": @[
       @"balance",
       @"connect",
     ],
     @"bofa": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"capone360": @[
       @"auth",
       @"balance",
     ],
     @"chase": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"citi": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"fidelity": @[
       @"auth",
       @"balance",
       @"connect",
     ],
     @"nfcu": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"pnc": @[
       @"auth",
       @"connect",
       @"info"
     ],
     @"schwab": @[
       @"auth",
       @"balance"
     ],
     @"suntrust": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"svb": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"td": @[
       @"auth",
       @"balance",
       @"info"
     ],
     @"us": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"usaa": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
     @"wells": @[
       @"auth",
       @"balance",
       @"connect",
       @"info"
     ],
    };
  });
  
  return productAvailabilityMapping;
}

@end