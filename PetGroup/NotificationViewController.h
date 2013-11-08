//
//  NotificationViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationCell.h"
#import "TempData.h"
@interface NotificationViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (strong,nonatomic) UITableView * notiTableV;
@property (strong,nonatomic) NSMutableArray * notiArray;
@end
