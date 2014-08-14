//
//  DataBaseUtil.m
//  BigBand
//
//  Created by nelson on 14-7-6.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "DataBaseUtil.h"
#import "SandboxFile.h"

@implementation DataBaseUtil

static FMDatabase *db = nil;

+ (FMDatabase *) getLocalDB
{
   /* NSString *dbRes = [[NSBundle mainBundle] pathForResource:@"bigband" ofType:@"sqlite"];
    db = [FMDatabase databaseWithPath:dbRes];
    return db;*/
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	NSString *name = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",@"bigband.sqlite"]];
	NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:name];
    NSLog(@"fileName=%@,exist=%c",name,exist);
    if (!db) {
		db = [[FMDatabase alloc] initWithPath:name];
	}
 
	
    return db;
}

    

@end
