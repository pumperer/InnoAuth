//
//  InnoAuthType.h
//  TestProj
//
//  Created by hsshin on 2014. 11. 12..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#ifndef InnoAuthType_Header_h
#define InnoAuthType_Header_h

typedef void (^InnoSimpleCallback)(void);
typedef void (^InnoStringCallback)(NSString* result);

typedef NS_ENUM(NSInteger, InnoAuthType)
{
    InnoAuthTypeDefault = 0,
    InnoAuthTypeFaceBook,
    InnoAuthTypeGooglePlus,
    
    InnoAuthTypeCount,
};

#endif
