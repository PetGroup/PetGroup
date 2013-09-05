//
//  MyInfoCell.h
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
@interface MyInfoCell : UITableViewCell
@property (strong,nonatomic) EGOImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * signatureLabel;
@end
