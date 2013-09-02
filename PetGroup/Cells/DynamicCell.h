//
//  DynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
@interface DynamicCell : UITableViewCell

@property (nonatomic,weak)UIButton* moveB;
@property (nonatomic,weak)Dynamic*dynamic;
@property (nonatomic,weak)UIViewController* viewC;

@end
