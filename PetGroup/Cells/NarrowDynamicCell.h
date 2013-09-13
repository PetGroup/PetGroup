//
//  NarrowDynamicCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-13.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalDynamic.h"
@interface NarrowDynamicCell : UITableViewCell

@property (nonatomic,weak)UIButton* moveB;
@property (nonatomic,weak)PersonalDynamic*dynamic;
@property (nonatomic,weak)UIViewController* viewC;

@end
