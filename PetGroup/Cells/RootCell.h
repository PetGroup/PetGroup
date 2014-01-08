//
//  RootCell.h
//  Test
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootCell : UITableViewCell
@property (nonatomic,weak)UIViewController*viewC;
@property (nonatomic,retain)NSArray * array;
+(CGFloat)heightForRowWithArrayCount:(NSUInteger)arrayCount;
@end
