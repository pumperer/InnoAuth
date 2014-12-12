//
//  InnoAuthBridge.h
//  TestProj
//
//  Created by hsshin on 2014. 12. 5..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#ifndef InnoAuthBridge_Header_h
#define InnoAuthBridge_Header_h

typedef void (*Common_handler)(BOOL, const char*);

extern "C" void SocialAutoLogin(int type, Common_handler handler);
extern "C" void SocialLogin(int type, Common_handler handler);
extern "C" void SocialLogout(int type, Common_handler handler);
extern "C" void SocialGetAccountInfo(int type, Common_handler handler);
extern "C" void SocialGetFriendsUseThisApp(int type, Common_handler handler);
extern "C" void SocialShare(int type, const char* linkUrl, const char* title, const char* caption, const char* desc, const char* picUrl, Common_handler handler);

#endif
