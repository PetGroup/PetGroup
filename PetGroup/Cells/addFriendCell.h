//
//  addFriendCell.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-2.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageButton.h"
@interface addFriendCell : UITableViewCell
@property (strong,nonatomic) EGOImageButton * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * msgLabel;
@property (strong,nonatomic) UIButton * agreeBtn;
@property (strong,nonatomic) UIButton * rejectBtn;
@property (strong,nonatomic) UILabel * unreadCountLabel;
@property (strong,nonatomic) UIImageView * notiBgV;
@end
