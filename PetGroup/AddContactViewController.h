//
//  AddContactViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsCell.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PersonDetailViewController.h"
#import "HostInfo.h"
@interface AddContactViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UISearchBar * asearchBar;
    UISearchDisplayController * searchDisplay;
    MBProgressHUD * hud;
    UILabel * noResultLabel;
    NSString * searchCondition;
}
@property (strong,nonatomic) UITableView * resultTable;
@property (strong,nonatomic) NSMutableArray * resultArray;
@property (assign,nonatomic) int pageIndex;
@end
