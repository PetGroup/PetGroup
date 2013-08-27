//
//  FriendsReqsViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addFriendCell.h"
@class AppDelegate, XMPPHelper;
@interface FriendsReqsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * receivedHellos;
}
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) UITableView * reqTableV;
@end
