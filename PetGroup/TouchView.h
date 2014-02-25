//
//  TouchView.h
//  PetGroup
//
//  Created by wangxr on 14-2-25.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TouchView;
@protocol TouchViewDelegate <NSObject>
-(void)TouchViewBeginTouch:(TouchView*)touchView;
@end
@interface TouchView : UIView
@property (nonatomic,assign)id<TouchViewDelegate>delegate;
@end
