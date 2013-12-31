//
//  DiscoverViewController.m
//  PetGroup
//
//  Created by wangxr on 13-11-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"
#import "DPBusinessListViewController.h"
#import "PinterestViewController.h"
#import "PetknowledgeViewController.h"
#import "TempData.h"
#import "CustomTabBar.h"
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "WebViewViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer* timer;
}
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)NSArray*nameArray;
@property (nonatomic,retain)NSArray*iconNameArray;
@property (nonatomic,retain)NSArray* advertisementArray;
@end

@implementation DiscoverViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nameArray = @[@"附近的人",@"宠物周边",@"宠物美图",@"宠物百科"];
        self.iconNameArray = @[@"fujin.png",@"zhoubian.png",@"meitu.png",@"baike.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
	// Do any additional setup after loading the view.
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"发现"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundView = nil;
    [self.view addSubview:_tableV];
    
    [self loadAdvertisement];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[TempData sharedInstance] needChat]) {
        [self.customTabBarController setSelectedPage:2];
        return;
    }
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
    [self advertisement];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        return self.view.frame.size.height-44-diffH-240-49;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=4) {
        static NSString *cellIdentifier = @"cell1";
        MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.headImageV.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.arrow.hidden = NO;
        cell.headImageV.image = [UIImage imageNamed:_iconNameArray[indexPath.row]];
        [cell.headImageV setFrame:CGRectMake(10, 7.5, 45, 45)];
        //    [cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 35, 35)];
        cell.titleLabel.text = _nameArray[indexPath.row];
        //    [cell.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cell.titleLabel setFrame:CGRectMake(70, 20, 100, 20)];
        [cell.arrow setFrame:CGRectMake(287, 18.5, 8.5, 12.5)];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *cellIdentifier = @"advertisementCell";
        UITableViewCell* cell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

#pragma mark - UIScroll View delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= _advertisementArray.count*320) {
        scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    if (timer != nil) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerDown:) userInfo:nil repeats:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            NearByViewController* nearByVC = [[NearByViewController alloc]init];
            [self.navigationController pushViewController:nearByVC animated:YES];
        }break;
        case 1:{
            DPBusinessListViewController* businessVC = [[DPBusinessListViewController alloc]init];
            [self.navigationController pushViewController:businessVC animated:YES];
        }break;
        case 2:{
            PinterestViewController* pinterestVC = [[PinterestViewController alloc]init];
            [self.navigationController pushViewController:pinterestVC animated:YES];
        }break;
        case 3:{
            PetknowledgeViewController* pinterestVC = [[PetknowledgeViewController alloc]init];
            [self.navigationController pushViewController:pinterestVC animated:YES];
        }break;
        default:
            return;
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
#pragma mark - advertisement
//生成广告条,如果视图条目增加,增加TableView.from的修改逻辑
-(void)advertisement
{
    if ((![self.view viewWithTag:2013]) && _advertisementArray.count>0) {
        UIScrollView * sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(diffH?49:0)-60, 320, 60)];
        sc.showsHorizontalScrollIndicator = NO;
//        sc.backgroundColor = [UIColor blackColor];
        if (_advertisementArray.count == 1) {
            sc.contentSize = CGSizeMake(320 , 60);
            EGOImageButton * button = [[EGOImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
            button.tag = 100;
            button.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",[_advertisementArray[0] objectForKey:@"img"]]];
            [button addTarget:self action:@selector(readAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
            [sc addSubview:button];
        }else
        {
            sc.contentSize = CGSizeMake(320*_advertisementArray.count + 320, 60);
            for (int i = 0;i<_advertisementArray.count;i++) {
                EGOImageButton * button = [[EGOImageButton alloc]initWithFrame:CGRectMake(i*320, 0, 320, 60)];
                button.tag = 100+i;
                button.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",[_advertisementArray[i] objectForKey:@"img"]]];
                [button addTarget:self action:@selector(readAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
                [sc addSubview:button];
            }
            EGOImageView * view = [[EGOImageView alloc]initWithFrame:CGRectMake(_advertisementArray.count*320, 0, 320, 60)];
            view.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",[_advertisementArray[0] objectForKey:@"img"]]];
            [sc addSubview:view];
            if (timer != nil) {
                [timer invalidate];
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerDown:) userInfo:nil repeats:YES];
        }
        sc.delegate = self;
        sc.tag = 2014;
        sc.pagingEnabled = YES;
        [self.view addSubview:sc];
        UIButton * deleteB  = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteB.tag = 2013;
        deleteB.frame = CGRectMake(260, self.view.frame.size.height-(diffH?49:0)-60, 60, 60);
        [deleteB setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteB addTarget:self action:@selector(removeadvertisement) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteB];
    }
}
-(void)removeadvertisement
{
    [[self.view viewWithTag:2013] removeFromSuperview];
    [[self.view viewWithTag:2014] removeFromSuperview];
    if (timer != nil) {
        [timer invalidate];
    }
}
-(void)readAdvertisement:(UIButton*)button
{
    if ([[_advertisementArray[button.tag - 100] objectForKey:@"adType"] isEqualToString:@"url"]) {
        ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
        cv.contentType = contentTypeWebView;
        cv.typeName = @"内容";
        cv.needRequestURL = YES;
        cv.needDismiss = YES;
        cv.contentMode = ContentModeAD;
        cv.articleID = [_advertisementArray[button.tag - 100] objectForKey:@"id"];
        [self presentViewController:cv animated:YES completion:^{
            
        }];
    }
    if ([[_advertisementArray[button.tag - 100] objectForKey:@"adType"] isEqualToString:@"text"]) {
        ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
        cv.contentType = contentTypeTextView;
        cv.typeName = @"内容";
        cv.needDismiss = YES;
        cv.contentMode = ContentModeAD;
        cv.articleID = [_advertisementArray[button.tag - 100] objectForKey:@"id"];
        [self presentViewController:cv animated:YES completion:^{
            
        }];
    }
}
-(void)loadAdvertisement
{//未来实现广告接口的请求，在viewDidLoad中调用，请求返回后调用advertisement方法并修改里面的实现细节
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"getAds" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_notice" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.advertisementArray = [NSArray arrayWithArray:responseObject];
        [self advertisement];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)timerDown:(NSTimer*)aTimer
{
    UIScrollView * sc = (UIScrollView*)[self.view viewWithTag:2014];
    sc.contentOffset = CGPointMake(sc.contentOffset.x + 320, 0);
    if (sc.contentOffset.x >= _advertisementArray.count*320) {
        sc.contentOffset = CGPointMake(0, 0);
        return;
    }
}
@end
