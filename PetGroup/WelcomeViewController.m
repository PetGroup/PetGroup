//
//  WelcomeViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "WelcomeViewController.h"
#import "NewLoginViewController.h"
#import "NewRegistOneViewController.h"

@interface WelcomeViewController ()
{
    UIScrollView *sc;
    CGFloat curXLoc;
    NSTimer* timer;
}
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden =YES;
    self.view.backgroundColor = [UIColor blackColor];
    diffH = [Common diffHeight:self];

    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
	//设置委托
    [self.view addSubview:sc];
	sc.delegate=self;
    //设置背景颜色
	sc.backgroundColor=[UIColor blackColor];
    [sc setContentSize:CGSizeMake(6*320, self.view.frame.size.height)];
//    sc.alpha = 0.96;
    for (int i=1; i<=5; i++) {
		//图片命名加拓展名
//		NSString *str=[NSString stringWithFormat:@"tupian%d",i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*(i-1), 0, 320, self.view.frame.size.height)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_bg_0%d",i]]];
//        [imgView setImage:[UIImage imageNamed:str]];
        imgView.tag=i;
		//将imgView添加到sc(scrollerView)上
	    [sc addSubview:imgView];
        UIImageView * picV = [[UIImageView alloc] initWithFrame:CGRectMake(37.5+320*(i-1), 60, 245, 205)];
        [picV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_pic_0%d",i]]];
        [sc addSubview:picV];
        UIImageView * textV = [[UIImageView alloc] initWithFrame:CGRectMake(23.5+320*(i-1), 295, 273, 59)];
        [textV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_text_0%d",i]]];
        [sc addSubview:textV];
	}
//    NSString *str=[NSString stringWithFormat:@"tupian%d",1];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*5, 0, 320, 460)];
//    [imgView setImage:[UIImage imageNamed:str]];
//    imgView.tag=6;
//    //将imgView添加到sc(scrollerView)上
//    [sc addSubview:imgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*5, 0, 320, self.view.frame.size.height)];
    [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_bg_0%d",1]]];
    //        [imgView setImage:[UIImage imageNamed:str]];
    imgView.tag=6;
    //将imgView添加到sc(scrollerView)上
    [sc addSubview:imgView];
    UIImageView * picV = [[UIImageView alloc] initWithFrame:CGRectMake(75+320*5, 60, 245, 205)];
    [picV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_pic_0%d",1]]];
    [sc addSubview:picV];
    UIImageView * textV = [[UIImageView alloc] initWithFrame:CGRectMake(47+320*5, 295, 273, 59)];
    [textV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start_text_0%d",1]]];
    [sc addSubview:textV];
    
//    [self layoutAllImages];
	//将sc添加到视图上
    sc.pagingEnabled=YES;
    //设置水平滚动隐藏
	sc.showsHorizontalScrollIndicator=NO;
	//设置竖直滚动隐藏
	sc.showsVerticalScrollIndicator=NO;
    sc.bounces = NO;
    
    
    UIButton *login1 = [UIButton buttonWithType:UIButtonTypeCustom];
    login1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [login1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login1 setBackgroundImage:[UIImage imageNamed:@"start_login"] forState:UIControlStateNormal];
//    [login1 setBackgroundImage:[UIImage imageNamed:@"denglu_click"] forState:UIControlStateHighlighted];
    [login1 setTitle:@"登录" forState:UIControlStateNormal];
    [login1 addTarget:self action:@selector(beginToEnjoy) forControlEvents:UIControlEventTouchUpInside];
    login1.frame = CGRectMake(40, self.view.frame.size.height-80, 106.5, 38.5);
    [self.view addSubview:login1];
    
    UIButton* Regist1 = [UIButton buttonWithType:UIButtonTypeCustom];
    Regist1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [Regist1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Regist1 setBackgroundImage:[UIImage imageNamed:@"start_reg"] forState:UIControlStateNormal];
//    [Regist1 setBackgroundImage:[UIImage imageNamed:@"zhuce_click"] forState:UIControlStateHighlighted];
    [Regist1 setTitle:@"注册" forState:UIControlStateNormal];
    [Regist1 addTarget:self action:@selector(registNewUser) forControlEvents:UIControlEventTouchUpInside];
    Regist1.frame = CGRectMake(170, self.view.frame.size.height-80, 106.5, 38.5);
    [self.view addSubview:Regist1];
    
    m_Emojipc=[[UIPageControl alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-110, 280, 20)];
	//设置背景颜色
	m_Emojipc.backgroundColor=[UIColor clearColor];
	//设置pc页数（此时不会同步跟随显示）
	m_Emojipc.numberOfPages=5;
	//设置当前页,为第一张，索引为零
	m_Emojipc.currentPage=0;
	//添加事件处理，btn点击
	[m_Emojipc addTarget:self action:@selector(pagePressed:) forControlEvents:UIControlEventTouchUpInside];
	//将pc添加到视图上
	[self.view addSubview:m_Emojipc];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (timer != nil) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerDown:) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)timerDown:(NSTimer*)aTimer
{
    if (sc.contentOffset.x > 960) {
        sc.contentOffset = CGPointMake(0, 0);
        float a=sc.contentOffset.x;
        int page=floor((a-320/2)/320)+1;
        m_Emojipc.currentPage=page;
        return;
    }
    sc.contentOffset = CGPointMake(sc.contentOffset.x + 320, 0);
    float a=sc.contentOffset.x;
	int page=floor((a-320/2)/320)+1;
	m_Emojipc.currentPage=page;
}
-(void)layoutAllImages
{
	UIImageView *view=nil;
    NSArray *subviews=[sc subviews];
    curXLoc=0;
    for (view in subviews) {
        if ([view isKindOfClass:[UIImageView class]]&& view.tag>0) {
            CGRect frame=view.frame;
            frame.origin=CGPointMake(curXLoc, 0);
            view.frame=frame;
            curXLoc +=(320.0);
        }
    }
	//设置sc内容大小
	[sc setContentSize:CGSizeMake(6*320, self.view.frame.size.height)];
}
#pragma mark - scrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (sc.contentOffset.x > 1280) {
        sc.contentOffset = CGPointMake(0, 0);
        return;
    }
    if (timer != nil) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerDown:) userInfo:nil repeats:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float a=sc.contentOffset.x;
	int page=floor((a-320/2)/320)+1;
	m_Emojipc.currentPage=page;
}
#pragma mark - button action
-(void)registNewUser
{
    [timer invalidate];
    NewRegistOneViewController* newRegVC = [[NewRegistOneViewController alloc]init];
    [self.navigationController pushViewController:newRegVC animated:YES];
}
-(void)beginToEnjoy
{
    [timer invalidate];
    NewLoginViewController* reg = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
}
@end
