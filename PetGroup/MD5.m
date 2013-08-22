//
//  MD5.m
//  Wesync
//
//  Created by yongrong on 12-10-29.
//  Copyright (c) 2012年 sina weibo. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5

+ (NSString *) MD5String: (NSString *)string
{
    if (string == nil || [string length] == 0) {
        return nil;
    }

    const char *value = [string UTF8String];

    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);

    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }

    return outputString;
}

@end
