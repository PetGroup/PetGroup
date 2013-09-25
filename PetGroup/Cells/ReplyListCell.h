//
//  ReplyListCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicCell.h"
#import "EGOImageView.h"
@interface ReplyListCell : UITableViewCell
@property (nonatomic,retain)EGOImageView *headImageV;
@property (nonatomic,retain)UILabel*nameL;
@property (nonatomic,retain)UILabel*msgL;
@property (nonatomic,retain)UILabel*timeL;
@property (nonatomic,retain)EGOImageView *dynamicImageV;
@property (nonatomic,retain)UILabel* dynamicL;
@end
