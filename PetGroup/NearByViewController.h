//
//  NearByViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NearByCell.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "SRRefreshView.h"
#import "LocationManager.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PersonDetailViewController.h"
#import "PetDetailViewController.h"
@interface NearByViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,SRRefreshDelegate>{
    UIView * filterPage;
    UIView * filterBGV;
    UIButton * showPetBtn;
    MBProgressHUD * hud;
    int hostSex;
    int petType;
    SRRefreshView   *_slimeView;
    
    
    BOOL personOrPet;// yes == person ; no == pet
    
    UIButton * petCat;
    UIButton * petDog;
    UIButton * petOther;
    

    double latitude;
    double longitude;
    NSString * theGender;
    NSString * theType; 
    NSString * theCity;
    
}
@property (strong,nonatomic) UITableView * messageTable;
@property (strong,nonatomic) UITableView * petTypeTable;
@property (assign,nonatomic) int currentPage;
@property (assign,nonatomic) BOOL canRefresh;
@property (strong,nonatomic) NSMutableArray * nearbyArray;
@end
