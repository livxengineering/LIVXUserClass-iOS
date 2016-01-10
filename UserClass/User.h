//
//  User.h
//  UserClass
//
//  Created by Leon on 2016/01/06.
//  Copyright © 2016 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *accessToken;

+ (User *)currentUser;

- (void)save;
- (void)clearAll;

@end
