//
//  SocialController.h
//  TestProj
//
//  Created by hsshin on 2014. 11. 12..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnoAuthType.h"

@protocol SocialReflector

- (void) SocialLogInComplete:(InnoAuthType)completedType;
- (void) SocialLogOutComplete:(InnoAuthType)completedType;

- (void) requestAccountsComplete:(InnoAuthType)completedType result:(NSString*)json;
- (void) requestFriendsdUseThisAppComplete:(InnoAuthType)completedType result:(NSString*)json;

- (void) SocialShareComplete:(InnoAuthType)completedType;

@end

@protocol SocialController

- (id) initWithReflector:(id<SocialReflector>)socialReflector;

- (void) Login;
- (void) Logout;
- (BOOL) AutoLogin;

- (void) userLoggedIn;
- (void) userLoggedOut;

- (void) requestAccounts;
- (void) requestFriendsUseThisApp;

- (void) shareWithLink:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*) picUrl;

- (void) feedWithLink:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*)picUrl;

@end