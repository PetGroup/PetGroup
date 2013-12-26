//
//  HeadImageCutViewController.h
//  PaoPaoArPro
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define HEAD_IMAGE_FRAME_LEFT 20
#define HEAD_IMAGE_FRAME_TOP  20
#define HEAD_IMAGE_FRAME_WIDTH  280
#define HEAD_IMAGE_FRAME_HEIGHT  280
#define HEAD_IMAGE_MAX_SCALE  3
#define HEAD_IMAGE_MIN_SCALE  1
#define HEAD_IMAGE_CHANGE_SCALE  0.5
#define HEAD_IMAGE_WIDTH 57
#define HEAD_IMAGE_HEIGHT 57
@protocol CutHeadImageSucceedDelegate <NSObject>

-(void)CutHeadImageSucceed:(UIImage* )headImage;

@end
@interface HeadImageCutViewController : UIViewController<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    UIToolbar *bottomToolbar;//下方的工具栏
    //原始图
    UIImage * mainImage;
    //切的头像图
    UIImage * headImage;
    //图像显示视图
    UIImageView * ShowImageView;
    //遮罩视图
    UIImageView * frontImageView;
    //测试用于显示切完的图视图
    //UIImageView * tempImageView;
    //原始图像视图的size 比例调整的依据
    CGRect OldheadImageRect;
    //手势开始时起点
    CGPoint gestureStartPoint;
    //移动时x,y方向上的偏移量
    CGFloat offsetX,offsetY;
    //当前倍数
    CGFloat scale;
    NSObject<CutHeadImageSucceedDelegate>*delegate;
    
    MBProgressHUD * hud;
}
@property(retain,nonatomic)NSObject<CutHeadImageSucceedDelegate>*delegate;
//选择一个原始图
- (id)initWithImage:(UIImage*)image;
@property (nonatomic,strong)NSArray* imgIDArray;
@property (nonatomic,assign)int indext;
//@property (nonatomic,assign)id<PhotoViewControllerDelegate>delegate;
//- (id)initWithPath:(NSString*)path;
- (id)initWithSmallImages:(NSArray*)sImages images:(NSArray*)images indext:(int)indext;
//+ (id)sharedInstance;
@end
