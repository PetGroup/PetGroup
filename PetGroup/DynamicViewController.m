//
//  DynamicViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicViewController.h"
#import "CustomTabBar.h"
#import "NearbyDynamicDelegateAndDataSource.h"
#import "FriendDynamicDelegateAndDataSource.h"
#import "EditDynamicViewController.h"
#import "DynamicCell.h"
#import "MBProgressHUD.h"
@interface DynamicViewController ()<MBProgressHUDDelegate>
{
    UIButton* nearByB;
    UIButton* friendB;
    
    UIButton * praiseB;
    UIButton * assessB;
    UIButton * reprintB;
    
     MBProgressHUD * hud;
}
@property (nonatomic,strong)UIView* footV;
@property (nonatomic,strong)UITableView* tableV;
@property (nonatomic,strong)NearbyDynamicDelegateAndDataSource* nearbyDDS;
@property (nonatomic,strong)FriendDynamicDelegateAndDataSource* friendDDS;
@property (nonatomic,strong)UIActivityIndicatorView * act;
@property (nonatomic,strong)UIActivityIndicatorView * footAct;
@property (nonatomic,strong)UIImageView*  actionIV;
@property (nonatomic,weak)UITableViewCell* mycell;
@property (nonatomic,strong)UITextField* inputTF;
@property (nonatomic,strong)UITextField* cheatTF;
@end

