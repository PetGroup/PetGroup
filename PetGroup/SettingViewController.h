//
//  SettingViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewController.h"
#import "AboutAppViewController.h"
#import "TempData.h"
#import "ReconnectionManager.h"
@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    NSArray *titlesArray;
}
@property(strong,nonatomic) UITableView * settingTV;
@end
