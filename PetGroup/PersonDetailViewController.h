//
//  PersonDetailViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempData.h"
#import "HostInfo.h"
#import "HGPhotoWall.h"
#import "PhotoWallCell.h"
#import "ProfileCell.h"
#import "MyProfileACell.h"
#import "NormalPetDetailViewController.h"
#import "PhotoViewController.h"
#import "KGStatusBar.h"
@class XMPPHelper,AppDelegate;
@interface PersonDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate,UIAlertViewDelegate>
{
    UITextField * locationTextF;
    UIView * typeMsgView;
}
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong, nonatomic) UIView *photoWallBG;
@property (strong, nonatomic) HGPhotoWall *photoWall2;
@property (strong, nonatomic) UIView *photoWallBG2;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) UIButton * helloBtn;
@property (strong,nonatomic) UIButton * rejectBtn;
@property (strong,nonatomic) UIView * genderBgV;
@property (strong,nonatomic) UIImageView * genderIV;
@property (strong,nonatomic) UILabel * ageLabel;
@property (strong,nonatomic) UILabel * regionLabel;
@property (strong,nonatomic) HostInfo * hostInfo;
@property (strong,nonatomic) NSArray * heightArray;
@property (assign,nonatomic) BOOL needRequest;
@property (assign,nonatomic) BOOL myFriend;
@property (strong,nonatomic) NSString * friendStatus;
@end
