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
#import "NarrowDynamicCell.h"
#import "UIExpandingTextView.h"
#import "ReplyComment.h"
#import "PersonalDynamicViewController.h"
#import "PersonDynamicDelegateAndDataSouce.h"

@interface PersonDetailViewController ()<UIExpandingTextViewDelegate>
{
    UIButton * assessB;
    UIButton * reprintB;
    
    int assessOrPraise;
    
    UIImageView * inputbg;
    UIView * inPutView;
}
@property (nonatomic,strong)NSMutableArray* dynamicArray;
@property (nonatomic,strong)UIImageView*  actionIV;
@property (nonatomic,weak)NarrowDynamicCell* mycell;
@property (nonatomic,weak)id theID;
@property (nonatomic,strong)UIExpandingTextView* inputTF;
@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needRequest = NO;
        self.myFriend = NO;
        self.friendStatus = @"";
        self.dynamicArray = [[NSMutableArray alloc]init];
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
    self.photoWall.descriptionType = DescriptionTypeImage;
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    
    self.photoWall.delegate = self;
    self.photoWall.tag =1;
    
    self.photoWall2 = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    self.photoWall2.descriptionType = DescriptionTypePet;
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
    [self.helloBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.helloBtn addTarget:self action:@selector(helloBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rejectBtn setFrame:CGRectMake(165, self.view.frame.size.height-10-40, 145, 40)];
    [self.rejectBtn setBackgroundImage:[UIImage imageNamed:@"regbg-normal.png"] forState:UIControlStateNormal];
    [self.rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rejectBtn addTarget:self action:@selector(helloBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rejectBtn.hidden = YES;
    
    if ([DataStoreManager ifHaveThisFriend:self.hostInfo.userName]) {
        [self.helloBtn setTitle:@"发消息" forState:UIControlStateNormal];
        self.myFriend = YES;
    }
    else
    {
        [self.helloBtn setTitle:@"打招呼" forState:UIControlStateNormal];
        self.myFriend = NO;
        if ([DataStoreManager ifSayHellosHaveThisPerson:self.hostInfo.userName]&&[self.friendStatus isEqualToString:@"waiting"]) {
            [self.helloBtn setTitle:@"同意" forState:UIControlStateNormal];
            [self.helloBtn setFrame:CGRectMake(10, self.view.frame.size.height-10-40, 145, 40)];
            [self.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            self.rejectBtn.hidden = NO;
        }
        if ([DataStoreManager ifSayHellosHaveThisPerson:self.hostInfo.userName]&&[self.friendStatus isEqualToString:@"rejected"]) {
            self.helloBtn.hidden = YES;
            [self.rejectBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            self.rejectBtn.frame = CGRectMake(10, self.view.frame.size.height-10-40, 300, 40);
            self.rejectBtn.enabled = NO;

            self.rejectBtn.hidden = NO;
        }
    }
    
    [self.view addSubview:self.helloBtn];
    [self.view addSubview:self.rejectBtn];
    if (self.needRequest) {
        [self getUserInfoWithUserName:self.hostInfo.userName];
    }
    
    typeMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, 320, self.view.frame.size.height)];
    typeMsgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:typeMsgView];
    UIView * blackV = [[UIView alloc] initWithFrame:CGRectMake(40, 90, 240, 150)];
    blackV.backgroundColor = [UIColor blackColor];
    blackV.layer.cornerRadius = 5;
    blackV.alpha = 0.8;
    [typeMsgView addSubview:blackV];
    UILabel * yL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 220, 20)];
    yL.backgroundColor = [UIColor clearColor];
    yL.text = @"打招呼的时候说点什么吧";
    yL.textColor = [UIColor whiteColor];
    yL.textAlignment = NSTextAlignmentCenter;
    [blackV addSubview:yL];
    locationTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 220, 30)];
    locationTextF.backgroundColor = [UIColor whiteColor];
    locationTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [blackV addSubview:locationTextF];
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor grayColor]];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(10, 95, 105, 40)];
    [blackV addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnDo) forControlEvents:UIControlEventTouchUpInside];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor grayColor]];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setFrame:CGRectMake(125, 95, 105, 40)];
    [blackV addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnDo) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    [inPutView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:inPutView];
    inputbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [inputbg setImage:[UIImage imageNamed:@"inputbg.png"]];
    [inPutView addSubview:inputbg];
    
    self.inputTF = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    self.inputTF.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [self.inputTF.internalTextView setReturnKeyType:UIReturnKeySend];
    self.inputTF.delegate = self;
    self.inputTF.maximumNumberOfLines=5;
    [inPutView addSubview:self.inputTF];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (!self.needRequest) {
        [self reloadDynamicData];
    }

}
-(void)cancelBtnDo
{
    [locationTextF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [typeMsgView setFrame:CGRectMake(0, -self.view.frame.size.height, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)sureBtnDo
{
    [self.appDel.xmppHelper addFriend:self.hostInfo.userName];
    NSString *message = locationTextF.text;
    if (message.length<1) {
        message = [NSString stringWithFormat:@"Hi~我是%@，加我为好友吧",[DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]];
    }
    if (message.length > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        [mes addAttributeWithName:@"type" stringValue:@"sayHello"];
        [mes addAttributeWithName:@"to" stringValue:[self.hostInfo.userName stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        [mes addChild:body];
        locationTextF.text = @"";
        [self.appDel.xmppHelper.xmppStream sendElement:mes];
        
        
    }
    [locationTextF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [typeMsgView setFrame:CGRectMake(0, -self.view.frame.size.height, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        //locationTextF.text = @"";
        [KGStatusBar showSuccessWithStatus:@"好友请求发送成功"];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [locationTextF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [typeMsgView setFrame:CGRectMake(0, -self.view.frame.size.height, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
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
//    if (imageArray) {
//        if (imageArray.count<1) {
//            [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,@""]];
//        }
//    }
    
    return temp;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1){
        return 30;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
    if ((!self.myFriend)&&section == 3) {
        return @"非好友最多只能查看5条动态";
    }
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
            if (self.hostInfo.petsArray.count<=0) {
                return 0;
            }
            else
                return self.photoWall2.frame.size.height;
        }
        else
            return 40;
    }
    else if (indexPath.section==3){
        if (indexPath.row==0) {
            return 40;
        }
        else
            return ((PersonalDynamic*)self.dynamicArray[indexPath.row-1]).rowHigh;
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
            if (self.myFriend) {
                if (self.dynamicArray.count>0) {
                    return 2;
                }
                else
                    return 1;
            
            }
            if (self.dynamicArray.count>5) {
                return 6;
            }
            return self.dynamicArray.count+1;
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
                
                if (self.hostInfo.petsArray.count<=0) {
                    cell.textLabel.text = @"主人还没有宠物呢";
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                else{
                    cell.textLabel.text = @"爱宠";
                    cell.textLabel.textColor = [UIColor blackColor];
                }
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
                if (self.hostInfo.petsArray.count>0) {
                    [cell.contentView addSubview:self.photoWall2];
                }
                
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
                if (self.myFriend) {
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.arrow.hidden = NO;
                }else{
                    cell.arrow.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.titleLabel.text = @"最新动态";
                return cell;
            }
            else
            {
                static NSString *Cell = @"Celldds";
                
                NarrowDynamicCell *cell = (NarrowDynamicCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[NarrowDynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                    cell.viewC = self;
                }
                cell.dynamic = self.dynamicArray[indexPath.row-1];
                if (self.myFriend) {
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                return cell;
            }

        }
            break;
            
        default:
            return nil;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3&&self.myFriend) {
        PersonalDynamicViewController * pdvc = [[PersonalDynamicViewController alloc]init];
        PersonDynamicDelegateAndDataSouce * pddds = [[PersonDynamicDelegateAndDataSouce alloc]init];
        pddds.userID = self.hostInfo.userId;
        pdvc.dataSource = pddds;
        [self.navigationController pushViewController:pdvc animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeActionImageView];
    self.mycell = nil;
    [self keyBoardResign];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self removeActionImageView];
    self.mycell = nil;
    [self keyBoardResign];
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
        if (self.myFriend) {
            [DataStoreManager saveUserInfo:recDict];
        }
        [self reloadDynamicData];

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
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"打招呼的时候说点什么吧" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 11;
//        locationTextF = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 240, 35)];
//        locationTextF.borderStyle = UITextBorderStyleLine;
//        [locationTextF setBackgroundColor:[UIColor redColor]];
//        [alert addSubview:locationTextF];
//        [alert show];
        if ([self.helloBtn.currentTitle isEqualToString:@"同意"]) {
            [self.appDel.xmppHelper addOrDenyFriend:YES user:self.hostInfo.userName];
            [DataStoreManager addFriendToLocal:self.hostInfo.userName];
            [DataStoreManager updateReceivedHellosStatus:@"accept" ForPerson:self.hostInfo.userName];
            [self.helloBtn setFrame:CGRectMake(10, self.view.frame.size.height-10-40, 300, 40)];
            [self.helloBtn setTitle:@"发消息" forState:UIControlStateNormal];
            self.rejectBtn.hidden = YES;
            self.myFriend = YES;
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [typeMsgView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            [locationTextF becomeFirstResponder];
        }];
        

    }
}
-(void)rejectBtnClicked:(UIButton *)sender
{
    [self.appDel.xmppHelper addOrDenyFriend:NO user:self.hostInfo.userName];
    [DataStoreManager updateReceivedHellosStatus:@"rejected" ForPerson:self.hostInfo.userName];
    self.helloBtn.hidden = YES;
    [self.rejectBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
    self.rejectBtn.frame = CGRectMake(10, self.view.frame.size.height-10-40, 300, 40);
    self.rejectBtn.enabled = NO;
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
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    
}
- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    if (photoWall.tag==1) {
        PhotoViewController * pV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.hostInfo.headBigImgArray indext:index];
        [self presentModalViewController:pV animated:NO];
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
-(void)reloadDynamicData{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.hostInfo.userId forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"pageIndex"];
    [params setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"lastStateid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"findFriendStates" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray*array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.dynamicArray removeAllObjects];
        for (NSDictionary*a in array) {
            PersonalDynamic* b = [[PersonalDynamic alloc]initWithNSDictionary:a];
            [self.dynamicArray addObject:b];
            [self.profileTableV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - cell button action
-(void)showButton:(NarrowDynamicCell*)cell
{
    CGRect cellRect=[self.view convertRect:cell.frame fromView:_profileTableV];
    if (_actionIV == nil) {
        self.actionIV = [[UIImageView alloc]init];
        _actionIV.userInteractionEnabled = YES;
        _actionIV.image = [UIImage imageNamed:@"tanchuanniu_bg"];
        [self.view addSubview:_actionIV];
        
        assessB = [UIButton buttonWithType:UIButtonTypeCustom];
        assessB.frame = CGRectMake(0, 6, 0,31);
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [assessB setTitle:@"评论" forState:UIControlStateNormal];
        [assessB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [assessB addTarget:self action:@selector(assess) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:assessB];
        
        reprintB = [UIButton buttonWithType:UIButtonTypeCustom];
        reprintB.frame = CGRectMake(0, 6, 0, 31);
        [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [reprintB setTitle:@"转载" forState:UIControlStateNormal];
        [reprintB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [reprintB addTarget:self action:@selector(reprint) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:reprintB];
    }
    if (cell != _mycell) {
        [self removeActionImageView];
        self.mycell = nil;
        _actionIV.frame = CGRectMake(280, cellRect.origin.y+cell.moveB.frame.origin.y, 0, 44);
        [self.view addSubview:_actionIV];
        self.mycell = cell;
        [UIView animateWithDuration:0.3 animations:^{
            _actionIV.frame = CGRectMake( 158, cellRect.origin.y+cell.moveB.frame.origin.y, 127, 44);
            assessB.frame = CGRectMake(6, 6, 53, 31);
            reprintB.frame = CGRectMake(65, 6, 53, 31);
        }];
    }else{
        self.mycell = nil;
        [self removeActionImageView];
    }
}
-(void)removeActionImageView
{
    assessB.frame = CGRectMake(0, 6, 0,31);
    reprintB.frame = CGRectMake(0, 6, 0, 31);
    [_actionIV removeFromSuperview];
    
}
-(void)recalledreply:(id)theID cell:(NarrowDynamicCell*)cell//回复评论
{
    if ([theID isKindOfClass:[Reply class]]) {
        _inputTF.placeholder = [NSString stringWithFormat:@"回复:%@",((Reply*)theID).petUser.nickName];
    }
    if ([theID isKindOfClass:[ReplyComment class]]) {
        _inputTF.placeholder = [NSString stringWithFormat:@"回复:%@",((ReplyComment*)theID).commentUserView.nickName];
    }
    self.mycell = cell;
    self.theID = theID;
    [_inputTF becomeFirstResponder];
    assessOrPraise = 3;
    
}
-(void)assess//评论
{
    [self removeActionImageView];
    [_inputTF becomeFirstResponder];
    assessOrPraise = 1;
    _inputTF.placeholder = [NSString stringWithFormat:@"评论:%@",self.mycell.dynamic.petUser.nickName];
}
-(void)reprint//转发
{
    [self removeActionImageView];
    [_inputTF becomeFirstResponder];
    assessOrPraise = 2;
    _inputTF.placeholder = @"转发至我的动态";
}
-(void)didInput
{
    if (_inputTF.text.length>0) {
        switch (assessOrPraise) {
            case 1:
            {
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                long long a = (long long)(cT*1000);
                [params setObject:[DataStoreManager getMyUserID] forKey:@"petuserId"];
                [params setObject:self.mycell.dynamic.dynamicID forKey:@"userstateId"];
                [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"replyTime"];
                [params setObject:self.inputTF.text forKey:@"msg"];
                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                [body setObject:@"1" forKey:@"channel"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                [body setObject:@"iphone" forKey:@"imei"];
                [body setObject:params forKey:@"params"];
                [body setObject:@"addReply" forKey:@"method"];
                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    Reply* rep = [[Reply alloc]initWithDictionary:dic];
                    [self.mycell.dynamic.replyViews addObject:rep];
                    self.mycell.dynamic.rowHigh+=28;
                    [self.profileTableV reloadData];
                    self.mycell = nil;
                }];
            }break;
            case 2:
            {
                if (_inputTF.text.length<=80) {
                    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                    long long a = (long long)(cT*1000);
                    [params setObject:@"" forKey:@"transmitUrl"];
                    [params setObject:self.inputTF.text forKey:@"transmitMsg"];
                    [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"submitTime"];
                    [params setObject:@"1" forKey:@"ifTransmitMsg"];
                    [params setObject:self.mycell.dynamic.msg forKey:@"msg"];
                    [params setObject:self.mycell.dynamic.imageID forKey:@"imgid"];
                    [params setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
                    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
                    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
                    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                    [body setObject:@"1" forKey:@"channel"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                    [body setObject:@"iphone" forKey:@"imei"];
                    [body setObject:params forKey:@"params"];
                    [body setObject:@"addUserState" forKey:@"method"];
                    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                    }];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"转发内容不得超过80个字" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
                    [alert show];
                }
                
            }break;
            case 3:
            {
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                long long a = (long long)(cT*1000);
                [params setObject:[DataStoreManager getMyUserID] forKey:@"commentUserid"];
                [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"commentTime"];
                if ([self.theID isKindOfClass:[Reply class]]) {
                    [params setObject:((Reply*)self.theID).petUser.userId forKey:@"replyUserid"];
                    [params setObject:((Reply*)self.theID).replyID forKey:@"replyId"];
                    [params setObject:((Reply*)self.theID).dynamicID forKey:@"userStateid"];
                }
                if ([self.theID isKindOfClass:[ReplyComment class]]) {
                    [params setObject:((ReplyComment*)self.theID).commentUserView.userId forKey:@"replyUserid"];
                    [params setObject:((ReplyComment*)self.theID).replyID forKey:@"replyId"];
                    [params setObject:((ReplyComment*)self.theID).userStateid forKey:@"userStateid"];
                }
                
                [params setObject:_inputTF.text forKey:@"msg"];
                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                [body setObject:@"1" forKey:@"channel"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                [body setObject:@"iphone" forKey:@"imei"];
                [body setObject:params forKey:@"params"];
                [body setObject:@"addCommentReply" forKey:@"method"];
                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    ReplyComment* repcom = [[ReplyComment alloc]initWithDictionary:dic];
                    if ([self.theID isKindOfClass:[Reply class]]) {
                        [((Reply*)self.theID).replyComments addObject:repcom];
                        self.mycell.dynamic.rowHigh+=28;
                        [self.profileTableV reloadData];
                    }
                    if ([self.theID isKindOfClass:[ReplyComment class]]) {
                        Reply* theRep = nil;
                        for (Reply* re  in self.mycell.dynamic.replyViews) {
                            for (ReplyComment* rec in re.replyComments) {
                                if ([rec isEqual:self.theID]) {
                                    theRep = re;
                                    break;
                                }
                            }
                        }
                        if (theRep) {
                            [theRep.replyComments addObject:repcom];
                        }
                        self.mycell.dynamic.rowHigh+=28;
                        [self.profileTableV reloadData];
                    }
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    self.mycell = nil;
                }];
            }break;
                
            default:
                break;
        }
        [self keyBoardResign];
    }
}
-(void)keyBoardResign
{
    [_inputTF resignFirstResponder];
}
#pragma mark - Responding to keyboard events
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (expandingTextView.frame.size.height - height);
    CGRect r = inPutView.frame;
    CGRect r2 = inputbg.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    r2.size.height-=diff;
    inPutView.frame = r;
    inputbg.frame = r2;
    
}
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView
{
    [self didInput];
    expandingTextView.text = @"";
    return YES;
}
#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0];
}
-(void) autoMovekeyBoard: (float) h{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (typeMsgView.frame.origin.y<0) {
        if (iPhone5) {
            if (self.view.frame.size.height == 499.0) {
                inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height+49), 320.0f, inPutView.frame.size.height);
            }else{
                inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
            }
        }
        else
        {
            if (self.view.frame.size.height == 411.0) {
                inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height+49), 320.0f, inPutView.frame.size.height);
            }else{
                inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
            }
        }
        if (h==0) {
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height), 320.0f, inPutView.frame.size.height);
        }

    }
    
    [UIView commitAnimations];
    NSLog(@"%f",self.view.frame.size.height);
}
@end
