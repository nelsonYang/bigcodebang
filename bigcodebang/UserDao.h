//
//  UserDao.h
//  BigBand
//
//  Created by nelson on 14-7-13.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDao : NSObject
+ (BOOL) insertUser:(NSDictionary *) data;

+ (BOOL) deleteUser:(NSString *) userId;
+ (BOOL) createUser;

+ (BOOL) insertUserWithUserId:(NSDictionary *) data;

+ (NSDictionary *) getUserInfoById:(NSString *) userId;
+ (NSDictionary *) getUserInfoBySid:(NSString *) sid;

+ (NSDictionary *) getUserInfoByType:(NSString *) type;
+ (NSMutableArray *) getUserInfo;

+(BOOL) updateUserInfo:(NSDictionary *)data byuserId:(NSString *) userId;
+(BOOL) updateUserInfo:(NSDictionary *)data bySid:(NSString *) sid;

+(BOOL) consumeMoney:(NSInteger) money byUid:(NSString *) uid;

+(BOOL) updateMoney:(NSInteger) money byUid:(NSString *) uid;
@end
