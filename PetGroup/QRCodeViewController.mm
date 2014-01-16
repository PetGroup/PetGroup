//
//  QRCodeViewController.m
//  PetGroup
//
//  Created by Tolecen on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "QRCodeViewController.h"
#import <QRCodeReader.h>
#import "QRCustomViewController.h"
@interface QRCodeViewController ()<CustomViewControllerDelegate>

@end

@implementation QRCodeViewController

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    
    diffH = [Common diffHeight:self];

    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 2+diffH, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = @"二维码";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 setTitle:@"扫描器" forState:UIControlStateNormal];
//    [button1 setFrame:CGRectMake(10.f, 240.f, 140.f, 50.f)];
//    [button1 addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
    
    
    UIButton * addV = [UIButton buttonWithType:UIButtonTypeCustom];
    [addV setFrame:CGRectMake(20, 44+diffH+20, 120, 120)];
    [addV setBackgroundColor:[UIColor purpleColor]];
    [addV setTitle:@"添加" forState:UIControlStateNormal];
    [addV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addV.titleLabel setFont:[UIFont systemFontOfSize:22]];
    addV.layer.cornerRadius = 8;
    addV.layer.masksToBounds = YES;
    [self.view addSubview:addV];
    
    UIButton * scanV = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanV setFrame:CGRectMake(180, 44+diffH+20, 120, 120)];
    [scanV setBackgroundColor:[UIColor blueColor]];
    [scanV setTitle:@"扫描" forState:UIControlStateNormal];
    [scanV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanV.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [scanV addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
    scanV.layer.cornerRadius = 8;
    scanV.layer.masksToBounds = YES;
    [self.view addSubview:scanV];

    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,204+diffH, 320, self.view.frame.size.height-(204+diffH)) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Cell = @"profile";
    
    PetProfileCell *cell = (PetProfileCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil) {
        cell = [[PetProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.titleLabel.text = @"123";
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pressButton1:(UIButton*)button
{
    QRCustomViewController *vc = [[QRCustomViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}
#pragma mark - QRCustomViewControllerViewController
- (void)customViewController:(QRCustomViewController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",result);
    }];

}
- (void)customViewControllerDidCancel:(QRCustomViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
