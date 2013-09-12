//
//  Common.h
//  WeShare
//
//  Created by Elliott on 13-5-7.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+(NSString *)getCurrentTime;
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSDate *)getCurrentTimeFromString:(NSString *)datetime;
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime;
+(NSString *)getWeakDay:(NSDate *)datetime;
+(int)minusNowDate:(NSDate *)date;
+(NSString *)getmessageTime:(NSDate *)date;
+(UIImage *)imageFromText:(int)count image:(UIImage *)image;
@end
