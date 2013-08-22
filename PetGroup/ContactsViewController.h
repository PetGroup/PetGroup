//
//  ContactsViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsCell.h"
#import "addFriendCell.h"
#import "TempData.h"
#import "AddContactViewController.h"
@class AppDelegate, XMPPHelper;
@interface ContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
}
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic)UITableView *contactsTable;
@end
