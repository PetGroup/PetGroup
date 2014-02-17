//
//  ShowPetMessageViewController.h
//  PetGroup
//
//  Created by wangxr on 14-2-13.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPetMessageViewController.h"

@interface ShowPetMessageViewController : UIViewController
@property (nonatomic,assign)id<AddRQCodeMessageDelegate>delegate;
@property (nonatomic,retain)NSMutableDictionary* RQCodeMessage;
@end
