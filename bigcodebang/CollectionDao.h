//
//  CollectionDao.h
//  BigBand
//
//  Created by nelson on 14-7-6.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionDao : NSObject

+ (NSMutableArray *) getCollectionByPage:(NSInteger) pageIndex withPageCount:(NSInteger)  pageCount byUserId:(NSString *) userId;
+ (BOOL) insertCollection:(NSDictionary *) data;

+ (BOOL) deleteCollection:(NSString*) picId;
+ (BOOL) createCollection;

+ (BOOL) deleteAllCollection;

@end
