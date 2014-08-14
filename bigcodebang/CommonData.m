//
//  Common.m
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "CommonData.h"

@implementation CommonData
static NSString *userId;
static NSString *accssToken;
static NSString *tencentUserId;
static NSString *tencentAccessToken;
static NSString *sid;
static NSString *money;
static NSString *differentTime;
static NSString *bindAccountFlag = @"0";
static NSString *uid;


+(NSString *) getUid{

    return uid;
}
+(void) setUid:(NSString *) _uid
{
    if(uid != nil){
        [uid release];
    }
    uid = [_uid copy];
}

+ (NSString *) getUserId{
    return userId;
}
+ (NSString *) getAccessToken{
    return accssToken;
}

+ (void) setUserId:(NSString *) _userId{
    if (userId != nil) {
        [userId release];
    }
    userId = [_userId copy];
    
}
+ (void) setAccessToken:(NSString *) _accessToken{
    if (accssToken != nil) {
        [accssToken release];
    }
    accssToken = [_accessToken copy] ;
}

+ (void) setTencentAccessToken:(NSString *) _tencentAccessToken
{
    if (tencentAccessToken != nil) {
        [tencentAccessToken release];
    }
    tencentAccessToken = [_tencentAccessToken copy];
}
+ (void) setTencentUserId:(NSString *) _tencentUserId{
    tencentUserId = [_tencentUserId copy];
}

+ (NSString *) getTencentUserId{
    return tencentUserId;
}
+ (NSString *) getTencentAccessToken{
    return tencentAccessToken;
}

+ (NSString *) getSid{
    return sid;
}
+ (void) setSid:(NSString *)_sid
{
    if (sid != nil) {
        [sid release];
    }
    sid = [_sid copy];
}
+ (NSString *) getMoneny
{
    return money;
}
+ (void) setMoney:(NSString *)_money{
    if (money != nil) {
        [money release];
    }
    money = [_money copy];
}

+ (NSString *) getDifferentTime
{
    return differentTime;
}
+ (NSString *) getBindAccountFlag
{
    return bindAccountFlag;
}
+ (void) setDifferentTime:(NSString *)_differentTime
{
    if (differentTime != nil) {
        [differentTime release];
    }
    differentTime = [_differentTime copy];
}
+ (void) setBindAccountFlag:(NSString *) _flag
{
    if (bindAccountFlag != nil) {
        [bindAccountFlag release];
    }
    bindAccountFlag = [_flag copy];
}

@end
