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
#import <CoreLocation/CoreLocation.h>
#import "TempData.h"
#import "PetProfileCell.h"
#import "ButtonCell.h"
#import "PhotoViewController.h"
#import "ReportViewController.h"
#import "MBProgressHUD.h"
typedef  enum
{
    ActionSheetTypeChoosePic = 1,
    ActionSheetTypeOperationPic
}ActionSheetType;
@interface MyProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HGPhotoWallDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ChangeText,MBProgressHUDDelegate>{
    UIView * chooseRegionV;
    UIView * chooseAgeV;
    MBProgressHUD * hud;
}
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) HostInfo * hostInfo;
@property (strong,nonatomic) NSArray * titleArray;
@property (assign,nonatomic) ActionSheetType actionSheetStyle;
@property (strong,nonatomic) NSMutableArray * discribeArray;
@property (strong,nonatomic) NSMutableArray * heightArray;
@property (strong,nonatomic) NSMutableArray * placeHolderArray;
@property (strong,nonatomic) NSMutableArray * waitingUploadImgArray;
@property (strong,nonatomic) NSMutableArray * waitingUploadStrArray;
@property (nonatomic ,strong) UIPickerView* cityPV;
@property (nonatomic ,strong) UIPickerView* agePV;
@property (nonatomic ,strong) UIPickerView* genderPV;
@property (nonatomic ,strong) NSMutableArray* ageArray;
@property (nonatomic ,strong) NSArray* ProvinceArray;
@property (nonatomic ,strong) NSArray* cityArray;
@property (nonatomic ,strong) NSArray* genderArray;

@end
