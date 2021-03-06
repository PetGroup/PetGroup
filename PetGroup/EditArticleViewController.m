//
//  EditArticleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EditArticleViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "FastTextView.h"
#import "IdentifyingString.h"
//#import "ImageAttachmentCell.h"
#import "SlideAttachmentCell.h"
#import "EmotionAttachmentCell.h"
#import <CoreText/CoreText.h>
#import "UIImage-Extensions.h"
#import "NSAttributedString+TextUtil.h"
#import "TextConfig.h"
#import "CircleClassify.h"
#import "CircleEntity.h"
@interface EditArticleViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel *  titleLabel;
    UIImageView* xialaIV;
    UIButton* xialaB;
    
    UIImageView* deleteIV;
    MBProgressHUD * hud;
    
    BOOL isAddSlide;

    CGFloat origin_y;
    NSMutableString * stringToPublish;
    NSMutableArray * tagArray;
    NSMutableArray * tagPositionArray;
    
    UIScrollView * scrollV;
    UIScrollView * scrollV2;
    NSArray * theTagArray;
    NSArray * theTagIdArray;
    NSMutableArray * tagSizeArray;
    
    UIImageView* tool;
//    FastTextView *_dynamicTV;
}
@property (nonatomic,strong)UIPlaceHolderTextView* titleTF;
@property (nonatomic,strong)FastTextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;
@property (nonatomic,retain)NSString* forumId;
@property (nonatomic,retain)NSString* forumName;
@property (nonatomic,retain)UIPickerView* circlePV;
@property (nonatomic,retain)UITextField*circleTF;
@property (nonatomic,retain)NSArray*circleArray;
@end

@implementation EditArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        theTagArray = [NSArray arrayWithObjects:@" 晒幸福 ",@" 求经验 ",@" 发求助 ",@" 其他 ", nil];
        theTagIdArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"TagList"];
        tagSizeArray = [NSMutableArray array];
//        manual = NO;
        self.assortID = @"";
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated
{
//    NSInteger a = [theTagIdArray indexOfObject:self.assortID];
//    [self selectTag:(a+100)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.forumId = ((CircleEntity*)((CircleClassify*)self.CircleTree[self.indexPath.section]).circleArray[self.indexPath.row]).circleID;
    self.forumName =((CircleEntity*)((CircleClassify*)self.CircleTree[self.indexPath.section]).circleArray[self.indexPath.row]).name;
    self.circleArray = ((CircleClassify*)self.CircleTree[self.indexPath.section]).circleArray;
    
//    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
//    [bgimgV setImage:[UIImage imageNamed:@"chat_bg"]];
//    [self.view addSubview:bgimgV];
    
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(-3, 0+diffH, 80, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==0.0f) {
//        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
    [cancelBtn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    self.forumName = @"新话题";
    CGSize size = [self.forumName sizeWithFont:[UIFont systemFontOfSize:18]];
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((320-size.width)/2, (44-size.height)/2+diffH, size.width, size.height)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:self.forumName];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
//    xialaIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala_bg"]];
//    xialaIV.frame = CGRectMake(titleLabel.frame.origin.x+size.width, 0+diffH, 15, 44);
//    [self.view addSubview:xialaIV];
//    
//    xialaB = [UIButton buttonWithType:UIButtonTypeCustom];
//    xialaB.frame = CGRectMake(titleLabel.frame.origin.x, diffH, size.width+15, 44);
//    [xialaB addTarget:self action:@selector(screen) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:xialaB];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(240, 0+diffH, 80, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==0.0f) {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
//    UIImage * bgImage = [[UIImage imageNamed:@"shurukuang.png"]
//               stretchableImageWithLeftCapWidth:0 topCapHeight:65];
//    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5, self.view.frame.size.height-(diffH+55.57+253+44))];
//    editIV.image = bgImage ;
//    [self.view addSubview:editIV];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(22.75, 63.75+diffH, 272.5, 20)];
//    _titleTF.placeholder = @"标题";
//    _titleTF.backgroundColor = [UIColor clearColor];
//    _titleTF.delegate = self;
//    [self.view addSubview:_titleTF];
//    [_titleTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.titleTF = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(5, 48.75+diffH, 310, 40)];
    self.titleTF.backgroundColor = [UIColor clearColor];
    self.titleTF.font = [UIFont systemFontOfSize:16];
    self.titleTF.placeholder = @"标题(必填)";
    self.titleTF.delegate = self;
    [self.view addSubview:self.titleTF];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 56.75+diffH+30+4, 300, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [self.view addSubview:lineView];
    
    theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-227, 320, 207.5) WithSendBtn:NO withDeleteBtn:YES];
    theEmojiView.delegate = self;
    [self.view addSubview:theEmojiView];
    theEmojiView.hidden = YES;
    
    self.dynamicTV = [[FastTextView alloc]initWithFrame:CGRectMake(3, 93.75+diffH, 314,self.view.frame.size.height-(diffH+55.57+253+44)-20-20)];
    _dynamicTV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dynamicTV.delegate = (id<FastTextViewDelegate>)self;
    _dynamicTV.attributeConfig=[TextConfig editorAttributeConfig];
    _dynamicTV.placeHolder=@"内容(必填)";
    [_dynamicTV setFont:[UIFont systemFontOfSize:17]];
    _dynamicTV.pragraghSpaceHeight=15;
    _dynamicTV.backgroundColor=[UIColor clearColor];

    [self.view addSubview:_dynamicTV];
    [self.titleTF becomeFirstResponder];
    
    tool = [[UIImageView alloc]initWithFrame:CGRectMake(0, _dynamicTV.frame.origin.y+_dynamicTV.frame.size.height+2, 320, 44)];
    tool.backgroundColor = [UIColor clearColor];
    tool.userInteractionEnabled = YES;
    tool.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    tool.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] CGColor];
    tool.layer.borderWidth = 1;
    
