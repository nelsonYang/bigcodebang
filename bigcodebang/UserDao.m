//
//  UserDao.m
//  BigBand
//
//  Created by nelson on 14-7-13.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "UserDao.h"
#import "DataBaseUtil.h"


@implementation UserDao

+ (BOOL) insertUser:(NSDictionary *) data
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString * insertSql = @"insert into user (";
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


+ (BOOL) insertUserWithUserId:(NSDictionary *) data
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *insertSql = @"insert into user(userId,accessToken,type,money) values(?,?,?,?)";
    BOOL result = [db executeUpdate:insertSql,[data objectForKey:@"userId"],[data objectForKey:@"accessToken"],[data objectForKey:@"type"],[data objectForKey:@"money"]];
    NSLog(@"result=%d",result);
    [db close];
    return result;
    
}



+ (BOOL) deleteUser:(NSString *) userId
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *deleteSql = @"delete from user where userId=%@";
    BOOL result = [db executeUpdateWithFormat:deleteSql,userId];
    NSLog(@"result=%d",result);
    [db close];
    return  result;
}
+ (BOOL) createUser{
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    
    FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",@"user"]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    if(existTable){
        NSLog(@"user already exist");
    }else{
        
        NSString *createSql = @"CREATE TABLE user (userId VARCHAR(16) NOT NULL , accessToken VARCHAR(256), nickname VARCHAR(16), gender VARCHAR(10), headimgurl VARCHAR(512),location VARCHAR(64),type VARCHAR(2),account VARCHAR(64),accountName VARCHAR(16),sid VARCHAR(16),uid VARCHAR(16),money VARCHAR(36),telephone VARCHAR(24))";
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

+ (NSDictionary *) getUserInfoById:(NSString *) userId{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  user where userId=%@";
    querySql = [NSString stringWithFormat:querySql,userId];
    NSLog(@"sql=%@",querySql);
    NSLog(@"userId=%@",userId);
    FMResultSet *result = [db executeQueryWithFormat:querySql];
    // NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    if([result next]){
        
        NSString * accessToken = [result stringForColumn:@"accessToken"];
        NSString * nickname = [result stringForColumn:@"nickname"];
        NSString * gender = [result stringForColumn:@"gender"];
        NSString * headimgurl = [result stringForColumn:@"headimgurl"];
        NSString * location = [result stringForColumn:@"location"];
        NSString * type = [result stringForColumn:@"type"];
        NSString * account = [result stringForColumn:@"account"];
        NSString * accountName = [result stringForColumn:@"accountName"];
        NSString * sid = [result stringForColumn:@"sid"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * telephone = [result stringForColumn:@"telephone"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        if(userId != nil){
            [data setValue:userId forKey:@"userId"];
        }
        if(nickname != nil){
            [data setValue:userId forKey:@"nickName"];
        }
        if(gender != nil){
            [data setValue:gender forKey:@"gender"];
        }
        if(headimgurl != nil){
            [data setValue:headimgurl forKey:@"headimgurl"];
        }
        if(location != nil){
            [data setValue:location forKey:@"location"];
        }
        if(accessToken != nil){
            [data setValue:accessToken forKey:@"accessToken"];
        }
        if(type != nil){
            [data setValue:type forKey:@"type"];
        }
        if(account != nil){
            [data setValue:account forKey:@"account"];
        }
        if(accountName != nil){
            [data setValue:accountName forKey:@"accountName"];
        }
        if(sid != nil){
            [data setValue:sid forKey:@"sid"];
        }
        if(uid != nil){
            [data setValue:sid forKey:@"uid"];
        }
        if(telephone!= nil){
            [data setValue:telephone forKey:@"telephone"];
        }
        
        //data = [[[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userId",nickname,@"nickName",gender,@"gender",headimgurl,@"headimgurl",location,@"location",accessToken,@"accessToken",type,@"type",account,@"account",accountName,@"accountName",sid,@"sid", nil] autorelease];
        
    }
    [db close];
    return data;
}

+ (NSDictionary *) getUserInfoBySid:(NSString *) sid{
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  user where sid='%@'";
    
    querySql = [NSString stringWithFormat:querySql,sid];
    NSLog(@"sql=%@",querySql);
    NSLog(@"sid=%@",sid);
    FMResultSet *result = [db executeQueryWithFormat:querySql];
    //NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    
    if([result next]){
        NSString * userId = [result stringForColumn:@"userId"];
        NSString * accessToken = [result stringForColumn:@"accessToken"];
        NSString * nickname = [result stringForColumn:@"nickname"];
        NSString * gender = [result stringForColumn:@"gender"];
        NSString * headimgurl = [result stringForColumn:@"headimgurl"];
        NSString * location = [result stringForColumn:@"location"];
        NSString * type = [result stringForColumn:@"type"];
        NSString * account = [result stringForColumn:@"account"];
        NSString * accountName = [result stringForColumn:@"accountName"];
        NSString * sid = [result stringForColumn:@"sid"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * money = [result stringForColumn:@"money"];
         NSString * telephone = [result stringForColumn:@"telephone"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        if(userId != nil){
            [data setValue:userId forKey:@"userId"];
        }
        if(nickname != nil){
            [data setValue:userId forKey:@"nickName"];
        }
        if(gender != nil){
            [data setValue:gender forKey:@"gender"];
        }
        if(headimgurl != nil){
            [data setValue:headimgurl forKey:@"headimgurl"];
        }
        if(location != nil){
            [data setValue:location forKey:@"location"];
        }
        if(accessToken != nil){
            [data setValue:accessToken forKey:@"accessToken"];
        }
        if(type != nil){
            [data setValue:type forKey:@"type"];
        }
        if(account != nil){
            [data setValue:account forKey:@"account"];
        }
        if(accountName != nil){
            [data setValue:accountName forKey:@"accountName"];
        }
        if(sid != nil){
            [data setValue:sid forKey:@"sid"];
        }
        if(uid != nil){
            [data setValue:uid forKey:@"uid"];
        }
        if(money != nil){
            [data setValue:money forKey:@"money"];
        }
        if(telephone!= nil){
            [data setValue:telephone forKey:@"telephone"];
        }
        
    }
    [db close];
    return data;
}
+ (NSDictionary *) getUserInfoByType:(NSString *) type
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  user where type=%@";
    querySql = [NSString stringWithFormat: querySql,type ];
    NSLog(@"sql=%@",querySql);
    FMResultSet *result = [db executeQuery:querySql];
    //NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    
    if([result next]){
        NSString * userId = [result stringForColumn:@"userId"];
        NSString * accessToken = [result stringForColumn:@"accessToken"];
        NSString * nickname = [result stringForColumn:@"nickname"];
        NSString * gender = [result stringForColumn:@"gender"];
        NSString * headimgurl = [result stringForColumn:@"headimgurl"];
        NSString * location = [result stringForColumn:@"location"];
        NSString * type = [result stringForColumn:@"type"];
        NSString * account = [result stringForColumn:@"account"];
        NSString * accountName = [result stringForColumn:@"accountName"];
        NSString * sid = [result stringForColumn:@"sid"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * money = [result stringForColumn:@"money"];
        NSString * telephone = [result stringForColumn:@"telephone"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        if(userId != nil){
            [data setValue:userId forKey:@"userId"];
        }
        if(nickname != nil){
            [data setValue:userId forKey:@"nickName"];
        }
        if(gender != nil){
            [data setValue:gender forKey:@"gender"];
        }
        if(headimgurl != nil){
            [data setValue:headimgurl forKey:@"headimgurl"];
        }
        if(location != nil){
            [data setValue:location forKey:@"location"];
        }
        if(accessToken != nil){
            [data setValue:accessToken forKey:@"accessToken"];
        }
        if(type != nil){
            [data setValue:type forKey:@"type"];
        }
        if(account != nil){
            [data setValue:account forKey:@"account"];
        }
        if(accountName != nil){
            [data setValue:accountName forKey:@"accountName"];
        }
        if(sid != nil){
            [data setValue:sid forKey:@"sid"];
        }
        if(uid != nil){
            [data setValue:uid forKey:@"uid"];
        }
        if(money != nil){
            [data setValue:money forKey:@"money"];
        }
        if(telephone!= nil){
            [data setValue:telephone forKey:@"telephone"];
        }
        
    }
    [db close];
    return data;
    
    
}


+ (NSMutableArray *) getUserInfo {
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString *querySql = @"select * from  user";
    NSLog(@"sql=%@",querySql);
    FMResultSet *result = [db executeQuery:querySql];
    //NSDictionary *data = nil;
    NSMutableDictionary *data = nil;
    NSMutableArray * resultData = [[[NSMutableArray alloc] init] autorelease];
    
    while([result next]){
        NSString * userId = [result stringForColumn:@"userId"];
        NSString * accessToken = [result stringForColumn:@"accessToken"];
        NSString * nickname = [result stringForColumn:@"nickname"];
        NSString * gender = [result stringForColumn:@"gender"];
        NSString * headimgurl = [result stringForColumn:@"headimgurl"];
        NSString * location = [result stringForColumn:@"location"];
        NSString * type = [result stringForColumn:@"type"];
        NSString * account = [result stringForColumn:@"account"];
        NSString * accountName = [result stringForColumn:@"accountName"];
        NSString * sid = [result stringForColumn:@"sid"];
        NSString * uid = [result stringForColumn:@"uid"];
        NSString * money = [result stringForColumn:@"money"];
        NSString * telephone = [result stringForColumn:@"telephone"];
        data = [[[NSMutableDictionary alloc] init] autorelease];
        if(userId != nil){
            [data setValue:userId forKey:@"userId"];
        }
        if(nickname != nil){
            [data setValue:userId forKey:@"nickName"];
        }
        if(gender != nil){
            [data setValue:gender forKey:@"gender"];
        }
        if(headimgurl != nil){
            [data setValue:headimgurl forKey:@"headimgurl"];
        }
        if(location != nil){
            [data setValue:location forKey:@"location"];
        }
        if(accessToken != nil){
            [data setValue:accessToken forKey:@"accessToken"];
        }
        if(type != nil){
            [data setValue:type forKey:@"type"];
        }
        if(account != nil){
            [data setValue:account forKey:@"account"];
        }
        if(accountName != nil){
            [data setValue:accountName forKey:@"accountName"];
        }
        if(sid != nil){
            [data setValue:sid forKey:@"sid"];
        }
        if(uid != nil){
            [data setValue:uid forKey:@"uid"];
        }
        if(money != nil){
            [data setValue:money forKey:@"money"];
        }
        if(telephone!= nil){
            [data setValue:telephone forKey:@"telephone"];
        }
        [resultData addObject:data];
    }
    [db close];
    return resultData;
}
+(BOOL) updateUserInfo:(NSDictionary *)data byuserId:(NSString *) userId
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    NSString * updateSql = @"update user set ";
    NSArray* fields = [data allKeys];
    for(int index=0;index<fields.count;index++){
        updateSql = [updateSql stringByAppendingFormat:@"%@='%@',",fields[index],[data objectForKey:fields[index]]];
    }
    updateSql = [updateSql substringToIndex:[updateSql length] -1];
    updateSql = [updateSql stringByAppendingFormat:@" where userId='%@'",userId];
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"sql=%@",updateSql);
    // BOOL result = [db executeUpdate:updateSql withParameterDictionary:data];
    NSLog(@"result=%d",result);
    [db close];
    return result;
}

+(BOOL) consumeMoney:(NSInteger) money byUid:(NSString *) uid
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    
    NSString * updateSql = [NSString stringWithFormat:@"update user set money = money - %d where uid = '%@'",money,uid];
    
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"sql=%@",updateSql);
    NSLog(@"result=%d",result);
    [db close];
    return result;
    
}

+(BOOL) updateMoney:(NSInteger) money byUid:(NSString *) uid
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    
    NSString * updateSql = [NSString stringWithFormat:@"update user set money = %d where uid = '%@'",money,uid];
    
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"sql=%@",updateSql);
    NSLog(@"result=%d",result);
    [db close];
    return result;
    
}

+(BOOL) updateUserInfo:(NSDictionary *)data bySid:(NSString *) sid
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    //NSString *insertSql = @"update user set accessToken = ?,nickname = ?,gender = ?,headimgurl = ?,location = ? where userId=?";
    //  BOOL result = [db executeUpdate:insertSql,[data objectForKey:@"accessToken"],[data objectForKey:@"nickname"],[data objectForKey:@"gender"],[data objectForKey:@"headimgurl"],[data objectForKey:@"location"],[data objectForKey:@"userId"]];
    NSString * updateSql = @"update user set ";
    NSArray* fields = [data allKeys];
    for(int index=0;index<fields.count;index++){
        updateSql = [updateSql stringByAppendingFormat:@"%@='%@',",fields[index],[data objectForKey:fields[index]]];
    }
    updateSql = [updateSql substringToIndex:[updateSql length] -1];
    updateSql = [updateSql stringByAppendingFormat:@" where sid='%@'",sid];
    NSLog(@"sql=%@",updateSql);
    BOOL result = [db executeUpdate:updateSql];
    NSLog(@"result=%d",result);
    [db close];
    return result;
    
    
}
@end
