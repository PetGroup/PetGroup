//
//  SelectorPetViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "SelectorPetViewController.h"

@interface SelectorPetViewController ()
{
    UIButton* dogB;
    UIButton* catB;
    UIButton* otherB;
    UIButton* noneB;
}
@property (nonatomic ,assign) PetTypeStyle petType;
@end

@implementation SelectorPetViewController

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
    
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    if (diffH==0) {
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    }
    
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"选择爱宠"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel* a = [[UILabel alloc]initWithFrame:CGRectMake(0, 80+diffH, 320, 20)];
    a.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    a.textAlignment = NSTextAlignmentCenter;
    a.backgroundColor = [UIColor clearColor];
    a.textColor = [UIColor blackColor];
    a.text = @"请选择您的爱宠类型";
    [self.view addSubview:a];
    
//    UIImageView * yuanIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 125+diffH, 280, 280)];
//    yuanIV.image = [UIImage imageNamed:@"xuanzechongwu-bg"];
//    yuanIV.userInteractionEnabled = YES;
//    [self.view addSubview:yuanIV];
    
    dogB = [UIButton buttonWithType:UIButtonTypeCustom];
    [dogB addTarget:self action:@selector(selectDog) forControlEvents:UIControlEventTouchUpInside];
    [dogB setBackgroundImage:[UIImage imageNamed:@"gougou"] forState:UIControlStateNormal];
    dogB.frame = CGRectMake(40, 140+diffH, 120, 120);
    [self.view addSubview:dogB];
    
    catB = [UIButton buttonWithType:UIButtonTypeCustom];
    [catB addTarget:self action:@selector(selectCat) forControlEvents:UIControlEventTouchUpInside];
    [catB setBackgroundImage:[UIImage imageNamed:@"maomi"] forState:UIControlStateNormal];
    catB.frame = CGRectMake(160, 140+diffH, 120, 120);
    [self.view addSubview:catB];
    
    otherB = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherB addTarget:self action:@selector(selectOther) forControlEvents:UIControlEventTouchUpInside];
    [otherB setBackgroundImage:[UIImage imageNamed:@"qita"] forState:UIControlStateNormal];
    otherB.frame = CGRectMake(40, 260+diffH, 120, 120);
    [self.view addSubview:otherB];
    
    noneB = [UIButton buttonWithType:UIButtonTypeCustom];
    [noneB addTarget:self action:@selector(selectNone) forControlEvents:UIControlEventTouchUpInside];
    [noneB setBackgroundImage:[UIImage imageNamed:@"weiyang"] forState:UIControlStateNormal];
    noneB.frame = CGRectMake(160, 260+diffH, 120, 120);
    [self.view addSubview:noneB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)next
{
    if (self.petType>0&&self.petType<4) {
        AddPetViewController* addPetVC = [[AddPetViewController alloc]init];
        addPetVC.petType = self.petType;
        addPetVC.hostDic = self.dic;
        [self.navigationController pushViewController:addPetVC animated:YES];
    }else if(self.petType==4){
        UpLoadPhotoViewController* upLoadVC = [[UpLoadPhotoViewController alloc]init];
        upLoadVC.petType = self.petType;
        upLoadVC.hostDic = self.dic;
        [self.navigationController pushViewController:upLoadVC animated:YES];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择宠物类型" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
}
-(void)selectDog
{
    self.petType = PetTypeStyleDog;
    [dogB setBackgroundImage:[UIImage imageNamed:@"gougou_click"] forState:UIControlStateNormal];
    [catB setBackgroundImage:[UIImage imageNamed:@"maomi"] forState:UIControlStateNormal];
    [otherB setBackgroundImage:[UIImage imageNamed:@"qita"] forState:UIControlStateNormal];
    [noneB setBackgroundImage:[UIImage imageNamed:@"weiyang"] forState:UIControlStateNormal];
    
}
-(void)selectCat
{
    self.petType = PetTypeStyleCat;
    [dogB setBackgroundImage:[UIImage imageNamed:@"gougou"] forState:UIControlStateNormal];
    [catB setBackgroundImage:[UIImage imageNamed:@"maomi_click"] forState:UIControlStateNormal];
    [otherB setBackgroundImage:[UIImage imageNamed:@"qita"] forState:UIControlStateNormal];
    [noneB setBackgroundImage:[UIImage imageNamed:@"weiyang"] forState:UIControlStateNormal];
}
-(void)selectOther
{
    self.petType = PetTypeStyleOther;
    [dogB setBackgroundImage:[UIImage imageNamed:@"gougou"] forState:UIControlStateNormal];
    [catB setBackgroundImage:[UIImage imageNamed:@"maomi"] forState:UIControlStateNormal];
    [otherB setBackgroundImage:[UIImage imageNamed:@"qita_click"] forState:UIControlStateNormal];
    [noneB setBackgroundImage:[UIImage imageNamed:@"weiyang"] forState:UIControlStateNormal];
}
-(void)selectNone
{
    self.petType = PetTypeStyleNone;
    [dogB setBackgroundImage:[UIImage imageNamed:@"gougou"] forState:UIControlStateNormal];
    [catB setBackgroundImage:[UIImage imageNamed:@"maomi"] forState:UIControlStateNormal];
    [otherB setBackgroundImage:[UIImage imageNamed:@"qita"] forState:UIControlStateNormal];
    [noneB setBackgroundImage:[UIImage imageNamed:@"weiyang_click"] forState:UIControlStateNormal];
}
@end
