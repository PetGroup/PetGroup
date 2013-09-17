//
//  MyPetProfileViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLMatcher.h"
#import "PetInfo.h"
#import "HGPhotoWall.h"
#import "PhotoWallCell.h"
#import "TempData.h"
#import "PetProfileCell.h"
#import "ButtonCell.h"
#import "ReportViewController.h"
#import "PhotoViewController.h"
typedef  enum
{
    PageStyleAdd = 0,
    PageStyleChange
}PageType;

@interface MyPetProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HGPhotoWallDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ChangeText,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    UIView * chooseRegionV;
    MBProgressHUD * hud;
}
@property (strong, nonatomic) HGPhotoWall *photoWall;
@property (strong,nonatomic) UITableView * profileTableV;
@property (strong,nonatomic) PetInfo * petInfo;
@property (assign,nonatomic) PageType pageType;
@property (strong,nonatomic) NSArray * titleArray;
@property (strong,nonatomic) NSMutableArray * discribeArray;
@property (strong,nonatomic) NSMutableArray * heightArray;
@property (strong,nonatomic) NSMutableArray * placeHolderArray;
@property (strong,nonatomic) NSMutableArray * waitingUploadImgArray;
@property (strong,nonatomic) NSMutableArray * waitingUploadStrArray;
@property (strong,nonatomic) NSArray * petTypeArray;
@property (strong,nonatomic) NSArray * petBreedArray;
@property (nonatomic ,strong) NSMutableArray* ageArray;
@property (nonatomic ,strong) NSArray* genderArray;
@property (nonatomic ,strong) UIPickerView* cityPV;
@property (nonatomic ,strong) UIPickerView* agePV;
@property (nonatomic ,strong) UIPickerView* genderPV;
@property (nonatomic ,strong) NSString* petTypeStr;
@property (nonatomic ,strong) NSString* petBreedStr;


@end
