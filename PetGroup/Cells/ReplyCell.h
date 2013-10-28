//
//  ReplyCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reply.h"
#import "DynamicCellDelegate.h"
@interface ReplyCell : UITableViewCell
@property (nonatomic,weak)id<DynamicCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath* indexPath;
@property (nonatomic,assign)Reply* reply;
+(CGFloat)heightForRowWithDynamic:(Reply*)reply;
@end
