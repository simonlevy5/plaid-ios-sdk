//
//  PLDMacros.h
//  Plaid Tests
//
//  Created by Simon Levy on 10/26/15.
//
//

#ifndef PLDMacros_h
#define PLDMacros_h

#define weakify(var) \
  __weak __typeof__(var) var ## _weak = var; \

#define strongify(var) \
  __strong __typeof__(var) var = var ## _weak; \

#endif /* PLDMacros_h */