//    UIImageView* tool2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _dynamicTV.frame.origin.y+_dynamicTV.frame.size.height+2, 320, 44)];
//    tool2.backgroundColor = [UIColor clearColor];
//    tool2.userInteractionEnabled = YES;
//    tool2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    tool2.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] CGColor];
//    tool2.layer.borderWidth = 1;

//    _dynamicTV.inputAccessoryView = tool;
//    self.titleTF.inputAccessoryView = tool2;
    [self.view addSubview:tool];
    
    
    scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 225, 44)];
//    scrollV.delegate = self;
//    scrollV.contentSize = CGSizeMake(320, 44);
    scrollV.showsHorizontalScrollIndicator=NO;
	scrollV.showsVerticalScrollIndicator=NO;
    float aWidth = 0.0f;
    float bWidth = 0.0f;
    for (int i = 0;i < theTagArray.count;i ++) {
        UILabel * tagTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
        tagTitleLabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        tagTitleLabel.textColor = [UIColor whiteColor];
        tagTitleLabel.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
//        [tagTitleLabel setBackgroundColor:[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1]];
        [tagTitleLabel setBackgroundColor:[UIColor lightGrayColor]];
        tagTitleLabel.layer.cornerRadius = 4;
        tagTitleLabel.layer.masksToBounds = YES;
        tagTitleLabel.tag = i + 100;
//        tagTitleLabel.alpha = 0.5;
        
        NSString *str = theTagArray[i];
        CGSize size = [str sizeWithFont:tagTitleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 25) lineBreakMode:NSLineBreakByWordWrapping];
        //根据计算结果重新设置UILabel的尺寸
        [tagTitleLabel setFrame:CGRectMake(0, 0, size.width, 25)];
        tagTitleLabel.text = str;
        
        aWidth = aWidth + size.width+10;
        
        UIButton* tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame = CGRectMake(aWidth-size.width, 8.5, size.width, 25);
        [tagSizeArray addObject:[NSNumber numberWithFloat:(aWidth-size.width)]];
        [tagBtn addSubview:tagTitleLabel];
        [tagBtn addTarget:self action:@selector(setTopicTag:) forControlEvents:UIControlEventTouchUpInside];
        tagBtn.tag = i + 100;
        [scrollV addSubview:tagBtn];
        bWidth = size.width;
        
    }
    scrollV.contentSize = CGSizeMake(aWidth, 44);
    
//    scrollV2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 225, 44)];
//    scrollV2.delegate = self;
//    //    scrollV.contentSize = CGSizeMake(320, 44);
//    scrollV2.showsHorizontalScrollIndicator=NO;
//	scrollV2.showsVerticalScrollIndicator=NO;
//    float aWidth2 = 0.0f;
//    float bWidth2 = 0.0f;
//    for (int i = 0;i < theTagArray.count;i ++) {
//        UILabel * tagTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
//        tagTitleLabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//        tagTitleLabel.textColor = [UIColor whiteColor];
//        tagTitleLabel.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
//        [tagTitleLabel setBackgroundColor:[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1]];
//        tagTitleLabel.layer.cornerRadius = 4;
//        tagTitleLabel.layer.masksToBounds = YES;
//        tagTitleLabel.tag = i + 100;
//        
//        NSString *str = theTagArray[i];
//        CGSize size = [str sizeWithFont:tagTitleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 25) lineBreakMode:NSLineBreakByWordWrapping];
//        //根据计算结果重新设置UILabel的尺寸
//        [tagTitleLabel setFrame:CGRectMake(0, 0, size.width, 25)];
//        tagTitleLabel.text = str;
//        
//        aWidth2 = aWidth2 + size.width+10;
//        
//        UIButton* tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        tagBtn.frame = CGRectMake(aWidth2-size.width, 8.5, size.width, 25);
//        [tagBtn addSubview:tagTitleLabel];
//        [tagBtn addTarget:self action:@selector(setTopicTag:) forControlEvents:UIControlEventTouchUpInside];
//        tagBtn.tag = i + 100;
//        [scrollV2 addSubview:tagBtn];
//        bWidth2 = size.width;
//        
//    }
//    scrollV2.contentSize = CGSizeMake(aWidth2, 44);
    [tool addSubview:scrollV];
//    [tool2 addSubview:scrollV2];
    