@implementation DynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nearbyDDS = [[NearbyDynamicDelegateAndDataSource alloc]init];
        _nearbyDDS.viewC = self;
        self.friendDDS = [[FriendDynamicDelegateAndDataSource alloc]init];
        _friendDDS.viewC = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIImageView * top = [[UIImageView alloc]initWithFrame:CGRectMake(90, 7, 140, 28)];
    top.image = [UIImage imageNamed:@"toubuhuakuaibeijing"];
    [self.view addSubview:top];
    top.userInteractionEnabled = YES;
    
    nearByB = [UIButton buttonWithType:UIButtonTypeCustom];
    nearByB.frame = CGRectMake(1, 1, 68, 26);
    [nearByB setTitle:@"附近动态" forState:UIControlStateNormal];
    nearByB.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [nearByB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nearByB addTarget:self action:@selector(showNearby) forControlEvents:UIControlEventTouchUpInside];
    [top addSubview:nearByB];
    
    friendB = [UIButton buttonWithType:UIButtonTypeCustom];
    friendB.frame = CGRectMake(71, 1, 68, 26);
    [friendB setTitle:@"好友动态" forState:UIControlStateNormal];
    friendB.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [friendB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friendB setBackgroundImage:[UIImage imageNamed:@"toubuhuakuaibtn"] forState:UIControlStateNormal];
    [friendB addTarget:self action:@selector(showfriend) forControlEvents:UIControlEventTouchUpInside];
    [top addSubview:friendB];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-93)];
    _tableV.delegate = self;
    _tableV.dataSource = self.nearbyDDS;
    [self.view addSubview:_tableV];
    _tableV.showsVerticalScrollIndicator=NO;
    
    
    UIImageView* headV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220.5)];
    headV.image = [UIImage imageNamed:@"morenbeijing"];
    self.tableV.tableHeaderView = headV;
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(170, 190, 60, 20)];
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.text = [DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameL.frame = CGRectMake(220-size.width, 190, size.width, 20);
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    [headV addSubview:nameL];
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 160, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [headV addSubview:photoIV];
    
    self.footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _footAct.backgroundColor = [UIColor redColor];
    self.footAct= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    _footAct.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_footV addSubview:_footAct];
    UILabel* loadmoveL = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 20)];
    loadmoveL.text = @"加载更多";
    loadmoveL.textAlignment = NSTextAlignmentCenter;
    [_footV addSubview:loadmoveL];
    
    
	// Do any additional setup after loading the view.
    self.inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    _inputTF.borderStyle=UITextBorderStyleRoundedRect;
    UIToolbar* aToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 44)];
    aToolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*arb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didInput)];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithCustomView:_inputTF];
    arb.tintColor = [UIColor blackColor];
    aToolbar.items = @[rb,arb];
    
    self.cheatTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_cheatTF];
    _cheatTF.inputAccessoryView = aToolbar;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在发送，请稍后";
    
    [self reloadData];
    [hud show:YES];
}
-(void)showAlertView
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"加载失败，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
    [alert show];
}
-(void)viewWillAppear:(BOOL)animated
{
    _tableV.contentOffset = CGPointMake(0, 100);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)showNearby
{
    [self removeActionImageView];
    if (_tableV.dataSource != self.nearbyDDS) {
        [nearByB setBackgroundImage:nil forState:UIControlStateNormal];
        [nearByB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [friendB setBackgroundImage:[UIImage imageNamed:@"toubuhuakuaibtn"] forState:UIControlStateNormal];
        [friendB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tableV.dataSource = self.nearbyDDS;
        [_tableV reloadData];
        if (((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray.count == 0) {
            [self reloadData];
        }
    }
}
-(void)showfriend
{
    [self removeActionImageView];
    if (_tableV.dataSource != self.friendDDS) {
        [friendB setBackgroundImage:nil forState:UIControlStateNormal];
        [friendB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nearByB setBackgroundImage:[UIImage imageNamed:@"toubuhuakuaibtn"] forState:UIControlStateNormal];
        [nearByB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tableV.dataSource = self.friendDDS;
        [_tableV reloadData];
        if (((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray.count == 0) {
            [self reloadData];
        }
    }
}
-(void)updateSelfMassage
{
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)praise
{
    [self removeActionImageView];
}
-(void)assess
{
    [self removeActionImageView];
    [_cheatTF becomeFirstResponder];
}
-(void)reprint
{
    [self removeActionImageView];
    [_cheatTF becomeFirstResponder];
}
-(void)didInput
{
    [self keyBoardResign];
}
-(void)keyBoardResign
{
    [_inputTF resignFirstResponder];
    [_cheatTF resignFirstResponder];
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeActionImageView];
    [self keyBoardResign];    
}
#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self removeActionImageView];
    [self keyBoardResign];
    if (_tableV.contentOffset.y<0) {
        if (self.act == nil) {
            self.act= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
            _act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [_act startAnimating];
            [_tableV.tableHeaderView addSubview:_act];
        }
    }
    if (_tableV.contentSize.height>_tableV.frame.size.height+100) {
        if (_tableV.contentOffset.y>_tableV.contentSize.height-_tableV.frame.size.height-100) {
            if (_tableV.tableFooterView == nil) {
                _tableV.tableFooterView = _footV;
                
            }else{
                [_footAct startAnimating];
            }
        }
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self removeActionImageView];
    [self keyBoardResign];
    
    [UIView animateWithDuration:0.3 animations:^{
        _tableV.contentOffset = CGPointMake(0, 100);
    }];
    
    return NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //停止滑动
    if (_tableV.contentOffset.y<=100) {
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.contentOffset = CGPointMake(0, 100);
        }];
    }
    if (_tableV.contentSize.height>_tableV.frame.size.height+100) {
        if (_tableV.contentOffset.y>=_tableV.contentSize.height-_tableV.frame.size.height-130) {
            [_footAct stopAnimating];
            [UIView animateWithDuration:0.3 animations:^{
                _tableV.tableFooterView = nil;
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //停止回弹
    if (_tableV.contentOffset.y<=0) {
        [self reloadData];
    }
    if (_tableV.contentSize.height>_tableV.frame.size.height+100) {
        if (_tableV.contentOffset.y>=_tableV.contentSize.height-_tableV.frame.size.height) {
            [self loadMoreData];
        }
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //开始回弹
    NSLog(@"B%f==%f==%f",_tableV.contentSize.height,_tableV.frame.size.height,_tableV.contentOffset.y);
}
#pragma mark - cell button action
-(void)showButton:(UITableViewCell*)cell
{
    CGRect cellRect=[self.view convertRect:cell.frame fromView:_tableV];
    NSLog(@"%f",cellRect.size.height);
    if (_actionIV == nil) {
        self.actionIV = [[UIImageView alloc]initWithFrame:CGRectMake(280, cellRect.origin.y+cellRect.size.height - 10, 0, 44)];
        _actionIV.userInteractionEnabled = YES;
        _actionIV.image = [UIImage imageNamed:@"tanchuanniu_bg"];
        [self.view addSubview:_actionIV];
        
        praiseB = [UIButton buttonWithType:UIButtonTypeCustom];
        praiseB.frame = CGRectMake(0, 6,0, 31);
        [praiseB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [praiseB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [praiseB setTitle:@"赞" forState:UIControlStateNormal];
        [praiseB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [praiseB addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:praiseB];
        
        
        assessB = [UIButton buttonWithType:UIButtonTypeCustom];
        assessB.frame = CGRectMake(0, 6, 0,31);
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [assessB setTitle:@"评论" forState:UIControlStateNormal];
        [assessB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [assessB addTarget:self action:@selector(assess) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:assessB];
    }else{
        if (cell != _mycell) {
            [self removeActionImageView];
            _actionIV.frame = CGRectMake(280, cellRect.origin.y+cellRect.size.height - 10, 0, 44);
            [self.view addSubview:_actionIV];
            self.mycell = cell;
        }else{
            [self removeActionImageView];
        }
    }
    if (_tableV.dataSource == self.friendDDS) {
        if (reprintB == nil) {
            reprintB = [UIButton buttonWithType:UIButtonTypeCustom];
            reprintB.frame = CGRectMake(0, 6, 0, 31);
            [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
            [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
            [reprintB setTitle:@"转载" forState:UIControlStateNormal];
            [reprintB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [reprintB addTarget:self action:@selector(reprint) forControlEvents:UIControlEventTouchUpInside];
        }
        if (reprintB.superview==nil) {
            [_actionIV addSubview:reprintB];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _actionIV.frame = CGRectMake( 108, cellRect.origin.y+cellRect.size.height - 10, 182, 44);
            praiseB.frame = CGRectMake(6, 6, 53, 31);
            assessB.frame = CGRectMake(65, 6, 53, 31);
            reprintB.frame = CGRectMake(124, 6, 53, 31);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _actionIV.frame = CGRectMake( 157, cellRect.origin.y+cellRect.size.height - 10, 123, 44);
            praiseB.frame = CGRectMake(6, 6, 53, 31);
            assessB.frame = CGRectMake(65, 6, 53, 31);
        }];
    }
}
-(void)removeActionImageView
{
        praiseB.frame = CGRectMake(0, 6, 0, 31);
        assessB.frame = CGRectMake(0, 6, 0,31);
        reprintB.frame = CGRectMake(0, 6, 0, 31);
        [_actionIV removeFromSuperview];
        self.mycell = nil;
    
}
#pragma mark - reload and loadmore
-(void)reloadData
{
    [(DelegateAndDataSource*)self.tableV.dataSource reloadDataSuccess:^{
        [self.tableV reloadData];
        [_act stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.contentOffset = CGPointMake(0, 100);
        } completion:^(BOOL finished) {
            if (finished) {
                self.act = nil;
            }
        }];
        [hud hide:YES];
    } failure:^{
        [self showAlertView];
        [_act stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.contentOffset = CGPointMake(0, 100);
        } completion:^(BOOL finished) {
            if (finished) {
                self.act = nil;
            }
        }];
        [hud hide:YES];
    }];
}
-(void)loadMoreData
{
    [(DelegateAndDataSource*)self.tableV.dataSource loadMoreDataSuccess:^{
        [self.tableV reloadData];
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
        [hud hide:YES];
    } failure:^{
        [self showAlertView];
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
        [hud hide:YES];
    }];
}
@end
