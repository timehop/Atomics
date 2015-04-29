//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

#import <libkern/OSAtomic.h>

#import "HOPAtomicInteger.h"


#define Is64BitArch __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || NS_BUILD_32_LIKE_64


#pragma mark -

@implementation HOPAtomicInteger {
#if Is64BitArch
    volatile int64_t _underlying;
#else
    volatile int32_t _underlying;
#endif
}

#pragma mark Creation

- (instancetype)init {
    return [self initWithValue:0];
}

- (instancetype)initWithValue:(NSInteger)value {
    self = [super init];
    if (self != nil) {
        _underlying = value;
    }

    return self;
}

#pragma mark Atomic value access

- (NSInteger)getValue {
    return _underlying;
}

- (void)setValue:(NSInteger)value {
    _underlying = value;
}

- (BOOL)compareTo:(NSInteger)expected andSetValue:(NSInteger)value {
#if Is64BitArch
    return OSAtomicCompareAndSwap64(expected, value, &_underlying);
#else
    // On 32bit architectures, there's no atomicity on reads and writes
    // for 64bit values so we have to resort to 32bit CAS.
    // Foundation ensures NSInteger will have the correct size type
    // at compile time.
    return OSAtomicCompareAndSwap32(expected, value, &_underlying);
#endif
}

- (NSInteger)getAndSetValue:(NSInteger)value {
    while (true) {
        NSInteger current = [self getValue];
        if ([self compareTo:current andSetValue:value]) {
            return current;
        }
    }
}

#pragma mark Atomic counter

- (NSInteger)getAndIncrementValue {
    return [self getAndAddValue:1];
}

- (NSInteger)getAndDecrementValue {
    return [self getAndAddValue:-1];
}

- (NSInteger)getAndAddValue:(NSInteger)delta {
    while (true) {
        NSInteger current = [self getValue];
        NSInteger next = current + delta;
        if ([self compareTo:current andSetValue:next]) {
            return current;
        }
    }
}

- (NSInteger)incrementAndGetValue {
    return [self addAndGetValue:1];
}

- (NSInteger)decrementAndGetValue {
    return [self addAndGetValue:-1];
}

- (NSInteger)addAndGetValue:(NSInteger)delta {
#if Is64BitArch
    return OSAtomicAdd64(delta, &_underlying);
#else
    return OSAtomicAdd32(delta, &_underlying);
#endif
}

@end
