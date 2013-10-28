//
//  DetailsDynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
#import "DynamicCellDelegate.h"
@interface DetailsDynamicCell : UITableViewCell
@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)id<DynamicCellDelegate> delegate;
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
@end
