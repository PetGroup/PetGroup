//
//  OnceCircleViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEntity.h"
@protocol OnceCircleViewControllerDelegate <NSObject>
-(void)joinOrQuitCircle;
@end
@interface OnceCircleViewController : UIViewController
@property (nonatomic,assign)id <OnceCircleViewControllerDelegate>delegate;
@property (nonatomic,assign)CircleEntity*circleEntity;
@end
