//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import Foundation;


#pragma mark -

/// A BOOL value that can be updated atomically.
///
/// Lock-free and thread-safe.
@interface HOPAtomicBoolean : NSObject

#pragma mark Creation

/// Create a new instance with the initial value set to NO.
- (instancetype)init;

/// Create a new instance with the initial value.
- (instancetype)initWithValue:(BOOL)value;

#pragma mark Atomic value access

/// Get the current value.
- (BOOL)getValue;

/// Set a new value.
- (void)setValue:(BOOL)value;

/// Atomically sets a new value if the current value matches the expected value.
///
/// Returns YES if the swap was successful, i.e. `expected` matched the current
/// value, NO otherwise.
- (BOOL)compareTo:(BOOL)expected andSetValue:(BOOL)value;

/// Atomically sets to the given value and returns the old value.
- (BOOL)getAndSetValue:(BOOL)value;

@end
