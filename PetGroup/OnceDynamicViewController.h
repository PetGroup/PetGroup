//
//  OnceDynamicViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dynamic.h"
typedef enum {
    OnceDynamicViewControllerStyleNome,
    OnceDynamicViewControllerStyleReply,
    OnceDynamicViewControllerStyleZhuanfa
} OnceDynamicViewControllerStyle;
@interface OnceDynamicViewController : UIViewController
@property (nonatomic,retain)Dynamic* dynamic;
@property (nonatomic,assign)OnceDynamicViewControllerStyle onceDynamicViewControllerStyle;
@end
