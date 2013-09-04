//
//  PersonalCenterViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPhotoWall.h"
#import "HostInfo.h"
#import "PetInfo.h"
#import "MyInfoCell.h"
#import "MoreCell.h"
#import "MyPetProfileViewController.h"
#import "MyProfileViewController.h"
@class CustomTabBar;
@interface PersonalCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate>
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) HostInfo * hostInfo;
@end
