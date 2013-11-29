//
//  DPBusinessViewController.m
//  PetGroup
//
//  Created by wangxr on 13-11-29.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DPBusinessViewController.h"
#import "TempData.h"
#import "DPNetManager.h"
@interface DPBusinessViewController ()<UITableViewDataSource,UITableViewDelegate,DPNetManagerDelegate>
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)NSMutableArray* dataSourceArray;
@property (nonatomic,retain)DPNetManager* netManager;
@end

@implementation DPBusinessViewController

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
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"商户详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    [self reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.netManager cancel];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                
            }break;
            case 1:{
                
            }break;
            case 2:{
                
            }break;
            default:
                break;
        }
    }else{
        
    }
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
//    cell.business = self.dataSourceArray[indexPath.row];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - DPNetManager Delegate
-(void)DPNetManagerDidFinishLoading:(NSArray*)array
{
    [self.tableV reloadData];
}
-(void)DPNetManagerdidFailWithError:(NSError *)error
{
    
}
#pragma mark - loadData
-(void)reloadData
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"7" forKey:@"sort"];
    [dic setObject:@"5000" forKey:@"radius"];
    [dic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [dic setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    [dic setObject:@"宠物" forKey:@"category"];
    [dic setObject:[NSString stringWithFormat:@"%d",2] forKey:@"platform"];
    NSString* url = [DPNetManager serializeURL:@"http://api.dianping.com/v1/business/find_businesses_by_coordinate" params:dic];
    NSLog(@"%@",url);
    self.netManager = [[DPNetManager alloc]initWithURL:url delegate:self];
    
}

@end
