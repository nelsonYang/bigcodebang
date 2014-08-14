//
//  SettingDAO.m
//  bigcodebang
//
//  Created by nelson on 14-8-4.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import "SettingDAO.h"
#import "DataBaseUtil.h"

@implementation SettingDAO
+ (BOOL) createSetting
{
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    
    FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",@"setting"]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    if(existTable){
        NSLog(@"user already exist");
    }else{
        
        NSString *createSql = @"CREATE TABLE setting (settingId INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL,uid VARCHAR(16),lastUploadTime long, isShowFlag VARCHAR(2), todayClickSpecialTime long, todayClickTAOBAOTime long,isUpgrade VARCHAR(2),isBind VARCHAR(2))";
        BOOL result =  [db executeUpdate:createSql];
        if(result){
            NSLog(@"create success");
        }else{
            NSLog(@"create fail");
        }
    }
    [db close];
    return YES;
}

+ (NSDictionary *) getSetting{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  setting";
    NSLog(@"sql=%@",querySql);
      FMResultSet *result = [db executeQueryWithFormat:querySql];
    //NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    
    if([result next]){
        NSString * settingId = [result stringForColumn:@"settingId"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * lastUploadTime = [result stringForColumn:@"lastUploadTime"];
        NSString * isShowFlag = [result stringForColumn:@"isShowFlag"];
        NSString * todayClickSpecialTime = [result stringForColumn:@"todayClickSpecialTime"];
        NSString * todayClickTAOBAOTime = [result stringForColumn:@"todayClickTAOBAOTime"];
        NSString * isUpgrade = [result stringForColumn:@"isUpgrade"];
        NSString * isBind = [result stringForColumn:@"isBind"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        
        if(settingId != nil){
            [data setValue:settingId forKey:@"settingId"];
        }
        if(uid != nil){
            [data setValue:uid forKey:@"uid"];
        }
        if(lastUploadTime != nil){
            [data setValue:lastUploadTime forKey:@"lastUploadTime"];
        }
        if(isShowFlag != nil){
            [data setValue:isShowFlag forKey:@"isShowFlag"];
        }
        if(todayClickSpecialTime != nil){
            [data setValue:todayClickSpecialTime forKey:@"todayClickSpecialTime"];
        }
        if(todayClickTAOBAOTime != nil){
            [data setValue:todayClickTAOBAOTime forKey:@"todayClickTAOBAOTime"];
        }
        if(isUpgrade != nil){
            [data setValue:isUpgrade forKey:@"isUpgrade"];
        }
        if(isBind != nil){
            [data setValue:isBind forKey:@"isBind"];
        }
        
    }
    [db close];
    return data;

}
+ (NSDictionary *) getSettingByUid:(NSString *)uid
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  user where uid='%@'";
    
    querySql = [NSString stringWithFormat:querySql,uid];
    NSLog(@"sql=%@",querySql);
    NSLog(@"uid=%@",uid);
    FMResultSet *result = [db executeQueryWithFormat:querySql];
    //NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    
    if([result next]){
        NSString *settingId = [result stringForColumn:@"settingId"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * lastUploadTime = [result stringForColumn:@"lastUploadTime"];
        NSString * isShowFlag = [result stringForColumn:@"isShowFlag"];
        NSString * todayClickSpecialTime = [result stringForColumn:@"todayClickSpecialTime"];
        NSString * todayClickTAOBAOTime = [result stringForColumn:@"todayClickTAOBAOTime"];
        NSString * isUpgrade = [result stringForColumn:@"isUpgrade"];
        NSString * isBind = [result stringForColumn:@"isBind"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        if(settingId != nil){
            [data setValue:settingId forKey:@"settingId"];
        }
        if(uid != nil){
            [data setValue:uid forKey:@"uid"];
        }
        if(lastUploadTime != nil){
            [data setValue:lastUploadTime forKey:@"lastUploadTime"];
        }
        if(isShowFlag != nil){
            [data setValue:isShowFlag forKey:@"isShowFlag"];
        }
        if(todayClickSpecialTime != nil){
            [data setValue:todayClickSpecialTime forKey:@"todayClickSpecialTime"];
        }
        if(todayClickTAOBAOTime != nil){
            [data setValue:todayClickTAOBAOTime forKey:@"todayClickTAOBAOTime"];
        }
        if(isUpgrade != nil){
            [data setValue:isUpgrade forKey:@"isUpgrade"];
        }
        if(isBind != nil){
            [data setValue:isBind forKey:@"isBind"];
        }
        
    }
    [db close];
    return data;
}
+ (BOOL) updateSetting:(NSDictionary *) data byUid:(NSString *)uid
{
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString * updateSql = @"update setting set ";
    NSArray* fields = [data allKeys];
    for(int index=0;index<fields.count;index++){
        updateSql = [updateSql stringByAppendingFormat:@"%@='%@',",fields[index],[data objectForKey:fields[index]]];
    }
    updateSql = [updateSql substringToIndex:[updateSql length] -1];
    updateSql = [updateSql stringByAppendingFormat:@" where uid='%@'",uid];
    NSLog(@"sql=%@",updateSql);
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"result=%d",result);
    [db close];
    return result;
}
+ (BOOL) insertSetting:(NSDictionary *) data
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString * insertSql = @"insert into setting (";
    NSString * value = @"(";
    NSArray* fields = [data allKeys];
    for(int index=0;index<fields.count;index++){
        insertSql = [insertSql stringByAppendingFormat:@"%@,",fields[index]];
        value = [value stringByAppendingFormat:@"'%@',",[data objectForKey:fields[index]]];
    }
    value = [value substringToIndex:[value length] -1];
    insertSql = [insertSql substringToIndex:[insertSql length] -1];
    value = [value stringByAppendingString:@" ) "];
    insertSql = [insertSql stringByAppendingString:@" ) values "];
    insertSql = [insertSql stringByAppendingString:value];
    NSLog(@"sql=%@",insertSql);
    BOOL result = [db executeUpdate:insertSql];
    NSLog(@"result=%d",result);
    [db close];
    return result;
}

+ (BOOL) updateSetting:(NSDictionary *)data bySettingId:(NSString *)settingId{
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString * updateSql = @"update setting set ";
    NSArray* fields = [data allKeys];
    for(int index=0;index<fields.count;index++){
        updateSql = [updateSql stringByAppendingFormat:@"%@='%@',",fields[index],[data objectForKey:fields[index]]];
    }
    updateSql = [updateSql substringToIndex:[updateSql length] -1];
    updateSql = [updateSql stringByAppendingFormat:@" where settingId='%@'",settingId];
    NSLog(@"sql=%@",updateSql);
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"result=%d",result);
    [db close];
    return result;

}
@end
