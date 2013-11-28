//
//  CircleCell.h
//  PetGroup
//
//  Created by wangxr on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEntity.h"
@protocol CircleCellDelegate<NSObject>
-(void)circleCellPressJoinBWithIndexPath:(NSIndexPath*)indexPath;
@end
@interface CircleCell : UITableViewCell
@property (nonatomic,retain)CircleEntity* circle;
@property (nonatomic,assign)id<CircleCellDelegate> delegate;
@property (nonatomic,retain)NSIndexPath* indexPath;
@property (nonatomic,retain)UIButton* joinB;
@end
