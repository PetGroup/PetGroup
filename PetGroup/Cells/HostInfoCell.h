//
//  HostInfoCell.h
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface HostInfoCell : UITableViewCell
@property (strong,nonatomic) UIImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UIImageView * genderIV;
@property (strong,nonatomic) UILabel * ageLabel;
@property (strong,nonatomic) UILabel * regionLabel;
@end
