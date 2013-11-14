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
+(NSString *)noteContentCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)noteCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSDate *)getCurrentTimeFromString:(NSString *)datetime;
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime;
+(NSString *)getWeakDay:(NSDate *)datetime;
+(int)minusNowDate:(NSDate *)date;
+(NSString *)getmessageTime:(NSDate *)date;
+(UIImage *)imageFromText:(int)count image:(UIImage *)image;

+(float)diffHeight:(UIViewController *)controller;
@end
