//
//  PersonalDynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
#import "DynamicCellDelegate.h"
@interface PersonalDynamicCell : UITableViewCell

@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)id<DynamicCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath* indexPath;

+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
@end
