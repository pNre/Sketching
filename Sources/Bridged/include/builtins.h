//
//  builtins.h
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

#ifndef builtins_h
#define builtins_h

/// Returns the number of 1-bits in x.
long int popcount(unsigned long long x);

/// Returns one plus the index of the least significant 1-bit of x, or if x is zero, returns zero.
long int ffs(unsigned long long x);

#endif /* builtins_h */
