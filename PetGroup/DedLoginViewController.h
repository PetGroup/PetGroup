//
//  DedLoginViewController.h
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface DedLoginViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD * hud;
}
@property (nonatomic,strong) NSDictionary* dic;

@end
