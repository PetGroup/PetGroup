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
#import "XMPPHelper.h"
#import "KGStatusBar.h"
#import "PersonDetailViewController.h"
@interface ShowPetMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    BOOL isSelf;
}
@property (nonatomic,retain)UITableView * tableV;
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
    
    if (isSelf) {
        UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        nextB.frame = CGRectMake(240, 0+diffH, 80, 44);
        [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
        [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [nextB setTitle:@"更多" forState:UIControlStateNormal];
        [nextB addTarget:self action:@selector(showActtionSheet) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextB];
    }
    
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(96, 140, 127, 127)];
    imageV.image = [UIImage imageNamed:@"QRCodeError"];
    [self.view addSubview:imageV];
    UILabel* aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280, 320, 20)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor orangeColor];
    aLabel.text = @"糟糕!";
    aLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:aLabel];
    UILabel*bLabel =[[UILabel alloc]initWithFrame:CGRectMake(45, 300, 230, 50)];
    bLabel.numberOfLines = 2;
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = [UIColor orangeColor];
    bLabel.text = @"该防丢失二维码挂件尚未被绑定,你可以发布招领帖,寻找宠物主人";
    bLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bLabel];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + diffH, 320, self.view.frame.size.height - 44 - diffH) style:UITableViewStyleGrouped];
    UIView * headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    _tableV.tableHeaderView = headV;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    if (!_RQCodeMessage[@"petOwner"]) {
        _tableV.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showActtionSheet
{
    UIActionSheet* action = [[UIActionSheet alloc]initWithTitle:@"解绑防丢失二维码后,需要重新绑定激活才能恢复" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:nil];
    [action showInView:self.view];
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
        cell.describeLabel.text = [NSString stringWithFormat:@"%d",[_RQCodeMessage[@"num"] intValue]];
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
    if (indexPath.section == 2 && indexPath.row == 2) {
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
            addpetVC.delegate = self.delegate;
            addpetVC.RQCodeMessage = self.RQCodeMessage;
            [self.navigationController popToViewController:self animated:NO];
            [self.navigationController pushViewController:addpetVC animated:YES];
        }
    }else
    {
        if (indexPath.section ==2) {
            if (indexPath.row == 0) {
                PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
                personDVC.hostInfo = [[HostInfo alloc]init];
                personDVC.hostInfo.userId = self.RQCodeMessage[@"userId"];
                personDVC.hostInfo.nickName =self.RQCodeMessage[@"petOwner"];
                personDVC.needRequest = YES;
                personDVC.needRequestPet = YES;
                [self.navigationController pushViewController:personDVC animated:YES];
            }
            if (indexPath.row == 1) {
                self.callMeAlertV = [[UIAlertView alloc]initWithTitle:nil message:@"给我打电话?" delegate:self cancelButtonTitle:@"才不呢" otherButtonTitles:@"对呀对呀", nil];
                [_callMeAlertV show];
            }
        }
    }
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView == _callMeAlertV) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_RQCodeMessage[@"petOwnerTel"]]]];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:_RQCodeMessage[@"id"] forKey:@"id"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"unboundPetCard" forKey:@"method"];
        [body setObject:@"service.uri.pet_user" forKey:@"service"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [hud hide:YES];
            if (self.delegate&&[_delegate respondsToSelector:@selector(finishDelRQCodeMessageWithPet:)]) {
                [self.delegate finishDelRQCodeMessageWithPet:_RQCodeMessage];
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败，请重发" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
//            [hud hide:YES];
        }];
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
