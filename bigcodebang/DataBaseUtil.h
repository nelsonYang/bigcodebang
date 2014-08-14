//
//  DataBaseUtil.h
//  BigBand
//
//  Created by nelson on 14-7-6.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DataBaseUtil : NSObject
{

}
@property(retain,nonatomic) NSString *dbName;

+ (FMDatabase *) getLocalDB;


@end
