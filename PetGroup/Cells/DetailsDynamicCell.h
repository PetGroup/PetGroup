//
//  DetailsDynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
@protocol DetailsDynamicCellDelegate<NSObject>
-(void)detailsDynamicCellPressNameButtonOrHeadButton;
-(void)detailsDynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray;
@end
@interface DetailsDynamicCell : UITableViewCell
@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)id<DetailsDynamicCellDelegate> delegate;
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
@end
