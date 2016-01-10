//
//  User.m
//  UserClass
//
//  Created by Leon on 2016/01/06.
//  Copyright © 2016 Leon. All rights reserved.
//

#import "User.h"

#import <SSKeychain/SSKeychain.h>

#define KEY_IS_LOGGED_IN @"isLoggedIn"
#define KEY_FIRST_NAME @"firstName"
#define KEY_LAST_NAME @"lastName"
#define KEY_ACCESS_TOKEN @"accessToken"
#define KEY_ACCOUNT @"com.example.PackageName"

@implementation User 

+ (User *)currentUser {
    static User *user = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    
    user.isLoggedIn = [(NSNumber *)[user getValueFromDefaultsWithKey:KEY_IS_LOGGED_IN] boolValue];
    user.firstName = (NSString *)[user getValueFromDefaultsWithKey:KEY_FIRST_NAME];
    user.lastName = (NSString *)[user getValueFromDefaultsWithKey:KEY_LAST_NAME];
    user.accessToken = (NSString *)[user getValueFromKeychainWithKey:KEY_ACCESS_TOKEN];
    
    return user;
}

- (void)save {
    
    // Save non-sensitive properties to NSUserDefaults
    [self setValue:[NSNumber numberWithBool:_isLoggedIn] forKey:KEY_IS_LOGGED_IN];
    [self setValueIntoDefaults:_firstName forKey:KEY_FIRST_NAME];
    [self setValueIntoDefaults:_lastName forKey:KEY_LAST_NAME];
    
    // Save sensitive properties to SSKeychain
    [self setValueIntoKeychain:_accessToken forKey:KEY_ACCESS_TOKEN];
    
}

- (void)clearAll {
    
    // Set properties to nil
    _isLoggedIn = NO;
    _firstName = nil;
    _lastName = nil;
    _accessToken = nil;
    
    // Clear NSUserDefaults
    [self removeValueFromDefaultsWithKey:KEY_IS_LOGGED_IN];
    [self removeValueFromDefaultsWithKey:KEY_FIRST_NAME];
    [self removeValueFromDefaultsWithKey:KEY_LAST_NAME];
    
    // Cleat Keychain
    [self removeValueFromKeychainWithKey:KEY_ACCESS_TOKEN];
}

#pragma mark - NSUserDefaults

- (id)getValueFromDefaultsWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (void)setValueIntoDefaults:(id)value forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize]; // We synchronize so we know for a fact it has been saved immediately
}

- (void)removeValueFromDefaultsWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

#pragma mark - Keychain

- (id)getValueFromKeychainWithKey:(NSString *)key {
    return [SSKeychain passwordForService:key account:KEY_ACCOUNT];
}

- (void)setValueIntoKeychain:(NSString *)value forKey:(NSString *)key {
    [SSKeychain setPassword:value forService:key account:KEY_ACCOUNT];
}

- (void)removeValueFromKeychainWithKey:(NSString *)key {
    [SSKeychain deletePasswordForService:key account:KEY_ACCOUNT];
}

@end
