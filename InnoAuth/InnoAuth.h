//
//  InnoAuthLib.h
//  InnoAuthLib
//
//  Created by hsshin on 2014. 12. 3..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnoAuthType.h"
#import "SocialController.h"

@interface InnoAuth : NSObject <SocialReflector>
{
    NSDictionary*               _socialControllers;
    NSMutableDictionary*               _callbackDic;
}

+ (id) sharedInstance;

- (void) socialAutoLogin:(InnoAuthType)type completeBlock:(InnoStringCallback)callback;
- (void) socialLogin:(InnoAuthType)type completeBlock:(InnoStringCallback)callback;
- (void) socialLogout:(InnoAuthType)type completeBlock:(InnoStringCallback)callback;
- (void) socialFriendsUseThisApp:(InnoAuthType)type completeBlock:(InnoStringCallback)callback;
- (void) socialAccounts:(InnoAuthType)type completeBlock:(InnoStringCallback)callback;
- (void) socialShare:(InnoAuthType)type link:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*)picUrl completeBlock:(InnoStringCallback)callback;
- (void) socialFeed:(InnoAuthType)type link:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*)picUrl completeBlock:(InnoStringCallback)callback;

@end
