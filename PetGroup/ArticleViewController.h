//
//  ArticleViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WebViewViewController.h"
@interface ArticleViewController : UIViewController
@property (nonatomic,assign)int floor;
@property (nonatomic,retain)NSString* articleID;
@property (nonatomic,assign)BOOL shouldDismiss;
@end
