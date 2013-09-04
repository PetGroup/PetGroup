//
//  MyProfileViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLMatcher.h"
#import "HostInfo.h"
#import "HGPhotoWall.h"
#import "PhotoWallCell.h"
#import "TempData.h"
#import "PetProfileCell.h"
#import "ButtonCell.h"
@interface MyProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate>
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) HostInfo * hostInfo;
@property (strong,nonatomic) NSArray * titleArray;
@property (strong,nonatomic) NSMutableArray * discribeArray;
@property (strong,nonatomic) NSMutableArray * heightArray;
@property (strong,nonatomic) NSMutableArray * placeHolderArray;

@end
