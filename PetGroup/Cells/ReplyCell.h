//
//  ReplyCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
@interface ReplyCell : UITableViewCell
@property (nonatomic,weak)UIViewController* viewC;
@property (nonatomic,weak)id theID;
@property (nonatomic,retain)OHAttributedLabel* ohaL;
@end
