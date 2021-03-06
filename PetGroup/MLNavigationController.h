//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationController : UINavigationController<UIGestureRecognizerDelegate>
{
    //UIPanGestureRecognizer *recognizer;
}
// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) UIPanGestureRecognizer *recognizer;
@property (nonatomic,assign) BOOL canDragBack;
-(void)setGestureEnableNO;
-(void)setGestureEnableYES;
@end
//@interface UIViewController (MLNavigationControllerSupport)
//@property(nonatomic, retain ,readonly) MLNavigationController *mlNavigationController;
//@end