//
//  IdentifyingString.h
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifyingString : NSObject

+(BOOL)isValidatePassWord:(NSString*)password;//验证密码格式知否正确
+(BOOL)validateMobile:(NSString* )mobile;//验证手机号格式是否正确

@end
