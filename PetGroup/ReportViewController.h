//
//  ReportViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IdentifyingString.h"
@protocol ChangeText <NSObject>
-(void)changeText:(NSString *)textinfo WithIndex:(int)theIndex;
@end
@interface ReportViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    UILabel * remainingLabel;
    MBProgressHUD * hud;
    UIView * bigBG;
}
@property (strong,nonatomic) UITextView * inputTextF;
@property (strong,nonatomic) UITextField * emailField;
@property (strong,nonatomic) NSString * theTitle;
@property (strong,nonatomic) NSString * defaultContent;
@property (assign,nonatomic) id <ChangeText> textDelegate;
@property (assign,nonatomic) BOOL realReport;
@property (assign,nonatomic) int maxCount;
@property (assign,nonatomic) int thisIndex;
@end
