//
//  DesEncrypt.m
//  BigBand
//
//  Created by nelson on 14-7-12.
//  Copyright (c) 2014年 ioschen. All rights reserved.
//

#import "DesEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DesEncrypt
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    //const char *textBytes = [plainText UTF8String];
    // NSUInteger dataLength = [plainText length];
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,kCCOptionPKCS7Padding,[key UTF8String], kCCKeySizeDES,[key UTF8String],[textData bytes], dataLength,                                          buffer,1024,&numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //   NSLog(@"length=%lu",(unsigned long)[buffer length]);
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext =[self parseByte2HexString:data];
        
    }
    return ciphertext;
    
}


+(NSString *)parseByte2HexString:(NSData *) data
{
    
    //  NSInteger length = [data length];
    Byte *bytes = [data bytes];
    NSMutableString *hexStr = [[[NSMutableString alloc]init] autorelease];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0'){
          //  NSLog(@"i=%d",bytes[i]);
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1){
                [hexStr appendFormat:@"0%@", hexByte];
            }else{
                [hexStr appendFormat:@"%@", hexByte];
            }
            i++;
        }
        
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}


@end
