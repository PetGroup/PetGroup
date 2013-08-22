//
//  ContactsCell.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ContactsCell : UITableViewCell
@property (strong,nonatomic) UIImageView * backgroudImageV;
@property (strong,nonatomic) UIImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * distLabel;
@property (strong,nonatomic) UILabel * signatureLabel;
@property (strong,nonatomic) UILabel * unreadCountLabel;
@property (strong,nonatomic) UIImageView * sigBgImgV;
@property (strong,nonatomic) UILabel * numberLabel;
@property (strong,nonatomic) UIImageView * notiBgV;
@end
