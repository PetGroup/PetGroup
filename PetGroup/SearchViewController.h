//
//  SearchViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum
{
    searchTypeNew = 0,
    searchTypeEute,
    searchTypeInCircle
}SearchType;
@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel * noResultLabel;
    BOOL canShowKeyboard;
}
@property (nonatomic,retain)NSString* forumPid;
@property (nonatomic,assign)SearchType searchType;
@end
