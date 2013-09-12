//
//  NormalPetDetailViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLMatcher.h"
#import "PetInfo.h"
#import "HGPhotoWall.h"
#import "PhotoWallCell.h"
#import "TempData.h"
#import "ProfileCell.h"
#import "PhotoViewController.h"
@interface NormalPetDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate>
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) PetInfo * petInfo;
@property (strong,nonatomic) NSArray * titleArray;
@property (strong,nonatomic) NSArray * discribeArray;
@property (strong,nonatomic) NSMutableArray * heightArray;
@end
