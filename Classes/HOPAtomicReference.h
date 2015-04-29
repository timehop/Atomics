//
//  Atomics
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import Foundation;


#pragma mark -

/// An object reference holder that can be updated atomically.
///
/// Lock-free and thread-safe.
@interface HOPAtomicReference : NSObject

#pragma mark Creation

/// Create a new instance with no initial reference (nil).
- (instancetype)init;

/// Create a new instance with the initial reference of object.
- (instancetype)initWithObject:(id)object;

#pragma mark Atomic value access

/// Get the current value.
- (id)getObject;

/// Set a new value.
- (void)setObject:(id)value;

/// Atomically sets a new value if the current value matches the expected value.
///
/// Returns YES if the swap was successful, i.e. `expected` matched the current
/// value, NO otherwise.
- (BOOL)compareTo:(id)expected andSetObject:(id)object;

/// Atomically sets to the given value and returns the old value.
- (id)getAndSetObject:(id)object;

@end
