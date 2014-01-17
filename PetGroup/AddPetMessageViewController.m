//
//  AddPetMessageViewController.m
//  PetGroup
//
//  Created by wangxr on 14-1-16.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "AddPetMessageViewController.h"
#import "AppDelegate.h"
#import "TempData.h"
#import "PetProfileCell.h"
#import "ReportViewController.h"
#import "KGStatusBar.h"
#import "XMPPHelper.h"
@interface AddPetMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ChangeText,UIAlertViewDelegate>
{
    BOOL edit;
    float specialHigh;
}
@property (nonatomic,retain)UITableView * tableV;

@property (nonatomic,retain)UIAlertView* addMeAlertV;
@property (nonatomic,retain)UIAlertView* callMeAlertV;
@property (nonatomic,assign)AppDelegate* appDel;
@end

@implementation AddPetMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appDel = [UIApplication sharedApplication].delegate;
        edit = YES;
        specialHigh = 50;
    }
    return self;
}

- (void)viewDidLoad
{
    if (_RQCodeMessage) {
        float a =[_RQCodeMessage[@"petOwnerMsg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height;
        if (a > 20) {
            specialHigh = a +30;
        }
        if (![_RQCodeMessage[@"username"] isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
            edit = NO;
        }else
        {
            _RQCodeNo = _RQCodeMessage[@"id"];
        }
    }else
    {
        self.RQCodeMessage = [[NSMutableDictionary alloc]init];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    if (edit) {
        UILabel* tishiL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
        tishiL.text = @"请认真填写信息,以便爱宠丢失后与您联系";
        tishiL.font = [UIFont systemFontOfSize:16];
        tishiL.backgroundColor = [UIColor clearColor];
        [headV addSubview:tishiL];
        UILabel* numberL = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 20)];
        numberL.text = _RQCodeNo;
        numberL.backgroundColor = [UIColor clearColor];
        [headV addSubview:numberL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)finishEdit
{
    if (!_RQCodeMessage[@"petType"]) {
        
    }else if (!_RQCodeMessage[@"petNickname"]) {
        
    }else if (!_RQCodeMessage[@"petOwner"]) {
        
    }else if (!_RQCodeMessage[@"petOwnerTel"]) {
        
    }else if (!_RQCodeMessage[@"petOwnerMsg"]) {
        
    }else
    {
        [self setCardInfoByID:_RQCodeNo];
    }
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setCardInfoByID:(NSString *)theID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:theID forKey:@"id"];
    [params setObject:_RQCodeMessage[@"petType"] forKey:@"petType"];
    [params setObject:_RQCodeMessage[@"petNickname"] forKey:@"petNickname"];
    [params setObject:_RQCodeMessage[@"petOwner"] forKey:@"petOwner"];
    [params setObject:_RQCodeMessage[@"petOwnerTel"] forKey:@"petOwnerTel"];
    [params setObject:_RQCodeMessage[@"petOwnerMsg"] forKey:@"petOwnerMsg"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"setPetCard" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate&&[_delegate respondsToSelector:@selector(finishAddRQCodeMessageWithPet:)]) {
            [_RQCodeMessage setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
            [_delegate finishAddRQCodeMessageWithPet:_RQCodeMessage];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败，请重发" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 3;
    }else {
        if (edit) {
            return 1;
        }
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        static NSString *yescellIdentifier = @"YESCell";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:yescellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:yescellIdentifier];
            cell.contentView.backgroundColor = [UIColor orangeColor];
            UILabel* titleL = [[UILabel alloc]initWithFrame:cell.contentView.frame];
            [cell.contentView addSubview:titleL];
            titleL.text = @"保存修改";
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
        if (!edit) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.arrow.hidden = YES;
        }
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"宠物品种:";
                cell.describeLabel.text = _RQCodeMessage[@"petType"];
            }break;
            case 1:{
                cell.titleLabel.text = @"宠物昵称:";
                cell.describeLabel.text = _RQCodeMessage[@"petNickname"];
            }break;
            default:
                break;
        }
    }else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"主人名称:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwner"];
                if (!edit) {
                    cell.describeLabel.textColor = [UIColor blueColor];
                }
            }break;
            case 1:{
                cell.titleLabel.text = @"主人电话:";
                cell.describeLabel.text = _RQCodeMessage[@"petOwnerTel"];
                if (!edit) {
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
    return 3;
}
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return specialHigh;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (edit) {
        if (indexPath.section == 2) {
            [self finishEdit];
            return;
        }
        ReportViewController * reportV = [[ReportViewController alloc] init];
        reportV.textDelegate = self;
        reportV.maxCount = 16;
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    reportV.theTitle = @"宠物品种";
                    reportV.defaultContent = _RQCodeMessage[@"petType"];
                    reportV.thisIndex = indexPath.row;
                }break;
                case 1:{
                    reportV.theTitle = @"宠物昵称";
                    reportV.defaultContent = _RQCodeMessage[@"petNickname"];
                    reportV.thisIndex = indexPath.row;
                }break;
                default:
                    break;
            }
            [self.navigationController pushViewController:reportV animated:YES];
        }else if (indexPath.section == 1){
            switch (indexPath.row) {
                case 0:{
                    reportV.theTitle = @"主人名称";
                    reportV.defaultContent = _RQCodeMessage[@"petOwner"];
                    reportV.thisIndex = indexPath.row+10;
                }break;
                case 1:{
                    reportV.theTitle = @"主人电话";
                    reportV.defaultContent = _RQCodeMessage[@"petOwnerTel"];
                    reportV.thisIndex = indexPath.row+10;
                }break;
                case 2:{
                    reportV.theTitle = @"主人寄语";
                    reportV.defaultContent = _RQCodeMessage[@"petOwnerMsg"];
                    reportV.thisIndex = indexPath.row+10;
                    reportV.maxCount = 50;
                }break;
                default:
                    break;
            }
            [self.navigationController pushViewController:reportV animated:YES];
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
#pragma mark - ChangeText
-(void)changeText:(NSString *)textinfo WithIndex:(int)theIndex
{
    switch (theIndex) {
        case 0:{
            [_RQCodeMessage setObject:textinfo forKey:@"petType"];
        }break;
        case 1:{
            [_RQCodeMessage setObject:textinfo forKey:@"petNickname"];
        }break;
        case 10:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwner"];
        }break;
        case 11:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwnerTel"];
        }break;
        case 12:{
            [_RQCodeMessage setObject:textinfo forKey:@"petOwnerMsg"];
            float a =[textinfo sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping].height;
            if (a > 20) {
                specialHigh = a + 30;
            }
        }break;
            
        default:
            break;
    }
    [_tableV reloadData];
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView == _addMeAlertV)
        {
            if (![self.appDel.xmppHelper addFriend:_RQCodeMessage[@"username"]]) {
                [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
                return;
            }
            NSString *message = [NSString stringWithFormat:@"Hi~我是%@，加我为好友吧",[DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]];
            if (message.length > 0) {
                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                [body setStringValue:message];
                NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
                [mes addAttributeWithName:@"type" stringValue:@"chat"];
                [mes addAttributeWithName:@"msgtype" stringValue:@"sayHello"];
                [mes addAttributeWithName:@"msgTime" stringValue:[Common getCurrentTime]];
                [mes addAttributeWithName:@"fileType" stringValue:@"no"];
                [mes addAttributeWithName:@"to" stringValue:[_RQCodeMessage[@"petOwnerTel"] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
                [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
                [mes addChild:body];
                //        [self.appDel.xmppHelper.xmppStream sendElement:mes];
                if (![self.appDel.xmppHelper sendMessage:mes]) {
                    [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
                    //Do something when send failed...
                    return;
                }
                
                
            }
            [KGStatusBar showSuccessWithStatus:@"好友请求发送成功" Controller:self];
        }
        if (alertView == _callMeAlertV) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_RQCodeMessage[@"petOwnerTel"]]]];
        }
    }
}
@end
