//
//  InnoAuthBridge.m
//  TestProj
//
//  Created by hsshin on 2014. 12. 5..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnoAuth.h"
#import "InnoAuthBridge.h"

BOOL CheckValidType(int type, Common_handler handler)
{
    if (type >= InnoAuthTypeCount || type <= InnoAuthTypeDefault)
    {
        if (handler)
            handler(NO, nullptr);
        return NO;
    }
    
    return YES;
}

extern "C" void SocialAutoLogin(int type, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialAutoLogin:(InnoAuthType)type completeBlock:^(NSString *result) {
        if (result != nil) {
            if (handler)
                handler(YES, [result UTF8String]);
        } else {
            if (handler)
                handler(NO, nullptr);
        }
    }];
}

extern "C" void SocialLogin(int type, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialLogin:(InnoAuthType)type completeBlock:^(NSString* result){
        if (result != nil) {
            if (handler)
                handler(YES, [result UTF8String]);
        } else {
            if (handler)
                handler(NO, nullptr);
        }
    }];
}

extern "C" void SocialLogout(int type, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialLogout:(InnoAuthType)type completeBlock:^(NSString *result) {
        if (handler)
            handler(YES, nullptr);
    }];
}

extern "C" void SocialGetAccountInfo(int type, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialAccounts:(InnoAuthType)type completeBlock:^(NSString *result) {
        if (result != nil) {
            if (handler) {
                handler(YES, [result UTF8String]);
            }
        } else {
            if (handler) {
                handler(NO, nullptr);
            }
        }
    }];
}

extern "C" void SocialGetFriendsUseThisApp(int type, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialFriendsUseThisApp:(InnoAuthType)type completeBlock:^(NSString *result) {
        if (result != nil) {
            if (handler) {
                handler(YES, [result UTF8String]);
            }
        } else {
            if (handler) {
                handler(NO, nullptr);
            }
        }
    }];
}

extern "C" void SocialShare(int type, const char* linkUrl, const char* title, const char* caption, const char* desc, const char* picUrl, Common_handler handler)
{
    if (!CheckValidType(type, handler))
        return;
    
    [[InnoAuth sharedInstance] socialShare:(InnoAuthType)type
                                      link:linkUrl == nullptr ? nil : [NSString stringWithUTF8String:linkUrl]
                                     title:title == nullptr ? nil : [NSString stringWithUTF8String:title]
                                   caption:caption == nullptr ? nil : [NSString stringWithUTF8String:caption]
                                      desc:desc == nullptr ? nil : [NSString stringWithUTF8String:desc]
                                   picture:picUrl == nullptr ? nil : [NSString stringWithUTF8String:picUrl]
                             completeBlock:^(NSString *result){
                                 if (result != nil) {
                                     if (handler) {
                                         handler(YES, [result UTF8String]);
                                     }
                                 } else {
                                     if (handler) {
                                         handler(NO, nullptr);
                                     }
                                 }
                             }];
}