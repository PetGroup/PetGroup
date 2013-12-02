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
@interface ExperienceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic,strong) NSString * rootID;
@property (nonatomic,strong) NSArray * listArray;
@end