//    [tool2 addSubview:scrollV];
    
    imageB = [UIButton buttonWithType:UIButtonTypeCustom];
    imageB.frame = CGRectMake(278, 5, 30, 30);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(229,-1 , 43, 43)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [tool addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton * imageB2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    imageB2.frame = CGRectMake(278, 5, 30, 30);
//    [imageB2 setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
//    [tool2 addSubview:imageB2];
//    [imageB2 setEnabled:NO];
//    
//    UIButton * emojiBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [emojiBtn2 setFrame:CGRectMake(229,-1 , 43, 43)];
//    [emojiBtn2 setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
//    [tool2 addSubview:emojiBtn2];
//    [emojiBtn2 setEnabled:NO];

    

 
    self.circleTF = [[UITextField alloc]init];
    [self.view addSubview:_circleTF];
    self.circlePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _circlePV.dataSource = self;
    _circlePV.delegate = self;
    _circlePV.showsSelectionIndicator = YES;
    _circleTF.inputView = _circlePV;
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectCircle)];
    rb.tintColor = [UIColor blackColor];
    toolbar.items = @[rb];
    _circleTF.inputAccessoryView = toolbar;
    
//    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
//    [[UIApplication sharedApplication].keyWindow addSubview:hud];
//    [hud setMyFrameHaveKeyboard];
//    hud.delegate = self;
//    hud.labelText = @"发布中...";
    
//    [self screen];
}

