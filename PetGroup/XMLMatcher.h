//
//  XMLMatcher.h
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLMatcher : NSObject

+(NSNumber*)typeWithString1:(NSString *)str1 andString2:(NSString*)str2;
//str1为"Dog"或"Cat"或"Other"
//str2为具体的种类
+(NSArray*)allDogs;//所有狗的种类
+(NSArray*)allCats;//所有猫的种类
+(NSArray*)allother;//所有其他宠物
+(NSArray*)allType;//“狗狗”“猫咪”“其他”
+(NSArray*)allArray;//三个数组
+(NSString*)typeStringWithNumber:(NSString*)number;//根据number查找种类
@end
