//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

#import "HOPAtomicReference.h"

#import <libkern/OSAtomic.h>


#pragma mark -

@implementation HOPAtomicReference {
    void *volatile _underlying;
}

#pragma mark Creation

- (instancetype)init {
    return [self initWithObject:nil];
}

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self != nil) {
        // Avoid going through compareTo:andSetObject:'s loops
        // This throws a +1 on the retain counter for object.
        // It's okay to __bridge_retained on nil, no need to check.
        _underlying = (__bridge_retained void *)object;
    }

    return self;
}

- (void)dealloc {
    void *previous = _underlying;

    if (previous != nil) CFRelease(previous);
}

- (id)getObject {
    return (__bridge id)_underlying;
}

- (void)setObject:(id)object {
    [self getAndSetObject:object];
}

- (BOOL)compareTo:(id)expected andSetObject:(id)object {
    void *old = (__bridge void *)expected;
    void *new = (__bridge void *)object;

    BOOL swapped = OSAtomicCompareAndSwapPtr(old, new, &_underlying);
    if (swapped) {
        if (expected != nil) CFRelease(old);
        if (object != nil) CFRetain(new);
    }

    return swapped;
}

- (id)getAndSetObject:(id)object {
    while (true) {
        id current = [self getObject];
        if ([self compareTo:current andSetObject:object]) {
            return current;
        }
    }
}

@end
