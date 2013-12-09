//
//  ExperienceListViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDetailViewController.h"
#import "TempData.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
@interface ExperienceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,SRRefreshDelegate>
{
    int thePage;
    BOOL canLoadMore;
}
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic,strong) NSString * rootID;
@property (nonatomic,strong) NSMutableArray * listArray;
@property (strong,nonatomic) MJRefreshFooterView *footer;
@property (nonatomic,retain)SRRefreshView* refreshView;
@end
