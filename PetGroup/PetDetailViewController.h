//
//  PetDetailViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempData.h"
#import "HostInfo.h"
#import "PetInfo.h"
#import "HGPhotoWall.h"
#import "PhotoWallCell.h"
#import "ProfileCell.h"
#import "MyProfileACell.h"
#import "HostInfoCell.h"
#import "XMLMatcher.h"
#import "PersonDetailViewController.h"
@class CustomTabBar;
@interface PetDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate>

@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) UIView * genderBgV;
@property (strong,nonatomic) UIImageView * hostGenderIV;
@property (strong,nonatomic) UIImageView * petGenderIV;
@property (strong,nonatomic) UILabel * hostAgeLabel;
@property (strong,nonatomic) UILabel * petAgeLabel;
@property (strong,nonatomic) UILabel * regionLabel;
@property (strong,nonatomic) PetInfo * petInfo;
@property (strong,nonatomic) HostInfo * hostInfo;
@property (strong,nonatomic) NSArray * heightArray;
@end
