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
@interface AddContactViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UISearchBar * asearchBar;
    UISearchDisplayController * searchDisplay;
    MBProgressHUD * hud;
}
@property (strong,nonatomic) UITableView * resultTable;
@property (assign,nonatomic) int pageIndex;
@end
