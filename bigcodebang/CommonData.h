//
//  Common.h
//  BigBand
//
//  Created by nelson on 14-7-19.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonData : NSObject
+ (NSString *) getUserId;
+ (NSString *) getAccessToken;
+ (NSString *) getTencentUserId;
+ (NSString *) getTencentAccessToken;
+ (NSString *) getSid;
+ (NSString *) getMoneny;
+ (NSString *) getDifferentTime;
+ (NSString *) getBindAccountFlag;
+ (NSString *) getUid;
+ (void) setUid:(NSString *)_uid;



+ (void) setUserId:(NSString *) _userId;
+ (void) setAccessToken:(NSString *) _accessToken;

+ (void) setTencentAccessToken:(NSString *) _tencentAccessToken;
+ (void) setTencentUserId:(NSString *) _tencentUserId;
+ (void) setSid:(NSString *) _sid;
+ (void) setMoney:(NSString *)_money;
+ (void) setDifferentTime:(NSString *)_differentTime;
+ (void) setBindAccountFlag:(NSString *) _flag;


@end
