//
//  SettingDAO.h
//  bigcodebang
//
//  Created by nelson on 14-8-4.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDAO : NSObject
+ (BOOL) createSetting;
+ (NSDictionary *) getSetting;
+ (NSDictionary *) getSettingByUid:(NSString *)uid;
+ (BOOL) updateSetting:(NSDictionary *) data byUid:(NSString *)uid;
+ (BOOL) updateSetting:(NSDictionary *)data bySettingId:(NSString *)settingId;
+ (BOOL) insertSetting:(NSDictionary *) data;
@end
