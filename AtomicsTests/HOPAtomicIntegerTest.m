//
//  HOPAtomicIntegerTest.m
//  Atomics
//
//  Created by Bruno de Carvalho on 4/29/15.
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "HOPAtomicInteger.h"


#pragma mark -

@interface HOPAtomicIntegerTest : XCTestCase
@end

@implementation HOPAtomicIntegerTest

- (void)testConstructors {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] init];
    XCTAssert([atomic getValue] == 0);

    atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic getValue] == 0);

    atomic = [[HOPAtomicInteger alloc] initWithValue:1];
    XCTAssert([atomic getValue] == 1);
}

- (void)testCompareToAndSetValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic compareTo:0 andSetValue:1]);
    XCTAssert([atomic compareTo:1 andSetValue:2]);
    XCTAssert(![atomic compareTo:1 andSetValue:3]);
}

- (void)testGetAndSetValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic getAndSetValue:1] == 0);
    XCTAssert([atomic getValue] == 1);
}

- (void)testGetAndIncrementValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic getAndIncrementValue] == 0);
    XCTAssert([atomic getValue] == 1);

    [atomic setValue:NSIntegerMax];
    XCTAssert([atomic getAndIncrementValue] == NSIntegerMax);
    XCTAssert([atomic getValue] == NSIntegerMin);
}

- (void)testGetAndDecrementValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic getAndDecrementValue] == 0);
    XCTAssert([atomic getValue] == -1);

    [atomic setValue:NSIntegerMin];
    XCTAssert([atomic getAndDecrementValue] == NSIntegerMin);
    XCTAssert([atomic getValue] == NSIntegerMax);
}

- (void)testGetAndAddValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic getAndAddValue:NSIntegerMax] == 0);
    XCTAssert([atomic getValue] == NSIntegerMax);
    XCTAssert([atomic getAndAddValue:NSIntegerMin] == NSIntegerMax);
    // Next assert looks odd but NSIntegerMin is defined as (-NSIntegerMax - 1)
    XCTAssert([atomic getValue] == -1);
}

- (void)testIncrementAndGetValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic incrementAndGetValue] == 1);
    XCTAssert([atomic getValue] == 1);

    [atomic setValue:NSIntegerMax];
    XCTAssert([atomic incrementAndGetValue] == NSIntegerMin);
    XCTAssert([atomic getValue] == NSIntegerMin);
}

- (void)testDecrementAndGetValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic decrementAndGetValue] == -1);
    XCTAssert([atomic getValue] == -1);

    [atomic setValue:NSIntegerMin];
    XCTAssert([atomic decrementAndGetValue] == NSIntegerMax);
    XCTAssert([atomic getValue] == NSIntegerMax);
}

- (void)testAddAndGetValue {
    HOPAtomicInteger *atomic = [[HOPAtomicInteger alloc] initWithValue:0];
    XCTAssert([atomic addAndGetValue:NSIntegerMax] == NSIntegerMax);
    XCTAssert([atomic getValue] == NSIntegerMax);
    XCTAssert([atomic addAndGetValue:NSIntegerMin] == -1);
    XCTAssert([atomic getValue] == -1);
}

@end
