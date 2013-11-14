//
//  Common.m
//  WeShare
//
//  Created by Elliott on 13-5-7.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "Common.h"

@implementation Common

+(NSString *)getCurrentTime{

    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",nowTime];
    
}
+(NSString *)noteContentCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if (theCurrentT-theMessageT<3600) {
        return [NSString stringWithFormat:@"%d分钟前",(theCurrentT-(int)theMessageT)/60==0?1:(theCurrentT-(int)theMessageT)/60];
    }
    if ([messageDateStr isEqualToString:currentStr]) {
        return [NSString stringWithFormat:@"今天%@",[[messageTime substringFromIndex:11] substringToIndex:5]];
    }
    if (theCurrentT-theMessageT<3600*48) {
        return [NSString stringWithFormat:@"昨天%@",[[messageTime substringFromIndex:11] substringToIndex:5]];
    }
    return messageTime;
}
+(NSString *)noteCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    
    int theCurrentT = [currentTime intValue];
    if (theCurrentT-theMessageT<3600) {
        return [NSString stringWithFormat:@"%d分钟前",(theCurrentT-(int)theMessageT)/60==0?1:(theCurrentT-(int)theMessageT)/60];
    }
    if ((theCurrentT-theMessageT)<3600*24) {
        return [NSString stringWithFormat:@"%d小时前",(theCurrentT-(int)theMessageT)/(3600)];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    return [messageDateStr substringFromIndex:5];
}
//动态时间格式
+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        return @"今天";
      }
    if ([[messageDateStr substringToIndex:8] isEqualToString:[currentStr substringToIndex:8]]&&[[currentStr substringFromIndex:8]intValue] -[[messageDateStr substringFromIndex:8] intValue] == 1) {
        return @"昨天";
      }
    return [messageDateStr substringFromIndex:5];
}
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateF dateFromString:messageTime];
    NSTimeInterval theMessageT = [date timeIntervalSince1970];
    
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSString *chaStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT - theMessageT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    if ([messageDateStr isEqualToString:currentStr]) {
        int hours = [[nowT substringToIndex:2] intValue];
        int msgHour = [[msgT substringToIndex:2] intValue];
        if (msgHour == hours) {
            int minutes = [[nowT substringFromIndex:3] intValue];
            int msgMin = [[msgT substringFromIndex:3] intValue];
            if (msgMin == minutes) {
                finalTime = @"1分钟内";
            }else{
                finalTime = [NSString stringWithFormat:@"%d分钟前",minutes - msgMin];
            }
        }else{
            finalTime = [NSString stringWithFormat:@"%d小时前",hours - msgHour];
        }
    }else if([[messageDateStr substringToIndex:7] isEqualToString:[currentStr substringToIndex:7]]){
        int msgDay = [[messageDateStr substringFromIndex:8] integerValue];
        int day = [[currentStr substringFromIndex:8] integerValue];
        finalTime = [NSString stringWithFormat:@"%d天前",day - msgDay];
    }else if([[chaStr substringToIndex:7] isEqualToString:@"1970-01"]){
        int day = [[chaStr substringFromIndex:8] integerValue];
        finalTime = [NSString stringWithFormat:@"%d天前",day];
    }else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        int msgMonth = [[[messageDateStr substringToIndex:7] substringFromIndex:5]integerValue];
        int month = [[[currentStr substringToIndex:7] substringFromIndex:5]integerValue];
        finalTime = [NSString stringWithFormat:@"%d月前",month - msgMonth];
    }else{
        finalTime = messageDateStr;
    }
    return finalTime;
}
//首页显示时间格式
+(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    int theMessageT = [messageTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    int msgHour = [[msgT substringToIndex:2] intValue];
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    // NSLog(@"hours:%d,minutes:%d",hours,minutes);
    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
    int yesterdayBegin = currentDayBegin-3600*24;
    int qiantianBegin = yesterdayBegin-3600*24;
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
        
        
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"早上 %@",msgT];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"中午 %@",msgT];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"下午 %@",msgT];
        }
        else{
            finalTime = [NSString stringWithFormat:@"晚上 %@",msgT];
        }
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
        if (msgHour>0&&msgHour<11) {
            finalTime = @"昨天早上";
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = @"昨天中午";
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = @"昨天下午";
        }
        else{
            finalTime = @"昨天晚上";
        }
    }
    //前天
    else if (theMessageT>=qiantianBegin&&theMessageT<yesterdayBegin)
    {
        NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:theMessageT];
        NSString * weekday = [Common getWeakDay:msgDate];
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"%@早晨",weekday];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"%@中午",weekday];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"%@下午",weekday];
        }
        else{
            finalTime = [NSString stringWithFormat:@"%@晚上",weekday];
        }
    }
    //今年
    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        finalTime = [NSString stringWithFormat:@"%@月%@日",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8]];
    }
    
    else
    {
        finalTime = messageDateStr;
    }
    // NSLog(@"finalTime:%@",finalTime);
    return finalTime;
}


+(NSDate *)getCurrentTimeFromString:(NSString *)datetime{
    //NSString* string = @"May 9, 2013, 2:28:19 PM";
    //NSString* string = @"MMM dd, yyyy, HH:mm:ss";
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"MMM dd, yyyy, h:mm:ss a"];
    NSDate* inputDate = [inputFormatter dateFromString:datetime];
    return inputDate;
}

+(NSString *)getmessageTime:(NSDate *)date{
    if([self minusNowDate:date]==0){
        return [self getCurrentTimeFromString2:date];
    }
    else if([self minusNowDate:date]>0 && [self minusNowDate:date]<6 ){
        return [self getWeakDay:date];
    }else {
        return [self getCurrentTimeFromString3:date];
    }

}

//MM-dd
+(NSString *)getCurrentTimeFromString3:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

//HH:MM
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

+(NSString *)getWeakDay:(NSDate *)datetime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:datetime];
    switch ([comps weekday]) {
        case 1:
            return @"周日";break;
        case 2:
            return @"周一";break;
        case 3:
            return @"周二";break;
        case 4:
            return @"周三";break;
        case 5:
            return @"周四";break;
        case 6:
            return @"周五";break;
        case 7:
            return @"周六";break;
        default:
            return @"未知";break;
    }
}

//传来的日期和当前时间相隔几天
+(int)minusNowDate:(NSDate *)date{
    NSDate *now=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:now  options:0];
    int days = [comps day];
    return days;
}

+(UIImage *)imageFromText:(int)count image:(UIImage *)image{
    UIImage *myImage = image;
    NSString *myWatermarkText = [NSString stringWithFormat:@"%d",count];
    UIImage *watermarkedImage = nil;
    
    UIGraphicsBeginImageContext(myImage.size);
    [myImage drawAtPoint: CGPointZero];
    UIColor *redColor=[UIColor whiteColor];
    [redColor set];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    if(count<10){
        [myWatermarkText drawAtPoint: CGPointMake(22, 10) withFont: font];
    }else if(count<100){
        [myWatermarkText drawAtPoint: CGPointMake(18, 10) withFont: font];
    }else if(count<999){
        [myWatermarkText drawAtPoint: CGPointMake(10, 10) withFont: font];
    }else{
        [@"..." drawAtPoint: CGPointMake(18, 10) withFont: font];
    }
    watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkedImage;
}

+(float)diffHeight:(UIViewController *)controller
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        return 0.0f;
    } else {
        // Load resources for iOS 7 or later
        if (controller) {
            [controller setNeedsStatusBarAppearanceUpdate];
        }
        
        return 20.0f;
    }
}

@end
