//
//  builtins.c
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

#include "builtins.h"

long int popcount(unsigned long long x) {
#if __has_builtin(__builtin_popcountll)
    return __builtin_popcountll(x);
#else
    long int count = 0;
    for (; x != 0; x &= x - 1) {
        count++;
    }
    return count;
#endif
}
