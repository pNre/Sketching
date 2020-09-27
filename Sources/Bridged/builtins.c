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

long int ffs(unsigned long long x) {
#if __has_builtin(__builtin_ffsll)
    return __builtin_ffsll(x);
#else
    if (x == 0) {
        return 0;
    }

    long int count = 1;
    while (!(x & 1))
    {
        x >>= 1;
        count++;
    }
    return count;
#endif
}
