//
//  InnoAuthLib.m
//  InnoAuthLib
//
//  Created by hsshin on 2014. 12. 3..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import "InnoAuth.h"
#import "FacebookController.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block)   \
        static dispatch_once_t pred = 0; \
        __strong static id _sharedObject = nil; \
        dispatch_once(&pred, ^{ \
            _sharedObject = block();    \
        }); \
        return _sharedObject;   \

@implementation InnoAuth

+ (id) sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id) init
{
    self = [super init];
    if(self) {
        _socialControllers = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [[FacebookController alloc] initWithReflector:self], [NSNumber numberWithInteger:InnoAuthTypeFaceBook],
                              nil];
        
        _callbackDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        nil, [NSNumber numberWithInteger:InnoAuthTypeFaceBook],
                        nil, [NSNumber numberWithInteger:InnoAuthTypeGooglePlus],
                        nil];
    }
    return self;
}

- (void) socialAutoLogin:(InnoAuthType)type completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    if (![[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] AutoLogin]) {
        callback(nil);
    }
}

- (void) socialLogin:(InnoAuthType)type completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    if (![[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] AutoLogin]) {
        [[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] Login];
    }
}

- (void) socialLogout:(InnoAuthType)type completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    [[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] Logout];
}

- (void) socialFriendsUseThisApp:(InnoAuthType)type completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    [[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] requestFriendsUseThisApp];
}

- (void) socialAccounts:(InnoAuthType)type completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    [[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] requestAccounts];
}

- (void) socialShare:(InnoAuthType)type link:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*)picUrl completeBlock:(InnoStringCallback)callback
{
    [_callbackDic setObject:callback forKey:[NSNumber numberWithInteger:type]];
    [[_socialControllers objectForKey:[NSNumber numberWithInteger:type]] shareWithLink:linkUrl title:title caption:caption desc:desc picture:picUrl];
}

- (void) SocialLogInComplete:(InnoAuthType)completedType
{
    InnoStringCallback cb = [_callbackDic objectForKey:[NSNumber numberWithInteger:completedType]];
    cb(@"");
}

- (void) SocialLogOutComplete:(InnoAuthType)completedType
{
    InnoStringCallback cb = [_callbackDic objectForKey:[NSNumber numberWithInteger:completedType]];
    cb(@"");
}

- (void) requestAccountsComplete:(InnoAuthType)completedType result:(NSString*)json
{
    InnoStringCallback cb = [_callbackDic objectForKey:[NSNumber numberWithInteger:completedType]];
    cb(json);
}

- (void) requestFriendsdUseThisAppComplete:(InnoAuthType)completedType result:(NSString*)json
{
    InnoStringCallback cb = [_callbackDic objectForKey:[NSNumber numberWithInteger:completedType]];
    cb(json);
}

- (void) SocialShareComplete:(InnoAuthType)completedType
{
    InnoStringCallback cb = [_callbackDic objectForKey:[NSNumber numberWithInteger:completedType]];
    cb(@"");
}

@end
