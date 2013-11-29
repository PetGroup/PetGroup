//
//  PinterestViewController.m
//  Pinterest
//
//  Created by wangxr on 13-11-18.
//  Copyright (c) 2013年 wangxr. All rights reserved.
//

#import "PinterestViewController.h"
#import "TMQuiltView.h"
#import "BeautifulImageCell.h"
#import "TempData.h"
@interface PinterestViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,BeautifulImageCellDelegate>
@property (nonatomic,retain) NSMutableArray* imageArray;
@property (nonatomic,retain)TMQuiltView *tmQuiltView;
@end

@implementation PinterestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<27; i++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg",i]];
            [_imageArray addObject:image];
        }
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
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"美图";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    _tmQuiltView = [[TMQuiltView alloc] init];
    _tmQuiltView.frame = CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH);
    _tmQuiltView.delegate = self;
    _tmQuiltView.dataSource = self;
    
    [self.view addSubview:_tmQuiltView];
    [_tmQuiltView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark TMQuiltViewDataSource
-(NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return [self.imageArray count];
}

-(TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierStr = @"photoIdentifier";
    BeautifulImageCell *cell = (BeautifulImageCell *)[quiltView dequeueReusableCellWithReuseIdentifier:identifierStr];
    if (!cell)
    {
        cell = [[BeautifulImageCell alloc] initWithReuseIdentifier:identifierStr];
    }
    cell.imageView.image = _imageArray[indexPath.row];
    cell.titleL.text = @"1234";
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
#pragma mark -
#pragma mark TMQuiltViewDelegate
//列数
- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}
//单元高度
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = ((UIImage*)self.imageArray[indexPath.row]).size;
    float height = (size.height / size.width)*152.5;
    return height;
}
- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)beautifulImageCellPressZanButtonAtIndexPath:(NSIndexPath*)indexPath
{
    
}
@end
