//
//  FollowerCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FollowerCell;
@protocol OwenrCellDelegate<NSObject>
-(void)followerCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)followerCellPressReportButtonAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface FollowerCell : UITableViewCell
@property (nonatomic,assign)NSIndexPath*indexPath;
@property (nonatomic,assign)id<OwenrCellDelegate>delegate;
@end