-(void)showTheHUD
{
    if (hud == nil)
    {
        
        NSLog(@"windows count %d \n",[[UIApplication sharedApplication].windows count]);
        if ([[UIApplication sharedApplication].windows count] > 1 )
        {
            UIWindow *win=[[UIApplication sharedApplication].windows objectAtIndex:1];
            if (win)
            {
                NSLog(@"windows 1111111111111 \n");
                hud = [[MBProgressHUD alloc] initWithWindow:win];
                // Add HUD to screen
                [win addSubview:hud];
            }
            
        }
        else
        {
            // Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
            hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
            
            // Add HUD to screen
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            
            // Regisete for HUD callbacks so we can remove it from the window at the right time
        }
        hud.delegate = self;
        
        hud.labelText = @"发布中...";
        
        [hud show:YES];
        
        
    }
    else
    {
        [hud show:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    if (manual) {
////        if (scrollView==scrollV) {
////            scrollV2.contentOffset = scrollView.contentOffset;
////            manual = NO;
////        }
////        else if(scrollView==scrollV2)
////        {
////            scrollV.contentOffset = scrollView.contentOffset;
////            manual = NO;
////        }
////    }
////    manual = NO;
//
//}
-(void)setTopicTag:(UIButton *)sender
{
//    manual = YES;
    int btnID = sender.tag;
//    UIButton * tB = (UIButton *)[scrollV2 viewWithTag:btnID];
//    UILabel * tempL = (UILabel *)[tB viewWithTag:btnID];
//    
//    tempL.layer.cornerRadius = 4;
//    tempL.layer.borderColor = [[UIColor orangeColor] CGColor];
//    tempL.layer.borderWidth = 2;
//    tempL.layer.masksToBounds = YES;
////    [tempL setBackgroundColor:[UIColor lightGrayColor]];
//    
//    for (UIButton * tpBtn in scrollV2.subviews) {
//        if (tpBtn.tag!=btnID) {
//            UILabel * tempL2 = (UILabel *)[tpBtn viewWithTag:tpBtn.tag];
////            [tempL2 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1]];
//            tempL2.layer.cornerRadius = 4;
//            tempL2.layer.borderWidth = 0;
//            tempL2.layer.masksToBounds = YES;
//        }
//    }
    
    UIButton * tB2 = (UIButton *)[scrollV viewWithTag:btnID];
    UILabel * tempLa = (UILabel *)tB2.subviews[0];
    
//    tempLa.layer.cornerRadius = 4;
////    tempLa.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1] CGColor];
//    tempLa.layer.borderWidth = 0;
//    tempLa.layer.masksToBounds = YES;
    [tempLa setBackgroundColor:[UIColor orangeColor]];
    tempLa.layer.cornerRadius = 4;
    tempLa.layer.borderWidth = 0;
    tempLa.layer.masksToBounds = YES;
    
    for (UIButton * tpBtn in scrollV.subviews) {
        if (tpBtn.tag!=btnID) {
            UILabel * tempL2a = (UILabel *)tpBtn.subviews[0];
            [tempL2a setBackgroundColor:[UIColor lightGrayColor]];
            tempL2a.layer.cornerRadius = 4;
            tempL2a.layer.borderWidth = 0;
            tempL2a.layer.masksToBounds = YES;
        }
    }
    
    self.assortID = theTagIdArray[btnID-100];
    NSLog(@"tagID = %@",theTagIdArray[btnID-100]);
//    float scSizeOx = [tagSizeArray[(btnID-100)] floatValue];
//    scrollV.contentOffset = CGPointMake(scSizeOx, scrollV.contentOffset.y);
//    scrollV2.contentOffset = CGPointMake(scSizeOx, scrollV2.contentOffset.y);
}
-(void)selectTag:(int)btnID
{
//    UIButton * tB = (UIButton *)[scrollV2 viewWithTag:btnID];
//    UILabel * tempL = (UILabel *)[tB viewWithTag:btnID];
//    
//    tempL.layer.cornerRadius = 4;
//    tempL.layer.borderColor = [[UIColor orangeColor] CGColor];
//    tempL.layer.borderWidth = 2;
//    tempL.layer.masksToBounds = YES;
//    //    [tempL setBackgroundColor:[UIColor lightGrayColor]];
//    
//    for (UIButton * tpBtn in scrollV2.subviews) {
//        if (tpBtn.tag!=btnID) {
//            UILabel * tempL2 = (UILabel *)[tpBtn viewWithTag:tpBtn.tag];
//            //            [tempL2 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1]];
//            tempL2.layer.cornerRadius = 4;
//            tempL2.layer.borderWidth = 0;
//            tempL2.layer.masksToBounds = YES;
//        }
//    }
    
    UIButton * tB2 = (UIButton *)[scrollV viewWithTag:btnID];
    UILabel * tempLa = (UILabel *)[tB2 viewWithTag:btnID];
    
    tempLa.layer.cornerRadius = 4;
    tempLa.layer.borderColor = [[UIColor orangeColor] CGColor];
    tempLa.layer.borderWidth = 2;
    tempLa.layer.masksToBounds = YES;
    //    [tempL setBackgroundColor:[UIColor lightGrayColor]];
    
    for (UIButton * tpBtn in scrollV.subviews) {
        if (tpBtn.tag!=btnID) {
            UILabel * tempL2a = (UILabel *)[tpBtn viewWithTag:tpBtn.tag];
            //            [tempL2 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.64 blue:0.8 alpha:1]];
            tempL2a.layer.cornerRadius = 4;
            tempL2a.layer.borderWidth = 0;
            tempL2a.layer.masksToBounds = YES;
        }
    }
    
    self.assortID = theTagIdArray[btnID-100];
    NSLog(@"tagID = %@",theTagIdArray[btnID-100]);
//    float scSizeOx = [tagSizeArray[(btnID-100)] floatValue];
    if (btnID-100 != 0) {
//        [UIView animateWithDuration:0.3 animations:^{
            scrollV.contentOffset = CGPointMake(45, scrollV.contentOffset.y);
//            scrollV2.contentOffset = CGPointMake(45, scrollV2.contentOffset.y);
//        } completion:^(BOOL finished) {
//            
//        }];

    }
//    scrollV.contentOffset = CGPointMake(40, scrollV.contentOffset.y);
//    scrollV2.contentOffset = CGPointMake(40, scrollV2.contentOffset.y);
}
-(void)showEmojiScrollView
{
    [_dynamicTV resignFirstResponder];
    [tool setFrame:CGRectMake(0, self.view.frame.size.height-227-tool.frame.size.height, 320, tool.frame.size.height)];
    theEmojiView.hidden = NO;
    [theEmojiView setFrame:CGRectMake(0, self.view.frame.size.height-227, 320, 227)];
//    [self autoMovekeyBoard:253];
    
}

-(void)hideEmojiView
{
    
}

-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!ifEmoji) {
        [_dynamicTV resignFirstResponder];
//        _dynamicTV.inputView = theEmojiView;
//        [_dynamicTV becomeFirstResponder];
        ifEmoji = YES;
        [self showEmojiScrollView];
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        
    }
    else
    {
//        [_dynamicTV resignFirstResponder];
//        _dynamicTV.inputView = nil;
        [_dynamicTV becomeFirstResponder];
        ifEmoji = NO;
        [sender setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
}
-(void)backBtnDo
{
    if (_dynamicTV.text.length>=1) {
        _dynamicTV.text = [_dynamicTV.text substringToIndex:(_dynamicTV.text.length-1)];
    }
    
}
-(void)deleteEmojiStr
{
    [_dynamicTV deleteBackward];
}
-(NSString *)selectedEmoji:(NSString *)ssss
{
//	if (_dynamicTV.text == nil) {
//		_dynamicTV.text = ssss;
//	}
//	else {
        UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
        if (!selectedTextRange) {
            UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
            selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
        }
        UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
        
//        unichar attachmentCharacter = FastTextAttachmentCharacter;
        [_dynamicTV replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"%@",ssss]];
        
        //    startPosition=[_fastTextView positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
        UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
        selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
        
        
        NSMutableAttributedString *mutableAttributedString=[_dynamicTV.attributedString mutableCopy];
        
        NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
        NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
        
        if (en < st) {
            return 0;
        }
        NSUInteger contentLength = [[_dynamicTV.attributedString string] length];
        if (en > contentLength) {
            en = contentLength; // but let's not crash
        }
        if (st > en)
            st = en;
        NSRange cr = [[_dynamicTV.attributedString string] rangeOfComposedCharacterSequencesForRange:(NSRange){ st, en - st }];
        if (cr.location + cr.length > contentLength) {
            cr.length = ( contentLength - cr.location ); // but let's not crash
        }
        if (mutableAttributedString) {
            _dynamicTV.attributedString = mutableAttributedString;
        }
//		_dynamicTV.text = [_dynamicTV.text stringByAppendingString:ssss];
//	}
    
    return 0;
}
-(void)emojiSendBtnDo
{
    
}
#pragma mark - button action
-(void)screen
{
    [_circleTF becomeFirstResponder];
    [_circlePV selectRow:self.indexPath.section inComponent:0 animated:NO];
    [_circlePV selectRow:self.indexPath.row inComponent:1 animated:NO];
}
-(void)didselectCircle
{
    [_circleTF resignFirstResponder];
}
-(void)backButton:(UIButton*)button
{
//    [[TempData sharedInstance] Panned:NO];
    [_circleTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
}

-(void)next
{
//    if (_dynamicTV.text.length<=0||_titleTF.text.length<=0) {
//        return;
//    }
//    if (self.pictureArray.count>0) {
//        NSMutableArray* imageArray = [[NSMutableArray alloc]init];
//        NSMutableArray* nameArray = [[NSMutableArray alloc]init];
//        self.imageId = [[NSMutableString alloc]init];
//        for (int i = 0;i< self.pictureArray.count;i++) {
//            [imageArray addObject:((UIImageView*)self.pictureArray[i]).image];
//            [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//        [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//            for (NSString*a in responseObject) {
//                [_imageId appendFormat:@"<img src=\""BaseImageUrl"%@"@"\">",[responseObject objectForKey:a]];
//            }
//         [self publishWithImageString:_imageId];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    }else{
//        [self publishWithImageString:nil];
//    }
    
//    if ([IdentifyingString isValidateAllSpace:_titleTF.text]) {
//
//    }
    if (_titleTF.text.length<3||[IdentifyingString isValidateAllSpace:_titleTF.text]||_titleTF.text.length>40) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"写个标题吧，最少3个字，但是也不要超过40个字" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_dynamicTV.text.length<4||[IdentifyingString isValidateAllSpace:_dynamicTV.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不写点内容能行么，至少4个字吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.assortID.length<=1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"给你的帖子选一个合适的分类吧，就是在编辑正文的时候键盘上面的灰色小按钮哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self showTheHUD];
//    [_titleTF resignFirstResponder];
//    [_dynamicTV resignFirstResponder];
    NSArray *fileArray=[NSAttributedString getAttachmentsForNewFileName:_dynamicTV.attributedString];
    if (fileArray.count>0) {
        NSMutableArray *uploadImageArray = [NSMutableArray array];
        NSArray * filenameArray = [fileArray objectAtIndex:0];
        NSArray * fileIndexArray = [fileArray objectAtIndex:1];
        NSMutableArray *imgWidthArray = [NSMutableArray array];
        NSMutableArray *imgHeightArray = [NSMutableArray array];
        for (NSString * fileName in filenameArray) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UploadTopicPics/%@",fileName]];
            UIImage * tempImg = [UIImage imageWithContentsOfFile:path];
            [imgWidthArray addObject:[NSString stringWithFormat:@"%f",280.0f]];
            [imgHeightArray addObject:[NSString stringWithFormat:@"%f",tempImg.size.height*280/tempImg.size.width]];
            [uploadImageArray addObject:tempImg];
        }
        [self uploadForMixingTypePics:uploadImageArray PicsName:filenameArray PositionArray:fileIndexArray Width:imgWidthArray Height:imgHeightArray];
        NSLog(@"theArray:%@",fileArray);

    }
    else
    {
        [self publishWithImageString:_dynamicTV.text];
    }
}
-(void)uploadForMixingTypePics:(NSArray *)imageArray PicsName:(NSArray *)picsNameArray PositionArray:(NSArray *)positionArray Width:(NSArray *)widthArray Height:(NSArray *)heightArray
{
    [NetManager uploadWaterMarkImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:picsNameArray TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSMutableArray * idArray = [NSMutableArray array];
        for (NSString * name in picsNameArray) {
            [idArray addObject:[responseObject objectForKey:name]];
        }
        NSString * finalStr = [self publishFinalTextWithImageIDArray:idArray imageSizeWidthArray:widthArray imageSizeHeightArray:heightArray];
        [self publishWithImageString:finalStr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(NSString *)publishFinalTextWithImageIDArray:(NSArray *)imageIDArray imageSizeWidthArray:(NSArray *)imgWidthArray imageSizeHeightArray:(NSArray *)imgHeightArray
{
    NSMutableString * finalT = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<p>%@</p>",_dynamicTV.text]];
    NSMutableArray * tagArraye = [NSMutableArray array];
    for (int i = 0; i<imageIDArray.count;i++) {
        [tagArraye addObject:[NSString stringWithFormat:@"</p><a href=\"%@%@\"><img align=\"center\" width=\"%d\" height=\"%d\" src=\"%@%@\"></a><p>",BaseImageUrl,[imageIDArray objectAtIndex:i],[[imgWidthArray objectAtIndex:i]intValue],[[imgHeightArray objectAtIndex:i]intValue],BaseImageUrl,[imageIDArray objectAtIndex:i]]];
    }
    unichar attachmentCharacter = FastTextAttachmentCharacter;
    NSArray * rrr = [finalT componentsSeparatedByString:[NSString stringWithCharacters:&attachmentCharacter length:1]];
    int tempCount = rrr.count;
    NSLog(@"rrr:%@",rrr);
    NSMutableArray * ggg = [NSMutableArray arrayWithArray:rrr];
    for (int i = 0; i<tagArraye.count; i++) {
        [ggg insertObject:tagArraye[tagArraye.count-i-1] atIndex:tempCount-i-1];
        NSLog(@"ssss:%@",ggg);
    }
    NSMutableString * ddd = [[NSMutableString alloc] init];
    for (NSString * uu in ggg) {
        [ddd appendString:uu];
//        [ddd stringByAppendingString:uu];
        NSLog(@"ysysysy:%@",uu);
    }
    NSLog(@"finalString:%@",ddd);
    return ddd;
}
-(void)publishWithImageString:(NSString*)imageString
{//body={"method":"sendNote","token":"","params":{"userId":"33333","forumId":"DBEF25E53AA5401384CFC60603CC3FC7","name":"子集4的帖子","content":"子集4的帖子"}}
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([[TempData sharedInstance] getMyUserID]&&![[[TempData sharedInstance] getMyUserID] isKindOfClass:[NSNull class]]) {
        [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
    }
    [params setObject:self.assortID forKey:@"assortId"];
    [params setObject:_titleTF.text forKey:@"name"];
    [params setObject:imageString forKey:@"content"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"sendNote" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        NSLog(@"stringuu = %@",responseObject);
        [self upOneDymicWithNoteID:responseObject];
        [self getMyArticleWithId:responseObject];
        
        [self backButton:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:@"发布失败,请稍候再试!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertV show];
        [hud hide:YES];
    }];
}
-(void)getMyArticleWithId:(NSString*)articleId
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString*dateS = [dateF stringFromDate:[NSDate date]];
    NSDictionary* d = [DataStoreManager queryMyInfo];
    NSString* articleid = articleId;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:articleid forKey:@"id"];
    [dic setObject:[d objectForKey:@"nickname"] forKey:@"nickname"];
    [dic setObject:[d objectForKey:@"img"] forKey:@"userIcon"];
    [dic setObject:[d objectForKey:@"id"] forKey:@"userId"];
    [dic setObject:self.titleTF.text forKey:@"name"];
    [dic setObject:dateS forKey:@"ct"];
    [dic setObject:dateS forKey:@"et"];
    [dic setObject:@"0" forKey:@"cTotalReply"];
    [dic setObject:@"0" forKey:@"clientCount"];
//    [dic setObject:self.forumId forKey:@"forumId"];
    [dic setObject:@"0" forKey:@"isEute"];
    [dic setObject:@"0" forKey:@"isTop"];
    [dic setObject:@"0" forKey:@"totalReply"];
    [dic setObject:@"0" forKey:@"type"];
    Article* aricle = [[Article alloc]initWithDictionnary:dic];
    if (self.delegate&& [self.delegate respondsToSelector:@selector(editArticleViewDidEdit:)]) {
        [self.delegate editArticleViewDidEdit:aricle];
    }
}
-(void)upOneDymicWithNoteID:(NSString*)noteID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:[NSString stringWithFormat:@"bbsNoteId_%@",noteID] forKey:@"transmitUrl"];
    [params setObject:[NSString stringWithFormat:@"《%@》",self.titleTF.text] forKey:@"msg"];
    [params setObject:@"true" forKey:@"ifTransmitMsg"];
    [params setObject:[NSString stringWithFormat:@"我在%@发布了一篇帖子:",self.forumName] forKey:@"transmitMsg"];
    [params setObject:@"" forKey:@"imgid"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"addUserState" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"dynamicID = %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getAnActionSheet
{
    NSArray *fileArray=[NSAttributedString getAttachmentsForNewFileName:_dynamicTV.attributedString];
    if (fileArray.count>0) {
        NSArray * dd = fileArray[0];
        if (dd.count>=5) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加了5张图片了，休息一会吧，或者换个楼层发吧~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
//    if (_pictureArray.count<=8) {
        self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [_addActionSheet showInView:self.view];
//    }
}
-(void)tapImage:(UIGestureRecognizer*)tapGR
{
    deleteIV = (UIImageView*)tapGR.view;
    self.deleteActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [_deleteActionSheet showInView:self.view];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"%@",textField.text);
//    return YES;
//}
- (void) textFieldDidChange:(UITextField *) textField
{
    NSLog(@"%@",textField.text);
    if (textField.text.length>2&&[[Emoji allEmoji] containsObject:[textField.text substringFromIndex:textField.text.length-2]]) {
        textField.text = [textField.text substringToIndex:textField.text.length-2];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>2&&[[Emoji allEmoji] containsObject:text]) {
        NSMutableString * at = [NSMutableString stringWithString:textView.text];
        [at replaceCharactersInRange:range withString:@""];
        textView.text = (NSString *)at;
    }
    if (textView.text.length>40)
    {
        textView.text=[textView.text substringToIndex:40];
    }
    return YES;
}
#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"今天想跟别人说点什么……";
    }
    if (textView.text.length>=2&&[[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
        textView.text = [textView.text substringToIndex:textView.text.length-2];
    }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [emojiBtn setEnabled:NO];
    [imageB setEnabled:NO];
    return YES;
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _addActionSheet) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                    isAddSlide=true;
                    [self presentViewController:imagePicker animated:YES completion:^{
                        
                    }];
                }
                else {
                    UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [cameraAlert show];
                }
            }break;
            case 1:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    isAddSlide=true;
//                    [self presentModalViewController:imagePicker animated:YES];
                    [self presentViewController:imagePicker animated:YES completion:^{
                        
                    }];
                }
                else {
                    UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                    [libraryAlert show];
                }
                
            }break;
            default:
                break;
        }
    }else{
        if (buttonIndex == 0) {
            NSUInteger index = [_pictureArray indexOfObject:deleteIV];
            [UIView animateWithDuration:0.3 animations:^{
                for (int i = _pictureArray.count-1; i > index ; i-- ) {
                    ((UIImageView*)_pictureArray[i]).frame = ((UIImageView*)_pictureArray[i-1]).frame;
                }
            }];
            [deleteIV removeFromSuperview];
            [_pictureArray removeObject:deleteIV];
        }
    }
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        CIImage *image = nil;
//        image = [CIImage imageWithCGImage:gotImage.CGImage
//                                  options:@{kCIImageProperties : [info  objectForKey:UIImagePickerControllerMediaMetadata]}];
        [self _addAttachmentFromAsset:gotImage];
    } else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
        [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
                 resultBlock:^(ALAsset *asset){
                     // This get called asynchronously (possibly after a permissions question to the user).
                     ALAssetRepresentation *rep = [asset defaultRepresentation];
                     NSMutableData *data = [NSMutableData dataWithLength:[rep size]];
                     NSError *error = nil;
                     if ([rep getBytes:[data mutableBytes] fromOffset:0 length:[rep size] error:&error] == 0) {
                         NSLog(@"error getting asset data %@", [error debugDescription]);
                     } else {
                         UIImage *img=[UIImage imageWithData:data];
                         [self _addAttachmentFromAsset:img];
                     }
                     
                 }
                failureBlock:^(NSError *error){
                    NSLog(@"error finding asset %@", [error debugDescription]);
                }];
    }
    
