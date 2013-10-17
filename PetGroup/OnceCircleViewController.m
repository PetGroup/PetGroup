//
//  OnceCircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OnceCircleViewController.h"
#import "TempData.h"
#import "articleCell.h"
#import "EGOImageView.h"
@interface OnceCircleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton* joinB;
}
@property (nonatomic,retain)UITableView* tableV;
@end

@implementation OnceCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"北京同城圈"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    
    UILabel* lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 99, 320, 1)];
    lineL.backgroundColor = [UIColor grayColor];
    lineL.alpha = 0.3;
    [headView addSubview:lineL];
    
    EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
    imageV.imageURL = [NSURL URLWithString:@""];
    [headView addSubview:imageV];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 20)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont boldSystemFontOfSize:18];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.text = @"北京同城圈";
    [headView addSubview:nameL];
    
    UILabel * huatiL = [[UILabel alloc]initWithFrame:CGRectMake(200, 30, 60, 10)];
    huatiL.backgroundColor = [UIColor clearColor];
    huatiL.font = [UIFont systemFontOfSize:10];
    huatiL.textColor = [UIColor grayColor];
    huatiL.text = @"话题:24242";
    [headView addSubview:huatiL];
    
    UILabel * replyL = [[UILabel alloc]initWithFrame:CGRectMake(260, 30, 60, 10)];
    replyL.backgroundColor = [UIColor clearColor];
    replyL.font = [UIFont systemFontOfSize:10];
    replyL.textColor = [UIColor grayColor];
    replyL.text = @"回复:122";
    [headView addSubview:replyL];
    
    UIImageView* personIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ren"]];
    personIV.frame = CGRectMake(100, 65, 13.5, 8.5);
    [headView addSubview:personIV];
    UILabel* personL = [[UILabel alloc]initWithFrame:CGRectMake(113.5, 65, 100, 10)];
    personL.backgroundColor = [UIColor clearColor];
    personL.font = [UIFont systemFontOfSize:10];
    personL.textColor = [UIColor grayColor];
    personL.text = @"15544人";
    [headView addSubview:personL];
    
    joinB = [UIButton buttonWithType:UIButtonTypeCustom];
    joinB.frame = CGRectMake(240, 60, 71, 20);
    [joinB setBackgroundImage:[UIImage imageNamed:@"jiaru"] forState:UIControlStateNormal];
    [joinB addTarget:self action:@selector(joinOnceCircle) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:joinB];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.rowHeight = 100;
    _tableV.tableHeaderView = headView;
    [self.view addSubview:_tableV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateSelfMassage
{
    
}
-(void)joinOnceCircle
{
    [joinB setBackgroundImage:[UIImage imageNamed:@"yijiaru"] forState:UIControlStateNormal];
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    articleCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[articleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}
@end
