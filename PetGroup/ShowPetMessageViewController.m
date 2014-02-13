//
//  ShowPetMessageViewController.m
//  PetGroup
//
//  Created by wangxr on 14-2-13.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//
#import "TempData.h"
#import "AppDelegate.h"
#import "PetProfileCell.h"
#import "ShowPetMessageViewController.h"
#import "AddPetMessageViewController.h"

@interface ShowPetMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL isSelf;
}
@property (nonatomic,retain)UITableView * tableV;
@property (nonatomic,retain)UIAlertView* addMeAlertV;
@property (nonatomic,retain)UIAlertView* callMeAlertV;
@property (nonatomic,assign)AppDelegate* appDel;
@end

@implementation ShowPetMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appDel = [UIApplication sharedApplication].delegate;
        isSelf = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_RQCodeMessage[@"username"] isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
        isSelf = YES;
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    
    float diffH = [Common diffHeight:self];
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
    titleLabel.text = @"二维码信息";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + diffH, 320, self.view.frame.size.height - 44 - diffH) style:UITableViewStyleGrouped];
    UIView * headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    _tableV.tableHeaderView = headV;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else if(section == 3){
        if (isSelf) {
            return 1;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        static NSString *yescellIdentifier = @"YESCell";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:yescellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:yescellIdentifier];
            cell.contentView.backgroundColor = [UIColor orangeColor];
            UILabel* titleL = [[UILabel alloc]initWithFrame:cell.contentView.frame];
            [cell.contentView addSubview:titleL];
            titleL.text = @"编辑";
            titleL.backgroundColor = [UIColor clearColor];
            titleL.textColor = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellIdentifier = @"Cell";
    PetProfileCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PetProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrow.hidden = YES;
    }
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"挂件编号:";
        cell.describeLabel.text = _RQCodeMessage[@"petType"];
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"爱宠品种:";
                cell.describeLabel.text = _RQCodeMessage[@"petType"];
            }break;
            case 1:{
                cell.titleLabel.text = @"爱宠昵称:";
                cell.describeLabel.text = _RQCodeMessage[@"petNickname"];
            }break;
            default:
                break;
        }
    }else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"主人名称:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwner"];
                if (!isSelf) {
                    cell.describeLabel.textColor = [UIColor blueColor];
                }
            }break;
            case 1:{
                cell.titleLabel.text = @"主人电话:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwnerTel"];
                if (!isSelf) {
                    cell.describeLabel.textColor = [UIColor blueColor];
                }
            }break;
            case 2:{
                cell.titleLabel.text = @"主人寄语:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwnerMsg"];
                cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [_RQCodeMessage[@"petOwnerMsg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height);
            }break;
            default:
                break;
        }
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        float a =[_RQCodeMessage[@"petOwnerMsg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height;
        if (a > 20) {
            a += 30;
            return a;
        }
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isSelf) {
        if (indexPath.section == 3) {
            AddPetMessageViewController*addpetVC = [[AddPetMessageViewController alloc]init];
            addpetVC.delegate = self.navigationController.viewControllers[1];
            addpetVC.RQCodeMessage = self.RQCodeMessage;
            addpetVC.edit = YES;
            [self.navigationController popToViewController:self animated:NO];
            [self.navigationController pushViewController:addpetVC animated:YES];
        }
    }else
    {
        if (indexPath.section ==1) {
            if (indexPath.row == 0) {
                self.addMeAlertV = [[UIAlertView alloc]initWithTitle:nil message:@"加我为好友?" delegate:self cancelButtonTitle:@"才不呢" otherButtonTitles:@"对呀对呀", nil];
                [_addMeAlertV show];
            }
            if (indexPath.row == 1) {
                self.callMeAlertV = [[UIAlertView alloc]initWithTitle:nil message:@"给我打电话?" delegate:self cancelButtonTitle:@"才不呢" otherButtonTitles:@"对呀对呀", nil];
                [_callMeAlertV show];
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