//    if (self.pictureArray == nil) {
//        self.pictureArray = [[NSMutableArray alloc]init];
//    }
//    PhotoB.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [_dynamicTV becomeFirstResponder];
//    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
//    imageV.userInteractionEnabled = YES;
//    imageV.image = selectImage;
//    [self.view addSubview:imageV];
//    if (PhotoB.frame.origin.x < 250) {
//        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
//    }else{
//        PhotoB.frame = CGRectMake(13, 250.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
//    }
//    [_pictureArray addObject:imageV];
//    if (_pictureArray.count == 8) {
//        PhotoB.hidden = YES;
//    }
//    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
//    [imageV addGestureRecognizer:tapGR];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [_dynamicTV becomeFirstResponder];
}
#pragma mark -
#pragma mark fastTextViewDelegate

- (BOOL)fastTextViewShouldBeginEditing:(FastTextView *)textView {
    [emojiBtn setEnabled:YES];
    [imageB setEnabled:YES];
    return YES;
}

- (BOOL)fastTextViewShouldEndEditing:(FastTextView *)textView {
    return YES;
}

- (void)fastTextViewDidBeginEditing:(FastTextView *)textView {


}

- (void)fastTextViewDidEndEditing:(FastTextView *)textView {
}

- (void)fastTextViewDidChange:(FastTextView *)textView {
    UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
    if (!selectedTextRange) {
        UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
        selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
    }
    UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
    
    startPosition=[_dynamicTV positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
    UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
    selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
    
}

- (void)fastTextView:(FastTextView*)textView didSelectURL:(NSURL *)URL {
    
}



- (void)attachSlide:(id)sender;
{
    //    [self _logScrollInfo:@"fsfsdfsd"];
    //    NSLog(@"editor frame %@",NSStringFromCGRect(_editor.frame));
    //    return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    //    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
    //    [picker release];
    //
    //       [[OUIAppController controller] presentPopover:popover fromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //[picker release];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)_addAttachmentFromAsset:(UIImage *)img;
{
//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    NSMutableData *data = [NSMutableData dataWithLength:[rep size]];
//    
//    
//    
//    NSError *error = nil;
//    if ([rep getBytes:[data mutableBytes] fromOffset:0 length:[rep size] error:&error] == 0) {
//        NSLog(@"error getting asset data %@", [error debugDescription]);
//    } else {
        //        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        //        wrapper.filename = [[rep url] lastPathComponent];
        
        NSString *newfilename=[NSAttributedString scanAttachmentsForNewFileName:_dynamicTV.attributedString];
        
        NSString *path = [RootDocPath stringByAppendingPathComponent:@"UploadTopicPics"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:path] == NO)
        {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }

        
//        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString * _documentDirectory = [[NSString alloc] initWithString:[_paths objectAtIndex:0]];
        
        
        UIImage *thumbimg=[img imageByScalingProportionallyToSize:CGSizeMake(640,1136)];
        
        NSString *pngPath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",newfilename]];
        
        //[[AppDelegate documentDirectory] stringByAppendingPathComponent:@"tmp.jpg"];
        
        
        [UIImageJPEGRepresentation(thumbimg,0.7)writeToFile:pngPath atomically:YES];
        
        UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
        if (!selectedTextRange) {
            UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
            selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
        }
        UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
        
        unichar attachmentCharacter = FastTextAttachmentCharacter;
        [_dynamicTV replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"\n%@\n",[NSString stringWithCharacters:&attachmentCharacter length:1]]];
        
        startPosition=[_dynamicTV positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
        UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
        selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
        
        
        NSMutableAttributedString *mutableAttributedString=[_dynamicTV.attributedString mutableCopy];
        
        NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
        NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
        
        if (en < st) {
            return;
        }
        
        //        [stringToPublish insertString:@"</p><img src=\"565656\">" atIndex:st];
        
        NSUInteger contentLength = [[_dynamicTV.attributedString string] length];
        if (en > contentLength) {
            en = contentLength; // but let's not crash
        }
        if (st > en)
            st = en;
        NSRange cr = [[_dynamicTV.attributedString string] rangeOfComposedCharacterSequencesForRange:(NSRange){ st, en - st }];
        if (cr.location + cr.length > contentLength) {
            cr.length = ( contentLength - cr.location ); // but let's not crash
        }
        
        if(isAddSlide){
            
            FileWrapperObject *fileWp = [[FileWrapperObject alloc] init];
            [fileWp setFileName:newfilename];
            [fileWp setFilePath:pngPath];
            
            SlideAttachmentCell *cell = [[SlideAttachmentCell alloc] initWithFileWrapperObject:fileWp] ;
            //ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] init];
            cell.isNeedThumb=TRUE;
            cell.thumbImageWidth=200.0f;
            cell.thumbImageHeight=200.0f;
//            cell.txtdesc=@"幻灯片测试";
            
            [mutableAttributedString addAttribute: FastTextAttachmentAttributeName value:cell  range:cr];
            
            //[mutableAttributedString addAttribute:fastTextAttachmentAttributeName value:cell  range:selectedTextRange];
            
            
        }else{
            //            ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] initWithFileWrapper:wrapper] ;
            //            //ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] init];
            //            cell.isNeedThumb=TRUE;
            //            cell.thumbImageWidth=200.0f;
            //            cell.thumbImageHeight=200.0f;
            //
            //            [mutableAttributedString addAttribute: fastTextAttachmentAttributeName value:cell  range:cr];
        }
        
        
        
        [tagPositionArray addObject:[NSNumber numberWithInteger:st]];
        [tagArray addObject:@"</p><img src=\"big pic\"><p>"];
        if (mutableAttributedString) {
            _dynamicTV.attributedString = mutableAttributedString;
        }
        [self performSelector:@selector(scrollToBottomw) withObject:nil afterDelay:0.3];
        //[_editor setValue:attachment forAttribute:OAAttachmentAttributeName inRange:selectedTextRange];
        
        
//    }
}
- (void)keyboardWillShow:(NSNotification *)notification {
    ifEmoji = NO;
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}

-(void)autoMovekeyBoard:(float)h
{
    [UIView animateWithDuration:0.2 animations:^{
        [tool setFrame:CGRectMake(0, self.view.frame.size.height-h-tool.frame.size.height, 320, 44)];
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [tool setFrame:CGRectMake(0, self.view.frame.size.height-227, 320, 44)];
    } completion:^(BOOL finished) {
        
    }];

    
    
}

-(void)scrollToBottomw
{
    CGPoint bottomOffset = CGPointMake(0, _dynamicTV.contentSize.height - _dynamicTV.bounds.size.height);
    [_dynamicTV setContentOffset:bottomOffset animated:YES];
}
#pragma mark - UIPicker View delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.CircleTree.count;
    }
    return self.circleArray.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (component == 0) {
        return ((CircleClassify*)self.CircleTree[row]).name;
    }
    return ((CircleEntity*)self.circleArray[row]).name;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.circleArray = ((CircleClassify*)self.CircleTree[row]).circleArray;
        [pickerView reloadComponent:1];
    }
    if (self.circleArray.count > 0) {
        self.indexPath = [NSIndexPath indexPathForRow:[_circlePV  selectedRowInComponent:1] inSection:[_circlePV  selectedRowInComponent:0]];
        self.forumId = ((CircleEntity*)((CircleClassify*)self.CircleTree[self.indexPath.section]).circleArray[self.indexPath.row]).circleID;
        self.forumName =((CircleEntity*)((CircleClassify*)self.CircleTree[self.indexPath.section]).circleArray[self.indexPath.row]).name;
        CGSize size = [_forumName sizeWithFont:[UIFont systemFontOfSize:18]];
        titleLabel.frame = CGRectMake((320-size.width-15)/2, (44-size.height)/2+diffH, size.width, size.height);
        xialaIV.frame = CGRectMake(titleLabel.frame.origin.x+size.width, 0+diffH, 15, 44);
        xialaB.frame = CGRectMake(titleLabel.frame.origin.x, diffH, size.width+15, 44);
        [titleLabel setText:_forumName];
    }
}
@end
