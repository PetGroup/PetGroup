//
//  PersonalDynamicViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateAndDataSource.h"
@class AppDelegate,XMPPHelper;
@interface PersonalDynamicViewController : UIViewController<UITableViewDelegate>
@property (nonatomic,retain)DelegateAndDataSource* dataSource;
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)NSString* userName;
@property (nonatomic,retain)NSString* HeadImageID;
@property (strong,nonatomic) AppDelegate * appDel;
@end

