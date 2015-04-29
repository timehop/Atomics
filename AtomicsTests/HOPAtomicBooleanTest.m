//
//  HOPAtomicBooleanTest.m
//  Atomics
//
//  Created by Bruno de Carvalho on 4/29/15.
//  Copyright (c) 2015 Timehop. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "HOPAtomicBoolean.h"


#pragma mark -

@interface HOPAtomicBooleanTest : XCTestCase
@end

@implementation HOPAtomicBooleanTest

- (void)testConstructors {
    HOPAtomicBoolean *atomic = [[HOPAtomicBoolean alloc] init];
    XCTAssert([atomic getValue] == NO);

    atomic = [[HOPAtomicBoolean alloc] initWithValue:NO];
    XCTAssert([atomic getValue] == NO);

    atomic = [[HOPAtomicBoolean alloc] initWithValue:YES];
    XCTAssert([atomic getValue] == YES);
}

- (void)testCompareToAndSetValue {
    HOPAtomicBoolean *atomic = [[HOPAtomicBoolean alloc] initWithValue:NO];
    XCTAssert([atomic compareTo:NO andSetValue:YES]);
    XCTAssert([atomic compareTo:YES andSetValue:NO]);
    XCTAssert(![atomic compareTo:YES andSetValue:NO]);
}

- (void)testGetAndSetValue {
    HOPAtomicBoolean *atomic = [[HOPAtomicBoolean alloc] initWithValue:NO];
    XCTAssert([atomic getAndSetValue:YES] == NO);
    XCTAssert([atomic getValue] == YES);
}

@end
