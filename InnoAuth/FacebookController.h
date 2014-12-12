//
//  FacebookController.h
//  TestProj
//
//  Created by hsshin on 2014. 11. 12..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import "SocialController.h"

#import <FacebookSDK/FacebookSDK.h>

@interface FacebookController : NSObject <SocialController> {
    id<SocialReflector> reflector;
    FBSession* fbSession;
}

@end
