//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import Foundation;


#pragma mark -

/// An Integer value that can be updated atomically.
///
/// Lock-free and thread-safe.
@interface HOPAtomicInteger : NSObject

#pragma mark Creation

/// Create a new instance with initial value set to 0.
- (instancetype)init;

/// Create a new instance with the initial value.
- (instancetype)initWithValue:(NSInteger)value;

#pragma mark Atomic value access

/// Get the current value.
- (NSInteger)getValue;

/// Set a new value.
- (void)setValue:(NSInteger)value;

/// Atomically sets a new value if the current value matches the expected value.
///
/// Returns YES if the swap was successful, i.e. `expected` matched the current
/// value, NO otherwise.
- (BOOL)compareTo:(NSInteger)expected andSetValue:(NSInteger)value;

/// Atomically sets to the given value and returns the old value.
- (NSInteger)getAndSetValue:(NSInteger)value;

#pragma mark Atomic counter

/// Atomically increments the current value by 1 and returns the previous value.
- (NSInteger)getAndIncrementValue;

/// Atomically decrements the current value by 1 and returns the previous value.
- (NSInteger)getAndDecrementValue;

/// Atomically adds the `delta` to the current value and returns the previous value.
- (NSInteger)getAndAddValue:(NSInteger)delta;

/// Atomically increments the current value by 1 and returns the new value.
- (NSInteger)incrementAndGetValue;

/// Atomically decrements the current value by 1 and returns the new value.
- (NSInteger)decrementAndGetValue;

/// Atomically adds the `delta` to the current value and returns the new value.
- (NSInteger)addAndGetValue:(NSInteger)delta;

@end
