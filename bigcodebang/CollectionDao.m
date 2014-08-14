//
//  CollectionDao.m
//  BigBand
//
//  Created by nelson on 14-7-6.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "CollectionDao.h"
#import "DataBaseUtil.h"

@implementation CollectionDao

+ (NSMutableArray *) getCollectionByPage:(NSInteger) pageIndex withPageCount:(NSInteger) pageCount byUserId:(NSString *) userId
{
    FMDatabase *db = [DataBaseUtil getLocalDB];
    if(![db open]){
        NSLog(@"can not open databasee");
        return nil;
    }
    //FMResultSet *dbResult =  [db executeQueryWithFormat:@"select * from collection where limit %d,%d",(pageIndex -1) * pageCount, pageCount];
    FMResultSet *dbResult = [db executeQuery:@"select * from collection order by collectionId desc"];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    while([dbResult next]){
        
        NSString * userId = [dbResult stringForColumn:@"userId"];
        
        NSString * url = [dbResult stringForColumn:@"url"];
        
        NSString * sPicUrl = [dbResult stringForColumn:@"sPicUrl"];
        
        NSString * mPicUrl = [dbResult stringForColumn:@"mPicUrl"];
        
        NSString * voteDown = [dbResult stringForColumn:@"voteDown"];
        
        NSString * voteUp = [dbResult stringForColumn:@"voteUp"];
        
        NSString *title = [dbResult stringForColumn:@"title"];
        
        NSString *picId = [dbResult stringForColumn:@"picId"];
        
        NSString *collectionId = [dbResult stringForColumn:@"collectionId"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userId",url,@"url",sPicUrl,@"sPicUrl",mPicUrl,@"mPicUrl",voteDown,@"voteDown",voteUp,@"voteUp",title,@"title",picId,@"picId",collectionId,@"collectionId", nil];
        
        [result addObject:dic];
    }
    [db close];
    return  result;
    //return [result autorelease];
    
    
    
}
+ (BOOL) insertCollection:(NSDictionary *) data
{
    FMDatabase *db = [DataBaseUtil getLocalDB];
    if(![db open])
    {
        NSLog(@"cannot open database");
        return NO;
        
    }
    BOOL result = [db executeUpdate:@"insert into collection (userId,title,url,sPicUrl,mPicUrl,voteDown,voteUp,picId) values (?,?,?,?,?,?,?,?)",
                   [data objectForKey:@"userId"],[data objectForKey:@"title"], [data objectForKey:@"url"],[data objectForKey:@"sPicUrl"],[data objectForKey:@"mPicUrl"],[data objectForKey:@"voteDown"],[data objectForKey:@"voteUp"],[data objectForKey:@"picId"]];
    [db close];
    
    return result;
}

+ (BOOL) deleteCollection:(NSString*) picId
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    BOOL result =[db executeUpdate:[NSString stringWithFormat:@"delete from collection where picId = '%@'",picId]];
    [db close];
    return result;
}

+ (BOOL) deleteAllCollection
{
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    BOOL result =[db executeUpdate:@"delete from collection"];
    [db close];
    return result;
    
}


+ (BOOL) createCollection
{
    
    
    FMDatabase *db =  [DataBaseUtil getLocalDB];
    if (![db open]) {
        NSLog(@"cannot open database");
        return NO;
    }
    
    FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",@"collection"]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    if(existTable){
        NSLog(@"collection already exist");
    }else{
        
        NSString *createSql = @"CREATE TABLE collection (userId VARCHAR(20) NOT NULL , title VARCHAR(100), url VARCHAR(200), sPicUrl VARCHAR(200), mPicUrl VARCHAR(200), voteDown VARCHAR(10), voteUp VARCHAR(10), collectionId INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , picId VARCHAR(10))";
        BOOL result =  [db executeUpdate:createSql];
        if(result){
            NSLog(@"create success");
        }else{
            NSLog(@"create fail");
        }
    }
    return YES;
    
    
}

@end
