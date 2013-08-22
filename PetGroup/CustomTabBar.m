    //
//  CustomTabBarController.m
//  TestTabbar]
//
//  Created by zuo jianjun on 11-7-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"
//#import "MainView.h"

#define Background @"bottombgt.png"
#define TabbarHeight 49
static CustomTabBar *customTabBarController;

@implementation UIViewController (CustomTabBarControllerSupport)
- (CustomTabBar *)customTabBarController
{
    return customTabBarController;
}
@end
@implementation CustomTabBar
@synthesize buttons;
@synthesize slideView;
@synthesize currentSelectedIndex;


-(id)initWithImages:(NSArray *)normalArray AndSelected:(NSArray *)selectedArray AndControllers:(NSArray *)controllers
{
    self = [super init];
	if (self != nil)
	{
        customTabBarController = self;
        self.view.backgroundColor = [UIColor whiteColor];
        theNormalArray = [[NSArray alloc]initWithArray:normalArray];
        theSelectedArray = [[NSArray alloc]initWithArray:selectedArray];
        theControllerArray = [[NSArray alloc]initWithArray:controllers];
        [self setViewControllers:controllers];
        
     //   self.selectedIndex = 0;
        [self hidesTabBar];
        [self customTabBar];
        
        
    }
    return  self;
}

//隐藏TabBar所在的视图
-(void) hidesTabBar
{  // self.hidesBottomBarWhenPushed = YES;
    NSLog(@"ssddffff:%d",self.view.subviews.count);
	for (UIView * view in self.view.subviews)//便利self.view上的子视图 
	{
		if ([view isKindOfClass:[UITabBar class]] )//判断self.view上的子视图是否是tabbar所在的视图，若是则隐藏tabbar所在的视图
		{
			//view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+TabbarHeight, view.frame.size.width, view.frame.size.height);
            view.hidden = YES;
			//break;
		}
	}

}
-(void)hideAll
{
    [tabBarBackgroundView setFrame:CGRectMake(tabBarBackgroundView.frame.origin.x, tabBarBackgroundView.frame.origin.y+TabbarHeight, tabBarBackgroundView.frame.size.width, tabBarBackgroundView.frame.size.height)];
}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
  //  [self hidesTabBar];
	if (yesOrNO == YES)
	{
		if (tabBarBackgroundView.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else
	{
		if (tabBarBackgroundView.frame.origin.y == self.view.frame.size.height - TabbarHeight)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			tabBarBackgroundView.frame = CGRectMake(tabBarBackgroundView.frame.origin.x, tabBarBackgroundView.frame.origin.y + TabbarHeight, tabBarBackgroundView.frame.size.width, tabBarBackgroundView.frame.size.height);
         
		}
		else
		{
			tabBarBackgroundView.frame = CGRectMake(tabBarBackgroundView.frame.origin.x, tabBarBackgroundView.frame.origin.y - TabbarHeight, tabBarBackgroundView.frame.size.width, tabBarBackgroundView.frame.size.height);
           
		}
		[UIView commitAnimations];
	}
	else
	{
		if (yesOrNO == YES)
		{
			tabBarBackgroundView.frame = CGRectMake(tabBarBackgroundView.frame.origin.x, tabBarBackgroundView.frame.origin.y + TabbarHeight, tabBarBackgroundView.frame.size.width, tabBarBackgroundView.frame.size.height);
		}
		else
		{
			tabBarBackgroundView.frame = CGRectMake(tabBarBackgroundView.frame.origin.x, tabBarBackgroundView.frame.origin.y - TabbarHeight, tabBarBackgroundView.frame.size.width, tabBarBackgroundView.frame.size.height);
		}
	}
}
-(void) customTabBar
{
	///向TabBar添加背景色或者图片
	tabBarBackgroundView = [[UIView alloc] 
									 initWithFrame:
									 self.tabBar.frame];
	UIColor * color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:Background]];
	[tabBarBackgroundView setBackgroundColor:color];
   // NSLog(@"sssssss:%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
	[color release];
	//将tabBarBackGroundView加载到self.view上去
	//[self.view insertSubview:tabBarBackgroundView atIndex:1];
	[self.view addSubview:tabBarBackgroundView];
    
    tabTitle = [[NSDictionary alloc] initWithObjectsAndKeys:@"消息",@"1",@"动态",@"2",@"附近",@"3",@"联系人",@"4",@"我",@"5", nil];
	//将滚动视图加载到tabBarBackGroundView上去

	//创建button
	int viewCount = self.viewControllers.count > 6 ? 6:self.viewControllers.count;
	//button的数量
 //   NSLog(@"%d",viewCount);
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];

	//button的宽
	double width = 320/viewCount;
	//button的高
	double height = self.tabBar.frame.size.height;
	//遍历viewController的视图  并加载button
	for (int i = 0; i<viewCount; i++) 
	{
		//UIViewController * viewController = [self.viewControllers objectAtIndex:i];
		UIButton * button = [UIButton buttonWithType:
							 UIButtonTypeCustom];
		button.frame = CGRectMake(width*i, 0, width, height);
		[button addTarget:self action:@selector(selectedTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i+1;
		UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0,height-22, width, height-22)];
		[label setBackgroundColor:[UIColor clearColor]];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView2.tag=button.tag+100;
       // imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"normal_0%d.png",i+1+1]];
        imageView2.image = [UIImage imageNamed:[theNormalArray objectAtIndex:i]];
        [button addSubview:imageView2];
        [imageView2 release];

        [label setText:[tabTitle objectForKey:[NSString stringWithFormat:@"%d",i+1]]];

        label.tag=button.tag+200;
        label.textColor = [UIColor whiteColor];
		[label setFont:[UIFont systemFontOfSize:12.0]];//改变字体大小
		[label setTextAlignment:NSTextAlignmentCenter];//字体中间对齐
		[button addSubview:label];
		[label release];
//		[button setBackgroundImage:nil forState:UIControlStateNormal];
		[self.buttons addObject:button];
		[tabBarBackgroundView addSubview:button];
        [button release];
//        [tabBarBackgroundView addSubview:slideView];
	}
	//[tabBarBackgroundView release];
	[self selectedTabBarItem:[self.buttons objectAtIndex:self.selectedIndex]];
	
}
-(void) selectedTabBarItem:(UIButton *) button
{

    int i = button.tag;
//    float width = button.frame.size.width;
//    float height = button.frame.size.height;
    self.currentSelectedIndex = button.tag-1;
    
   // self.selectedIndex = button.tag-1;
   // [self performSelector:@selector(slideTabBarItem:) withObject:imagView];
	if (self.currentSelectedIndex ==i-1) { 
        UIImageView *imagev = (UIImageView *)[button viewWithTag:button.tag+100];
        imagev.image = [UIImage imageNamed:[theSelectedArray objectAtIndex:i-1]];
        for (int j = 0; j<[self.buttons count]; ++j) {
            UIButton * temp = (UIButton *)[self.buttons objectAtIndex:j];
            if (temp.tag!=button.tag) {
                UIImageView *imagev2 = (UIImageView *)[temp viewWithTag:temp.tag+100];
                imagev2.image = [UIImage imageNamed:[theNormalArray objectAtIndex:j]];
            }
            

        }
	}
    self.selectedIndex = self.currentSelectedIndex;
   // [self.view layoutSubviews];
}
-(void)setSelectedPage:(int)index
{
    [self selectedTabBarItem:[self.buttons objectAtIndex:index]];
}
//-(void) slideTabBarItem:(UIImageView *) button
//{
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationCurve:0.2];
//	[UIView setAnimationDelegate:self];
////	slideView.frame = button.frame;//将被点击按钮的frame赋值给tabBarView的frame，使滑动视图移到被点击的按钮上
//	[UIView commitAnimations];
//}

