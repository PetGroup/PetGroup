//
//  CategoryViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        petTypeArray = [[NSArray alloc]initWithObjects:@"狗狗",@"猫咪",@"其他" ,nil];
        self.petTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:[XMLMatcher allDogs],petTypeArray[0],[XMLMatcher allCats],petTypeArray[1],[XMLMatcher allother],petTypeArray[2], nil];
//        self.petBreedArray = [XMLMatcher allDogs];
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    
    
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
    if (self.tableType==TableTypePetCategory) {
        [titleLabel setText:@"宠物品种"];
    }
    else if (self.tableType==TableTypePetExperience){
        [titleLabel setText:@"养宠经验"];
    }
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.categoryTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    self.categoryTableV.delegate = self;
    self.categoryTableV.dataSource = self;
    self.categoryTableV.backgroundView = nil;
    [self.view addSubview:self.categoryTableV];
	// Do any additional setup after loading the view.
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableType==TableTypePetCategory) {
        return self.petTypeDict.count;
    }
    else if(self.tableType==TableTypePetExperience ){
        return 1;
    }
    else
        return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableType==TableTypePetCategory) {
        return [[self.petTypeDict objectForKey:[petTypeArray objectAtIndex:section]] count];
    }
    else if(self.tableType==TableTypePetExperience ){
        return self.petTypeDict.count;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.tableType==TableTypePetCategory) {
        cell.textLabel.text = [[self.petTypeDict objectForKey:[petTypeArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else
        cell.textLabel.text = petTypeArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableType==TableTypePetExperience) {
        ExperienceListViewController * epV = [[ExperienceListViewController alloc] init];
        [self.navigationController pushViewController:epV animated:YES];
    }
    else
    {
        ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
        cv.contentType = contentTypeWebView;
        UITableViewCell * ddd = [tableView cellForRowAtIndexPath:indexPath];
        NSString * namePet = ddd.textLabel.text;
        if ([namePet isEqualToString:@"贵宾/泰迪"]) {
            namePet = @"泰迪犬";
        }
        NSString * sss = [NSString stringWithFormat:@"http://baike.baidu.com/searchword/?word=%@&pic=1&sug=1&enc=utf-8",namePet];
        cv.addressURL = [NSURL URLWithString:[sss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.navigationController pushViewController:cv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableType==TableTypePetCategory) {
        return 25.0f;
    }
    else
        return 0.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.tableType==TableTypePetCategory) {
        return petTypeArray[section];
    }
    else
        return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
