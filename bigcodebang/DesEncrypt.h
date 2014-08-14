//
//  DesEncrypt.h
//  BigBand
//
//  Created by nelson on 14-7-12.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncrypt : NSObject
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+(NSString *)parseByte2HexString:(NSData *) data;
@end
