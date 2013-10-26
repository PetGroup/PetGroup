//
//  DynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
@protocol DynamicCellDelegate<NSObject>
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressZanButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressZhuangFaButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray;
@end
@interface DynamicCell : UITableViewCell

@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)id<DynamicCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath* indexPath;

+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
@end
