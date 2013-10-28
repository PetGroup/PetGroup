//
//  FriendCircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "TempData.h"
#import "EditDynamicViewController.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "OnceDynamicViewController.h"
#import "PhotoViewController.h"

@interface FriendCircleViewController ()<UITableViewDelegate,DynamicCellDelegate,TableViewNeedReloadData>
{
    BOOL request;
}
@property (nonatomic,retain)UIView* headV;
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)FriendCircleDataSource* friendCircleDS;
@property (nonatomic,strong)UIActivityIndicatorView * act;
@property (nonatomic,strong)UIActivityIndicatorView * footAct;
@property (nonatomic,strong)UIView* footV;
@end

@implementation FriendCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendCircleDS = [[FriendCircleDataSource alloc]init];
        _friendCircleDS.myController = self;
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
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"朋友圈"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3+diffH, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self.friendCircleDS;
    [self.view addSubview:_tableV];
    
    self.headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 240.5)];
    _headV.backgroundColor = [UIColor whiteColor];
    self.tableV.tableHeaderView = _headV;
    
    EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220.5)];
    imageV.placeholderImage = [UIImage imageNamed:@"morenbeijing"];
    imageV.userInteractionEnabled = YES;
    imageV.imageURL = [NSURL URLWithString:@""];
    [_headV addSubview:imageV];
    
    NSDictionary* dic = [DataStoreManager queryMyInfo];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(170, 190, 60, 20)];
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    [imageV addSubview:nameL];
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 160, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [imageV addSubview:photoIV];
    photoIV.userInteractionEnabled = YES;
    
    EGOImageButton*headIV = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
    headIV.frame = CGRectMake(5, 5, 70, 70);
    [photoIV addSubview:headIV];
    [headIV addTarget:self action:@selector(headAct) forControlEvents:UIControlEventTouchUpInside];
    
    nameL.text = [dic objectForKey:@"nickname"];
    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameL.frame = CGRectMake(220-size.width, 190, size.width, 20);
    NSString * imageID = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",imageID]];
    
    UILabel*signatureL  = [[UILabel alloc]initWithFrame:CGRectMake(0, 220.5, 320, 20)];
    signatureL.font = [UIFont systemFontOfSize:16];
    signatureL.backgroundColor = [UIColor clearColor];
    signatureL.textColor = [UIColor blackColor];
    signatureL.text = [dic objectForKey:@"signature"];
    [_headV addSubview:signatureL];
    
    self.footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _footAct.backgroundColor = [UIColor redColor];
    self.footAct= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    _footAct.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_footV addSubview:_footAct];
    UILabel* loadmoveL = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 20)];
    loadmoveL.text = @"加载更多";
    loadmoveL.textAlignment = NSTextAlignmentCenter;
    [_footV addSubview:loadmoveL];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)headAct
{
    
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateSelfMassage
{
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell heightForRowWithDynamic:self.friendCircleDS.dataSourceArray[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.delegate = self;
    [self.navigationController pushViewController:odVC animated:YES];
}
#pragma mark -
#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖拽
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!request&&!_tableV.decelerating) {
        if (_tableV.contentOffset.y<-5) {
            if (self.act == nil) {
                self.act= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
                _act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [_act startAnimating];
                [_tableV.tableHeaderView addSubview:_act];
            }else{
                [_act startAnimating];
            }
        }
        if (_tableV.contentSize.height>_tableV.frame.size.height+5) {
            if (_tableV.contentOffset.y>_tableV.contentSize.height-_tableV.frame.size.height-5) {
                if (_tableV.tableFooterView == nil) {
                    _tableV.tableFooterView = _footV;
                    [_footAct startAnimating];
                }else{
                    [_footAct startAnimating];
                }
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //停止滑动
    if (_tableV.contentSize.height>_tableV.frame.size.height+5 ) {
        if (_tableV.contentOffset.y>=_tableV.contentSize.height-_tableV.frame.size.height-35) {
            [_footAct stopAnimating];
            [UIView animateWithDuration:0.3 animations:^{
                _tableV.tableFooterView = nil;
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //停止减速
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //开始减速
    if (!request) {
        if (_tableV.contentOffset.y<-5) {
            [self reloadData];
        }
        if (_tableV.contentSize.height>_tableV.frame.size.height+5) {
            if (_tableV.contentOffset.y>=_tableV.contentSize.height-_tableV.frame.size.height-30) {
                [self loadMoreData];
            }
        }
    }
}
#pragma mark - dynamic cell delegate
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dynamicCellPressZanButtonAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indext= %d= %d",indexPath.section,indexPath.row);
    Dynamic* dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    if (!dynamic.ifIZaned) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:dynamic.dynamicID forKey:@"srcid"];
        [params setObject:@"赞动态" forKey:@"type"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"service.uri.pet_pat" forKey:@"service"];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"addPat" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            dynamic.ifIZaned = !dynamic.ifIZaned;
            dynamic.countZan++;
            [self.tableV reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:dynamic.dynamicID forKey:@"srcid"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"service.uri.pet_pat" forKey:@"service"];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"delPat" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            dynamic.ifIZaned = !dynamic.ifIZaned;
            dynamic.countZan--;
            [self.tableV reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
-(void)dynamicCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath
{
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.delegate = self;
    odVC.onceDynamicViewControllerStyle = OnceDynamicViewControllerStyleReply;
    [self.navigationController pushViewController:odVC animated:YES];
}
-(void)dynamicCellPressZhuangFaButtonAtIndexPath:(NSIndexPath *)indexPath
{
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.onceDynamicViewControllerStyle = OnceDynamicViewControllerStyleZhuanfa;
    odVC.delegate = self;
    [self.navigationController pushViewController:odVC animated:YES];
}
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray indext:(int)indext
{
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:smallImageArray images:idArray indext:indext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - dynamic list reload data
-(void)dynamicListNeedReloadData:(Dynamic *)dynamic
{
    if (dynamic) {
        [self.friendCircleDS.dataSourceArray insertObject:dynamic atIndex:0];
    }
    [self.tableV reloadData];
}
#pragma mark - load data
-(void)reloadData
{
    request = YES;
    [_friendCircleDS reloadDataSuccess:^{
        request = NO;
        [self.tableV reloadData];
        [self.act stopAnimating];
    } failure:^{
        request = NO;
        [self.act stopAnimating];
    }];
}
-(void)loadMoreData
{
    request = YES;
    [_friendCircleDS loadMoreDataSuccess:^{
        request = NO;
        [self.tableV reloadData];
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
    } failure:^{
        request = NO;
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
    }];
}
@end
