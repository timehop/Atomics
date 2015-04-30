# Atomics

Nifty wrappers for the [compare-and-set](http://en.wikipedia.org/wiki/Compare-and-swap) primitives in [`libkern/OSAtomic.h`](https://developer.apple.com/library/mac/documentation/System/Reference/OSAtomic_header_reference/) package, using `Foundation` types.

* `AtomicBoolean`: atomic wrapper for a `BOOL` flag
* `AtomicInteger`: atomic wrapper for a `NSInteger` (32 or 64bit, depending on the architecture it's compiled for) with additional counter semantics (*add-and-get*, *get-and-add*)
* `AtomicReference`: atomic `NSObject` wrapper (see "single request" example below)

## Usage

All atomic classes expose a common interface:

* `getValue:` and `setValue:` are simple variable read and write operations, guaranteed to be atomic, with `HOPAtomicReference` being the only exception here — since it's dealing with objects, which require retention count adjustments. The operations are still guaranteed to be atomic to the caller, but unlike the integer and boolean versions, they aren't atomic under the covers.

* `compareTo:andSetValue:` atomically sets a new value if the current value matches the expected value. Returns `YES` if successful, `NO` otherwise.

* `getAndSetValue:` atomically updates the underlying value, returning the old value.

## Examples

### A fail-fast throttler with `AtomicInteger`

```objc
@implementation Throttler {
  HOPAtomicInteger *_counter;
  NSInteger _limit;
}

- (instancetype)initWithLimit:(NSInteger)limit {
  self = [super init];
  if (self != nil) {
    NSParameterAssert(limit > 0);
    _counter = [[HOPAtomicInteger alloc] initWithValue:0];
    _limit = limit;
  }
  return self;
}

// Returns YES if executed, NO otherwise
- (BOOL)throttledExec:(void (^)())block {
  if ((block == nil) || (_limit <= 0) return YES;

  if ([_counter incrementAndGetValue] > _limit) {
    [_counter decrementAndGetValue];
    return YES;
  }

  block()

  [_counter decrementAndGetValue];
  return NO;
}
@end
```

```objc
// Throttler *_t
BOOL executed = [_t throttledExec:^{
  // Critical section
}];

if (!executed) {
  NSLog(@"Resource unavailable");
}
```

### Single request gateway

```objc
@implementation SingleRequestLauncher {
  HOPAtomicReference *_ref;
}

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    // Reference never changes, only what it holds.
    _ref = [[HOPAtomicReference alloc] init];
  }
  return self;
}

- (BOOL)launchRequest:(...)... {
  id request = // create the request
  if ([_ref compareTo:nil andSetObject:request]) {
    [request start];
    return YES;
  }

  return NO;
}

- (BOOL)cancelActiveRequest {
  id current = [_ref getAndSetObject:nil];
  if (current == nil) return NO;

  [current cancel];
  return YES;
}

@end
```

> **NOTE:** Code above assumes that request creation will call `[_ref setObject:nil]` when request completes, either through success or failure.
