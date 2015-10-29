[![Build Status](https://magnum.travis-ci.com/vouch/plaid-ios-sdk.svg?token=d9FSzqpZpyWCYnF5YjqQ&branch=master)](https://magnum.travis-ci.com/vouch/plaid-ios-sdk)

## plaid-ios-sdk
Plaid iOS framework

A library to develop against the Plaid API from an iOS app. For more information about Plaid, visit [the website](http://plaid.com) or check out [the documentation](https://plaid.com/docs/).

## Getting Started

**Installation**

Add the following line to your Podfile:

    Pod 'plaid-ios-sdk'

Run 'pod install' and you should have the latest release.


**Usage**

    #import "Plaid.h"

    Plaid *plaid = [Plaid sharedInstance];
    [plaid setClientId:@"your_client_id" secret:@"your_secret"];
    
Extensive documentation contained in Plaid.h header file.

**License**

MIT [See included](https://github.com/vouch/plaid-ios-sdk/blob/master/LICENSE)
