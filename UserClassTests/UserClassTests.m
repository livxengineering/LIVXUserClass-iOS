//
//  UserClassTests.m
//  UserClassTests
//
//  Created by Leon on 2016/01/06.
//  Copyright © 2016 Leon. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "User.h"

@interface UserClassTests : XCTestCase

@end

@implementation UserClassTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPersistence {
    
    
    User *user = [User currentUser];
    
    // Test Correct Details
    user.firstName = @"Frikkie";
    user.lastName = @"Du Preez";
    user.isLoggedIn = YES;
    user.accessToken = @"abcdefghijklmnopqrstuvwxyz";
    
    [user save];
    
    XCTAssertEqual(user.firstName, @"Frikkie");
    XCTAssertEqual(user.lastName, @"Du Preez");
    XCTAssertEqual(user.isLoggedIn, YES);
    XCTAssertEqual(user.accessToken, @"abcdefghijklmnopqrstuvwxyz");
    
    // Test Incorrect Details
    user.firstName = @"Bob";
    user.lastName = @"Marley";
    user.isLoggedIn = NO;
    user.accessToken = @"1234567890";
    
    [user save];
    
    XCTAssertNotEqual(user.firstName, @"Frikkie");
    XCTAssertNotEqual(user.lastName, @"Du Preez");
    XCTAssertNotEqual(user.isLoggedIn, YES);
    XCTAssertNotEqual(user.accessToken, @"abcdefghijklmnopqrstuvwxyz");
    
    
    // Test if saved to persistence properly by invoking another singleton instance
    User *otherUser = [User currentUser];
    
    XCTAssertEqual(otherUser.firstName, user.firstName);
    XCTAssertEqual(otherUser.lastName, user.lastName);
    XCTAssertEqual(otherUser.isLoggedIn, user.isLoggedIn);
    XCTAssertEqual(otherUser.accessToken, user.accessToken);
}

- (void)testClearAll {
    
    User *user = [User currentUser];
    
    user.firstName = @"Frikkie";
    user.lastName = @"Du Preez";
    user.isLoggedIn = YES;
    user.accessToken = @"abcdefghijklmnopqrstuvwxyz";
    
    [user save];
    
    [user clearAll];
    
    XCTAssertNil(user.firstName);
    XCTAssertNil(user.lastName);
    XCTAssertFalse(user.isLoggedIn);
    XCTAssertNil(user.accessToken);
    
    // Check if persisted properly by invoking another singleton
    User *otherUser = [User currentUser];
    
    XCTAssertNil(otherUser.firstName);
    XCTAssertNil(otherUser.lastName);
    XCTAssertFalse(otherUser.isLoggedIn);
    XCTAssertNil(otherUser.accessToken);
}



@end
