//
//  PetknowledgeViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempData.h"
#import "CategoryViewController.h"
@interface PetknowledgeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * categoryArray;
}
@property (nonatomic,strong) UITableView * categoryTableV;
@end
