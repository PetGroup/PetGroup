//
//  DynamicCellDelegate.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DynamicCellDelegate <NSObject>
@optional
-(void)dynamicCellPressNameButtonOrHeadButton;
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressZanButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressZhuangFaButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray indext:(int)indext;
@end