-(void)buttontag:(int)sender
{
    a = sender - 1;
}

-(void)notificationWithNumber:(BOOL)ifNumber AndTheNumber:(int)number OrDot:(BOOL)dot WithButtonIndex:(int)index
{
    UIButton * btn = [self.buttons objectAtIndex:index];
    for (UIView * view in btn.subviews) {
        if(view.tag==999)
            [view removeFromSuperview];
    }
    if (ifNumber) {
        UIImageView * notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(36, 0, 28, 22)];
        [notiBgV setImage:[UIImage imageNamed:@"redCB.png"]];
        notiBgV.tag=999;
        [btn addSubview:notiBgV];
        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 30, 22)];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextColor:[UIColor whiteColor]];
        [numberLabel setFont:[UIFont systemFontOfSize:14]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [notiBgV addSubview:numberLabel];
        [numberLabel setText:[NSString stringWithFormat:@"%d",number]];
    }
    else if (dot){
        UIImageView * dotLabel = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 15, 15)];
        dotLabel.tag = 999;
        [dotLabel setImage:[UIImage imageNamed:@"redpot.png"]];
        [btn addSubview:dotLabel];
    }
}

-(void)removeNotificatonOfIndex:(int)index
{
    UIButton * btn = [self.buttons objectAtIndex:index];
    for (UIView * view in btn.subviews) {
        if(view.tag==999)
            [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[slideView release];
	//[buttons release];
    [tabBarBackgroundView release];
    [theControllerArray release];
    [theSelectedArray release];
    [theNormalArray release];
    [super dealloc];
}


@end


