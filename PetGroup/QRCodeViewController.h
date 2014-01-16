//
//  QRCodeViewController.h
//  PetGroup
//
//  Created by Tolecen on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TempData.h"
#import "PetProfileCell.h"
@interface QRCodeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    float diffH;
}
@property (strong,nonatomic) UITableView * profileTableV;
@end
