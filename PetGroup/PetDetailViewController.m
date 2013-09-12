//
//  PetDetailViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PetDetailViewController.h"
#import "CustomTabBar.h"
@interface PetDetailViewController ()

@end

@implementation PetDetailViewController

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
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.petInfo.petNickname;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    NSString * gender = self.petInfo.petGender;
    NSString * age = self.petInfo.petAge;
    NSString * region = @"北京市朝阳区";
    UIImage * genderImg = [gender isEqualToString:@"male"]?[UIImage imageNamed:@"manicon.png"]:[UIImage imageNamed:@"womenicon.png"];
    
    self.genderBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.genderBgV.backgroundColor = [UIColor clearColor];
    self.petGenderIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.petGenderIV setImage:genderImg];
    [self.petGenderIV setFrame:CGRectMake(13, 9, genderImg.size.width/2, genderImg.size.height/2)];
    [self.genderBgV addSubview:self.petGenderIV];
    self.petAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 80, 20)];
    [self.petAgeLabel setText:age];
    [self.petAgeLabel setBackgroundColor:[UIColor clearColor]];
    [self.genderBgV addSubview:self.petAgeLabel];
    self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(300-160, 5, 160, 20)];
    [self.regionLabel setTextAlignment:NSTextAlignmentRight];
    [self.regionLabel setText:region];
    [self.regionLabel setFont:[UIFont systemFontOfSize:14]];
    [self.regionLabel setBackgroundColor:[UIColor clearColor]];
    [self.genderBgV addSubview:self.regionLabel];

    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    [self.photoWall setPhotos:[self imageToURL:self.petInfo.headImgArray]];
    self.photoWall.delegate = self;
    self.photoWall.tag =1;
    
    self.petInfo.petType = [XMLMatcher typeStringWithNumber:self.petInfo.petType];
    self.petInfo.petTrait = self.petInfo.petTrait.length>1?self.petInfo.petTrait:@"主人还没有给她填写特点呢";
    
    CGSize size1 = [self.petInfo.petType sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height1 = [NSNumber numberWithFloat:size1.height];
    CGSize size2 = [self.petInfo.petTrait sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height2 = [NSNumber numberWithFloat:size2.height];
    self.heightArray = [NSArray arrayWithObjects:height1,height2, nil];
    
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    
    NSLog(@"%@,%@,%@,%@",self.hostInfo.nickName,self.hostInfo.gender,self.hostInfo.userId,self.hostInfo.userName);
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    if (!imageArray) {
        [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,@""]];
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
            return 70.0;
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
            cell.titleLabel.text = indexPath.row==0?@"品种":@"特点";
            cell.describeLabel.text = indexPath.row==0?self.petInfo.petType:self.petInfo.petTrait;
            cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [[self.heightArray objectAtIndex:indexPath.row] floatValue]);
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row==0) {
                static NSString *Cell = @"Cellddf";
                
                MyProfileACell *cell = (MyProfileACell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[MyProfileACell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.titleLabel.text = @"主人信息";
                return cell;
                return cell;
            }
            else
            {
                static NSString *Cell = @"Celldd";
                
                HostInfoCell *cell = (HostInfoCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
                if (cell == nil) {
                    cell = [[HostInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.nameLabel.text = self.hostInfo.nickName;
                [cell.headImageV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,[self.hostInfo.headImgArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"moren_people.png"]];
                UIImage * genderImg = [self.hostInfo.gender isEqualToString:@"male"]?[UIImage imageNamed:@"manicon.png"]:[UIImage imageNamed:@"womenicon.png"];
                [cell.genderIV setImage:genderImg];
                [cell.genderIV setFrame:CGRectMake(70, 44, genderImg.size.width/2, genderImg.size.height/2)];
                cell.ageLabel.text = self.hostInfo.age;
                cell.regionLabel.text = @"北京朝阳区";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2) {
        PersonDetailViewController * hostV = [[PersonDetailViewController alloc] init];
        hostV.hostInfo = self.hostInfo;
        [self.navigationController pushViewController:hostV animated:YES];
        [self.customTabBarController hidesTabBar:YES animated:YES];
    }
}

-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    PhotoViewController * pV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.petInfo.headBigImgArray indext:index];
    [self presentModalViewController:pV animated:NO];
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
