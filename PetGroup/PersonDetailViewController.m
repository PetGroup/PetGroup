//
//  PersonDetailViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "CustomTabBar.h"
#import "JSON.h"
@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needRequest = NO;
        self.myFriend = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.hostInfo.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.appDel = [[UIApplication sharedApplication] delegate];
    
    NSString * gender = self.hostInfo.gender;
    NSString * age = self.hostInfo.age;
    NSString * region = @"北京市朝阳区";
    UIImage * genderImg = [gender isEqualToString:@"male"]?[UIImage imageNamed:@"manicon.png"]:[UIImage imageNamed:@"womenicon.png"];

    self.genderBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.genderBgV.backgroundColor = [UIColor clearColor];
    self.genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.genderIV setImage:genderImg];
    [self.genderIV setFrame:CGRectMake(13, 9, genderImg.size.width/2, genderImg.size.height/2)];
    [self.genderBgV addSubview:self.genderIV];
    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 80, 20)];
    [self.ageLabel setText:age];
    [self.ageLabel setBackgroundColor:[UIColor clearColor]];
    [self.genderBgV addSubview:self.ageLabel];
    self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(300-160, 5, 160, 20)];
    [self.regionLabel setTextAlignment:NSTextAlignmentRight];
    [self.regionLabel setText:region];
    [self.regionLabel setFont:[UIFont systemFontOfSize:14]];
    [self.regionLabel setBackgroundColor:[UIColor clearColor]];
    [self.genderBgV addSubview:self.regionLabel];
    
    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    self.photoWall.delegate = self;
    self.photoWall.tag =1;
    
    self.photoWall2 = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    [self.photoWall2 setPhotos:[self imageToURL:self.hostInfo.petsHeadArray]];
    self.photoWall2.delegate = self;
    self.photoWall2.tag = 2;
    
    self.hostInfo.signature = self.hostInfo.signature.length>1?self.hostInfo.signature:@"用户暂时还没有设置签名";
    self.hostInfo.hobby = self.hostInfo.hobby.length>1?self.hostInfo.hobby:@"用户暂时还没有设置签名";
    
    CGSize size1 = [self.hostInfo.signature sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height1 = [NSNumber numberWithFloat:size1.height];
    CGSize size2 = [self.hostInfo.hobby sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height2 = [NSNumber numberWithFloat:size2.height];
    self.heightArray = [NSArray arrayWithObjects:height1,height2, nil];

    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-58.5-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    
    UIImageView * bottomBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-58.5, 320, 58.5)];
    [bottomBG setImage:[UIImage imageNamed:@"bottomgray.png"]];
    [self.view addSubview:bottomBG];
    
    self.helloBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.helloBtn setFrame:CGRectMake(10, self.view.frame.size.height-10-40, 300, 40)];
    [self.helloBtn setBackgroundImage:[UIImage imageNamed:@"daanniu_click.png"] forState:UIControlStateNormal];
    [self.helloBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.helloBtn addTarget:self action:@selector(helloBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([DataStoreManager ifHaveThisFriend:self.hostInfo.userName]) {
        [self.helloBtn setTitle:@"发消息" forState:UIControlStateNormal];
        self.myFriend = YES;
    }
    else
    {
        [self.helloBtn setTitle:@"打招呼" forState:UIControlStateNormal];
        self.myFriend = NO;
    }
    
    [self.view addSubview:self.helloBtn];
    if (self.needRequest) {
        [self getUserInfoWithUserName:self.hostInfo.userName];
    }
	// Do any additional setup after loading the view.
}
-(void)reloadTheViews
{
    NSString * gender = self.hostInfo.gender;
    NSString * age = self.hostInfo.age;
    NSString * region = @"北京市朝阳区";
    UIImage * genderImg = [gender isEqualToString:@"male"]?[UIImage imageNamed:@"manicon.png"]:[UIImage imageNamed:@"womenicon.png"];
    [self.ageLabel setText:age];
    [self.genderIV setImage:genderImg];
    [self.genderIV setFrame:CGRectMake(13, 9, genderImg.size.width/2, genderImg.size.height/2)];
    [self.regionLabel setText:region];
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    [self.photoWall2 setPhotos:[self imageToURL:self.hostInfo.petsHeadArray]];
    self.hostInfo.signature = self.hostInfo.signature.length>1?self.hostInfo.signature:@"用户暂时还没有设置签名";
    self.hostInfo.hobby = self.hostInfo.hobby.length>1?self.hostInfo.hobby:@"用户暂时还没有设置签名";
    
    CGSize size1 = [self.hostInfo.signature sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height1 = [NSNumber numberWithFloat:size1.height];
    CGSize size2 = [self.hostInfo.hobby sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height2 = [NSNumber numberWithFloat:size2.height];
    self.heightArray = [NSArray arrayWithObjects:height1,height2, nil];
    [self.profileTableV reloadData];
}
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    if (imageArray) {
        if (imageArray.count<1) {
            [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,@""]];
        }
    }
    
    return temp;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1){
        return 30;
    }
    else
        return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return nil;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    else if (section==1){
        return self.genderBgV;
    }
    else if (section==2){
        return nil;
    }
    else return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return self.photoWall.frame.size.height;
    }
    else if (indexPath.section==1){
        return [[self.heightArray objectAtIndex:indexPath.row] floatValue]+20.0;
    }
    else if (indexPath.section==2){
        if (indexPath.row==1) {
            return self.photoWall2.frame.size.height;
        }
        else
            return 40;
    }
    else if (indexPath.section==3){
        if (indexPath.row==1) {
            return 80;
        }
        else
            return 40;
    }
    else
        return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 2;
        }
            break;
        case 3:
        {
            return 2;
        }
            break;
        default:
        {
            return 1;
        }
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            static NSString *Cell = @"Cellsa";
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView * view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            [cell.contentView addSubview:self.photoWall];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *Cell = @"profile";

            ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = indexPath.row==0?@"签名":@"爱好";
            cell.describeLabel.text = indexPath.row==0?self.hostInfo.signature:self.hostInfo.hobby;
            cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [[self.heightArray objectAtIndex:indexPath.row] floatValue]);
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row==0) {
                static NSString *Cell = @"Cellddf";
                
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"爱宠";
                return cell;
            }
            else
            {
                static NSString *Cell = @"Celldd";
                
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView * view in cell.contentView.subviews) {
                    [view removeFromSuperview];
                }
                [cell.contentView addSubview:self.photoWall2];
                return cell;
            }
        }
            break;
        case 3:
        {
            if (indexPath.row==0) {
                static NSString *Cell = @"Cellddfff";
                
                MyProfileACell *cell = (MyProfileACell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[MyProfileACell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.titleLabel.text = @"最新动态";
                return cell;
            }
            else
            {
                static NSString *Cell = @"Celldds";
                
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                return cell;
            }

        }
            break;
            
        default:
            return nil;
            break;
    }
}
-(void)getUserInfoWithUserName:(NSString *)userName
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"selectUserViewByUserName" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        self.hostInfo = [[HostInfo alloc] initWithHostInfo:recDict];
        [self reloadTheViews];
        [DataStoreManager saveUserInfo:recDict];

    }];

}
-(void)helloBtnClicked:(UIButton *)sender
{
    if (self.myFriend) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[TempData sharedInstance] setNeedChatToUser:self.hostInfo.userName];
    }
    else
    {
      //  [self.appDel.xmppHelper addFriend:self.hostInfo.userName];
//        [sayHelloArray addObject:[self.userInFo objectForKey:@"username"]];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发送验证请求" message:[NSString stringWithFormat:@"您已经和%@打招呼了，如果对方同意，您和%@就可以成为好友啦~",[self.userInFo objectForKey:@"username"],[self.userInFo objectForKey:@"username"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"打招呼的时候说点什么吧" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 11;
        locationTextF = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 240, 35)];
        locationTextF.borderStyle = UITextBorderStyleLine;
        [locationTextF setBackgroundColor:[UIColor whiteColor]];
        [alert addSubview:locationTextF];
        [alert show];

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11) {
        if (buttonIndex==1) {
            [self.appDel.xmppHelper addFriend:self.hostInfo.userName];
        }
    }
}
-(void)sendHelloWithMsg:(NSString *)message
{
    
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    if (photoWall.tag==1) {
        NSLog(@"1");
    }
    else
    {
        NormalPetDetailViewController * normalV = [[NormalPetDetailViewController alloc] init];
        normalV.petInfo = [self.hostInfo.petsArray objectAtIndex:index];
        [self.navigationController pushViewController:normalV animated:YES];
        NSLog(@"2,%d",index);
    }
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    
}

- (void)photoWallAddAction
{

}

- (void)photoWallAddFinish
{
    
}

- (void)photoWallDeleteFinish
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
