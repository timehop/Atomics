//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

#import "HOPAtomicBoolean.h"

#import <libkern/OSAtomic.h>


#pragma mark -

@implementation HOPAtomicBoolean {
    volatile int32_t _underlying;
}

#pragma mark Creation

- (instancetype)init {
    return [self initWithValue:NO];
}

- (instancetype)initWithValue:(BOOL)value {
    self = [super init];
    if (self != nil) {
        _underlying = value ? 1 : 0;
    }

    return self;
}

#pragma mark Atomic value access

- (BOOL)getValue {
    return _underlying != 0;
}

- (void)setValue:(BOOL)value {
    _underlying = value ? 1 : 0;
}

- (BOOL)compareTo:(BOOL)expected andSetValue:(BOOL)value {
    return OSAtomicCompareAndSwap32((expected ? 1 : 0),
                                    (value ? 1 : 0),
                                    &_underlying);
}

- (BOOL)getAndSetValue:(BOOL)value {
    // Optimistic "locking" (spinlock.)
    // If this loop looks weird, here's some Science™:
    // http://stackoverflow.com/a/17732545/366091
    while (true) {
        BOOL current = [self getValue];
        if ([self compareTo:current andSetValue:value]) {
            return current;
        }
    }
}

@end
