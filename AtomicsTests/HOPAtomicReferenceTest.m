//
//  HOPAtomicReferenceTest.m
//  Atomics
//
//  Created by Bruno de Carvalho on 4/29/15.
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "HOPAtomicReference.h"


#pragma mark -

@interface HOPAtomicReferenceTest : XCTestCase
@end

@implementation HOPAtomicReferenceTest

- (void)testConstructors {
    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] init];
    XCTAssert([atomic getObject] == nil);

    NSObject *foo = [[NSObject alloc] init];
    atomic = [[HOPAtomicReference alloc] initWithObject:foo];
    XCTAssert([atomic getObject] == foo);
}

- (void)testCompareToAndSetValue {
    NSObject *foo = [[NSObject alloc] init];
    NSObject *bar = [[NSObject alloc] init];

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:nil];
    XCTAssert([atomic compareTo:nil andSetObject:foo]);
    XCTAssert([atomic compareTo:foo andSetObject:bar]);
    XCTAssert(![atomic compareTo:foo andSetObject:nil]);
}

- (void)testGetAndSetValue {
    NSObject *foo = [[NSObject alloc] init];
    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:nil];
    XCTAssert([atomic getAndSetObject:foo] == nil);
    XCTAssert([atomic getObject] == foo);
}

// The following are all about ensuring proper retention/release

- (void)testUnderlyingObjectHolding {
    NSObject *foo = [[NSObject alloc] init];
    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];

    foo = nil;
    XCTAssert([atomic getObject] != nil, @"foo is held by atomic reference");
}

- (void)testUnderlyingObjectReleaseOnDealloc {
    NSObject *foo = [[NSObject alloc] init];
    __weak id weakFoo = foo;

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];

    foo = nil;
    XCTAssert(weakFoo != nil, @"foo is held by atomic reference");

    atomic = nil;
    XCTAssert(weakFoo == nil, @"foo is dealloc'd when the atomic had the last strong ref");
}

- (void)testUnderlyingObjectReleaseOnSet {
    NSObject *foo = [[NSObject alloc] init];
    __weak id weakFoo = foo;

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];

    foo = nil;
    XCTAssert(weakFoo != nil, @"foo is held by atomic reference");

    [atomic setObject:nil];
    XCTAssert(weakFoo == nil, @"foo is dealloc'd when the atomic had the last strong ref");
}

- (void)testUnderlyingObjectReleaseOnSuccessfulCAS {
    NSObject *foo = [[NSObject alloc] init];
    NSObject *bar = [[NSObject alloc] init];
    __weak id weakFoo = foo;
    __weak id weakBar = bar;

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];
    XCTAssert([atomic compareTo:foo andSetObject:bar]);

    foo = nil; // last strong ref to foo, since the atomic released it on the CAS
    XCTAssert(weakFoo == nil, @"foo is dealloc'd when the atomic had the last strong ref");

    bar = nil;
    XCTAssert(weakBar != nil, @"bar is held by atomic reference");

    [atomic setObject:nil];
    XCTAssert(weakBar == nil, @"bar is dealloc'd when the atomic had the last strong ref");
}

- (void)testUnderlyingRetentionOnFailedCAS {
    NSObject *foo = [[NSObject alloc] init];
    NSObject *bar = [[NSObject alloc] init];
    __weak id weakFoo = foo;
    __weak id weakBar = bar;

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];
    XCTAssert(![atomic compareTo:bar andSetObject:nil]);

    foo = nil; // atomic will still be holding a strong ref to foo
    XCTAssert(weakFoo != nil, @"foo is still held by atomic");
    bar = nil; // make sure atomic didn't accidentally did anything silly on bar
    XCTAssert(weakBar == nil, @"atomic didn't modify retain counter on bar");
}

- (void)testUnderlyingRetentionReleaseOnGetAndSetObject {
    NSObject *foo = [[NSObject alloc] init];
    NSObject *bar = [[NSObject alloc] init];
    __weak id weakFoo = foo;
    __weak id weakBar = bar;

    HOPAtomicReference *atomic = [[HOPAtomicReference alloc] initWithObject:foo];

    foo = nil;
    XCTAssert(weakFoo != nil, @"foo is held by atomic");

    id lastFoo = [atomic getAndSetObject:bar];
    XCTAssert(weakFoo != nil, @"foo is now strong ref'd at lastFoo");
    XCTAssert(lastFoo == weakFoo);

    bar = nil;
    XCTAssert(weakBar != nil, @"bar is now strong ref'd at lastFoo");

    lastFoo = nil;
    XCTAssert(weakFoo != nil, @"foo is dealloc'd when the last ref is gone");

    atomic = nil;
    XCTAssert(weakBar == nil, @"bar is dealloc'd when the atomic is gone and held the last ref");
}

@end
