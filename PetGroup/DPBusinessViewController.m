//
//  DPBusinessViewController.m
//  PetGroup
//
//  Created by wangxr on 13-11-29.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DPBusinessViewController.h"
#import "WebViewViewController.h"
#import "TempData.h"
#import "DPNetManager.h"
#import "EGOImageView.h"
#import "DPReplyCell.h"
@interface DPBusinessViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,DPNetManagerDelegate>
{
    float diffH;
}
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
        self.dataSourceArray = [NSMutableArray array];
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
    diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"商户详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
//    UIImageView* headV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    headV.image = [UIImage imageNamed:@"dianpingziyuan"];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStyleGrouped];
//    _tableV.tableFooterView = headV;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundView = nil;
    
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
-(void)callPhoneNo
{
    UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:@"确认要拨打电话至该商户?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确认", nil];
    [alertV show];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        if (![self.business.telephone isEqualToString:@""]) {
            return 3;
        }
        return 2;
    }
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                static NSString *headCellIdentifier = @"headCell";
                UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:headCellIdentifier ];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headCellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    EGOImageView*businessImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"dianping.png"]];
                    businessImageView.frame = CGRectMake(10, 10, 118.828 , 85.488);
                    [cell.contentView addSubview:businessImageView];
                    UILabel*nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(138, 10, 170 , 20)];
                    nameLabel.font=[UIFont boldSystemFontOfSize:16.0];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:nameLabel];
                    UIImageView*starImage = [[UIImageView alloc]initWithFrame:CGRectMake(138, 40, 84,16)];
                    [cell.contentView addSubview:starImage];
                    businessImageView.imageURL = self.business.sPhotoURL;
                    nameLabel.text = self.business.name;
                    if (self.business.avgRating==0) {
                        starImage.image = [UIImage imageNamed:@"star_16_0.png"];
                    }else if (self.business.avgRating==1) {
                        starImage.image = [UIImage imageNamed:@"star_16_1.png"];
                        
                    }else if (self.business.avgRating==2) {
                        starImage.image = [UIImage imageNamed:@"star_16_2.png"];
                        
                    }else if (self.business.avgRating==3) {
                        starImage.image = [UIImage imageNamed:@"star_16_3.png"];
                        
                    }else if (self.business.avgRating==3.5) {
                        starImage.image = [UIImage imageNamed:@"star_16_35.png"];
                        
                    }else if (self.business.avgRating==4) {
                        starImage.image = [UIImage imageNamed:@"star_16_4.png"];
                        
                    }else if (self.business.avgRating==4.5) {
                        starImage.image = [UIImage imageNamed:@"star_16_45.png"];
                        
                    }else {
                        starImage.image = [UIImage imageNamed:@"star_16_5.png"];
                    }
                }
                return cell;
            }break;
            case 1:{
                static NSString *addressCellIdentifier = @"addressCell";
                UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier ];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addressCellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    cell.textLabel.text = self.business.adress;
                }
                return cell;
            }break;
            case 2:{
                static NSString *phoneCellIdentifier = @"phoneCell";
                UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:phoneCellIdentifier ];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:phoneCellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    cell.textLabel.text = self.business.telephone;
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(270, 0, 1, 40)];
                    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                    [cell.contentView addSubview:line];
                    UIButton *telephoneB = [[UIButton alloc]initWithFrame:CGRectMake(270, 10, 50, 20)];
                    if (!diffH) {
                        line.frame = CGRectMake(250, 0, 1, 40);
                        telephoneB.frame = CGRectMake(250, 10, 50, 20);
                    }
                    [cell.contentView addSubview:telephoneB];
                    [telephoneB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [telephoneB setTitle:@"拨打" forState:UIControlStateNormal];
                    [telephoneB addTarget:self action:@selector(callPhoneNo) forControlEvents:UIControlEventTouchUpInside];
                }
                return cell;
            }break;
            default:
                break;
        }
    }
    static NSString *cellIdentifier = @"cell";
    DPReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DPReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.reply = self.dataSourceArray[indexPath.row];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        WebViewViewController* web = [[WebViewViewController alloc]init];
        web.addressURL = [NSURL URLWithString:self.business.businessUrl];
        [self presentViewController:web animated:YES completion:^{
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                return 100;
            }break;
            case 1:{
                return 40 ;
            }break;
            case 2:{
                return 40;
            }break;
            default:
                break;
        }
    }
    return [DPReplyCell heightForRowWithDynamic:self.dataSourceArray[indexPath.row]];
}
#pragma mark - DPNetManager Delegate
-(void)DPNetManagerDidFinishLoading:(NSArray*)array
{
    if (array.count>0) {
        for (NSDictionary* dic in array) {
            DPReply* reply = [[DPReply alloc]initWithNSDictionary:dic];
            [_dataSourceArray addObject:reply];
        }
         [self.tableV reloadData];
    }
}
-(void)DPNetManagerdidFailWithError:(NSError *)error
{
    
}
#pragma mark - loadData
-(void)reloadData
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:self.business.businessID forKey:@"business_id"];
    NSString* url = [DPNetManager serializeURL:@"http://api.dianping.com/v1/review/get_recent_reviews" params:dic];
    NSLog(@"%@",url);
    self.netManager = [[DPNetManager alloc]initWithURL:url delegate:self];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.business.telephone]]];
    }
}
@end
