//
//  NormalPetDetailViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NormalPetDetailViewController.h"

@interface NormalPetDetailViewController ()

@end

@implementation NormalPetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.petInfo.petNickname;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    [self.photoWall setPhotos:[self imageToURL:self.petInfo.headImgArray]];
    self.photoWall.delegate = self;
    self.photoWall.tag =1;
    
    self.petInfo.petType = [XMLMatcher typeStringWithNumber:self.petInfo.petType];
    self.petInfo.petTrait = self.petInfo.petTrait.length>1?self.petInfo.petTrait:@"主人还没有给她填写特点呢";
    if ([self.petInfo.petGender isEqualToString:@"male"]) {
        self.petInfo.petGender = @"公";
    }
    else if ([self.petInfo.petGender isEqualToString:@"female"]){
        self.petInfo.petGender = @"母";
    }
    else
        self.petInfo.petGender = @"还不知道呢";
    self.petInfo.petAge = [NSString stringWithFormat:@"%@岁",self.petInfo.petAge];
    
    [self makeHeight];
    self.titleArray = [NSArray arrayWithObjects:@"品种",@"昵称",@"性别",@"年龄",@"特点", nil];
    self.discribeArray = [NSArray arrayWithObjects:self.petInfo.petType,self.petInfo.petNickname,self.petInfo.petGender,self.petInfo.petAge,self.petInfo.petTrait, nil];
    
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    
    
	// Do any additional setup after loading the view.
}
-(void)makeHeight
{
    CGSize size1 = [self.petInfo.petType sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height1 = [NSNumber numberWithFloat:size1.height];
    CGSize size2 = [self.petInfo.petNickname sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height2 = [NSNumber numberWithFloat:size2.height];
    CGSize size3 = [self.petInfo.petGender sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height3 = [NSNumber numberWithFloat:size3.height];
    CGSize size4 = [self.petInfo.petAge sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height4 = [NSNumber numberWithFloat:size4.height];
    CGSize size5 = [self.petInfo.petTrait sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
    NSNumber * height5 = [NSNumber numberWithFloat:size5.height];
    self.heightArray = [NSArray arrayWithObjects:height1,height2,height3,height4,height5, nil];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return self.photoWall.frame.size.height;
    }
    else
        return [[self.heightArray objectAtIndex:indexPath.row] floatValue]+20;
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
            return self.heightArray.count;
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
            cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
            cell.describeLabel.textAlignment = NSTextAlignmentRight;
            cell.describeLabel.text = [self.discribeArray objectAtIndex:indexPath.row];
            cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [[self.heightArray objectAtIndex:indexPath.row] floatValue]);
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    
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

-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
