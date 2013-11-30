//
//  CategoryViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLMatcher.h"
#import "TempData.h"
#import "ExperienceListViewController.h"
#import "ContentDetailViewController.h"
typedef  enum
{
    TableTypePetCategory = 0,
    TableTypePetExperience
}TableType;
@interface CategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * petTypeArray;
    NSMutableArray * getPetTypeArray;
}
@property (nonatomic,strong) NSDictionary * petTypeDict;
@property (nonatomic,strong) NSMutableDictionary * getPetTypeDict;
@property (nonatomic,strong) UITableView * categoryTableV;
@property (assign,nonatomic) TableType tableType;
@end
