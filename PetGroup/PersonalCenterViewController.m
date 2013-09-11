//
//  PersonalCenterViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CustomTabBar.h"
#import "PersonalDynamicViewController.h"
#import "MyDynamicDelegateAndDataSource.h"
@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

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
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"个人中心";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    self.photoWall.descriptionType = DescriptionTypePet;
    self.photoWall.useCache = YES;
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.petsHeadArray]];
    self.photoWall.delegate = self;
    [self.photoWall setEditModel:YES];
    self.photoWall.tag =1;
    
    
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-58.5-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.hostInfo = [[HostInfo alloc] initWithHostInfo:[DataStoreManager queryMyInfo]];
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.petsHeadArray]];
    [self.photoWall setEditModel:YES];
    [self.profileTableV reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
    if (![SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]) {
        [self.customTabBarController setSelectedPage:0]; 
    }

}
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    return temp;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 70.0;
            break;
        case 1:
        {
            if (indexPath.row==0) {
                return 40.0;
            }
            else
            {
                return self.photoWall.frame.size.height;

            }
        }
            break;
        default:
            return 40.0;
            break;
    }
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
            
            MyInfoCell *cell = (MyInfoCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[MyInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];

            cell.headImageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,self.hostInfo.headImgArray.count>0? [self.hostInfo.headImgArray objectAtIndex:0]:@""]];
          
            
            cell.nameLabel.text = self.hostInfo.nickName;
            cell.signatureLabel.text = self.hostInfo.signature;
            
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row==0) {
                static NSString *Cell = @"Cellsbs";
                
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                if (self.hostInfo.petsArray.count>0) {
                    cell.textLabel.text = @"爱宠";
                    cell.textLabel.textColor = [UIColor blackColor];
                }
                else
                {
                    cell.textLabel.text = @"暂时还没有宠物，点击添加吧";
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                
                return cell;

            }
            else
            {
                static NSString *Cell = @"Cellsb";
                
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
        }
            break;
        default:
        {
            static NSString *Cell = @"Cellsc";
            
            MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (indexPath.section==2) {
                [cell.headImageV setImage:[UIImage imageNamed:@"moren_people.png"]];
                cell.titleLabel.text = @"动态";
            }
            else
            {
                [cell.headImageV setImage:[UIImage imageNamed:@"moren_people.png"]];
                cell.titleLabel.text = @"设置";
            }
            
            return cell;
        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) { 
        MyProfileViewController * myV = [[MyProfileViewController alloc] init];
        myV.hostInfo = self.hostInfo;
        [self.navigationController pushViewController:myV animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }else if (indexPath.section==2) {
        PersonalDynamicViewController * PDVC = [[PersonalDynamicViewController alloc] init];
        MyDynamicDelegateAndDataSource* MDDDS = [[MyDynamicDelegateAndDataSource alloc]init];
        MDDDS.viewC = PDVC;
        PDVC.dataSource = MDDDS;
        [self.navigationController pushViewController:PDVC animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
    else if (indexPath.section==3){
        SettingViewController * setV = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:setV animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }

}
- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    MyPetProfileViewController * petV = [[MyPetProfileViewController alloc] init];
    petV.pageType = PageStyleChange;
    petV.petInfo = [self.hostInfo.petsArray objectAtIndex:index];
    [self.navigationController pushViewController:petV animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
    
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    
}

- (void)photoWallAddAction
{
    MyPetProfileViewController * petV = [[MyPetProfileViewController alloc] init];
    petV.pageType = PageStyleAdd;
    [self.navigationController pushViewController:petV animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}

- (void)photoWallAddFinish
{
    
}
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    [self delPet:index];

    //    [self.photoWall reloadPhotos:YES];
    
    
    
    
}

- (void)photoWallDeleteFinish
{
    
}
-(void)delPet:(NSInteger)index
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary * petinfo = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [petinfo setObject:[[self.hostInfo.petsArray objectAtIndex:index] petID] forKey:@"id"];
    [petinfo setObject:@"0" forKey:@"version"];
    [postDict setObject:petinfo forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"delPetInfo" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        [DataStoreManager deleteOnePetForPetID:[[self.hostInfo.petsArray objectAtIndex:index] petID]];
        NSMutableArray * temp = [NSMutableArray arrayWithArray:self.hostInfo.petsArray];
        [temp removeObjectAtIndex:index];
        self.hostInfo.petsArray = temp;
        [self.photoWall delSuccess];
        self.hostInfo = [[HostInfo alloc] initWithHostInfo:[DataStoreManager queryMyInfo]];
        [self.photoWall setPhotos:[self imageToURL:self.hostInfo.petsHeadArray]];
        [self.photoWall setEditModel:YES];
        [self.profileTableV reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.photoWall setAnimationNO];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络好像有点问题" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }];

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.photoWall setAnimationNO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
