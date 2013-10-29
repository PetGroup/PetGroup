//
//  EditDynamicViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDatasourceDidChange.h"
@interface EditDynamicViewController : UIViewController
@property (nonatomic,weak)id<TableViewDatasourceDidChange>delegate;
@end
