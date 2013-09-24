//
//  EasyDynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
@interface EasyDynamicCell : UITableViewCell
@property (nonatomic,weak)UIButton* moveB;
@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)UIViewController* viewC;
@end
