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
#import "EGOImageButton.h"
#import "DynamicCell.h"
#import "EGOCache.h"
#import "UIExpandingTextView.h"
#import "TempData.h"
#import "ReplyComment.h"
#import "PersonalDynamicViewController.h"
#import "MyDynamicDelegateAndDataSource.h"

@interface DynamicViewController ()<MBProgressHUDDelegate,UIExpandingTextViewDelegate>
{
    UIButton* nearByB;
    UIButton* friendB;
    
    UIButton * assessB;
    UIButton * reprintB;
    
    MBProgressHUD * hud;
    
    int assessOrPraise;
    
    UIImageView * inputbg;
    UIView * inPutView;
    
    UILabel* nameL;
    EGOImageButton* headIV;
}
@property (nonatomic,strong)UIView* footV;
@property (nonatomic,strong)NearbyDynamicDelegateAndDataSource* nearbyDDS;
@property (nonatomic,strong)FriendDynamicDelegateAndDataSource* friendDDS;
@property (nonatomic,strong)UIActivityIndicatorView * act;
@property (nonatomic,strong)UIActivityIndicatorView * footAct;
@property (nonatomic,strong)UIImageView*  actionIV;
@property (nonatomic,weak)DynamicCell* mycell;
@property (nonatomic,weak)id theID;
@property (nonatomic,strong)UIExpandingTextView* inputTF;
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
    _tableV.contentOffset = CGPointMake(0, 100);
    
    
    UIImageView* headV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 240.5)];
    headV.image = [UIImage imageNamed:@"morenbeijing"];
    self.tableV.tableHeaderView = headV;
    headV.userInteractionEnabled = YES;
    
    nameL = [[UILabel alloc]initWithFrame:CGRectMake(170, 190, 60, 20)];
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    [headV addSubview:nameL];
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 160, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [headV addSubview:photoIV];
    photoIV.userInteractionEnabled = YES;
    
    headIV = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
    headIV.frame = CGRectMake(5, 5, 70, 70);
    [photoIV addSubview:headIV];
    [headIV addTarget:self action:@selector(headAct) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    if ([[TempData sharedInstance] ifPanned]) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
    else
    {
        [self.customTabBarController hidesTabBar:NO animated:YES];
        [[TempData sharedInstance] Panned:YES];
    }
    if (self.tableV.contentOffset.y<100) {
        self.tableV.contentOffset = CGPointMake(0, 100);
    }
    
    nameL.text = [DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameL.frame = CGRectMake(220-size.width, 190, size.width, 20);
    NSString * imageID = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",imageID]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)headAct
{
    PersonalDynamicViewController * PDVC = [[PersonalDynamicViewController alloc] init];
    MyDynamicDelegateAndDataSource* MDDDS = [[MyDynamicDelegateAndDataSource alloc]init];
    MDDDS.viewC = PDVC;
    PDVC.dataSource = MDDDS;
    [self.navigationController pushViewController:PDVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)showNearby
{
    [self removeActionImageView];
    self.mycell = nil;
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
        self.tableV.contentOffset = CGPointMake(0, 100);
    }
}
-(void)showfriend
{
    [self removeActionImageView];
    self.mycell = nil;
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
        self.tableV.contentOffset = CGPointMake(0, 100);
    }
}
-(void)updateSelfMassage
{
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    editVC.viewC = self;
    [self.navigationController pushViewController:editVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
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
                [hud show:YES];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    Reply* rep = [[Reply alloc]initWithDictionary:dic];
                    [self.mycell.dynamic.replyViews addObject:rep];
                    self.mycell.dynamic.rowHigh+=28;
                    [self.tableV reloadData];
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
                    [hud show:YES];
                    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [hud hide:YES];
                        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        Dynamic* b = [[Dynamic alloc]initWithNSDictionary:dic];
                        [((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray insertObject:b atIndex:0];
                        [self.tableV reloadData];
                        self.mycell = nil;
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
                [hud show:YES];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    ReplyComment* repcom = [[ReplyComment alloc]initWithDictionary:dic];
                    if ([self.theID isKindOfClass:[Reply class]]) {
                        [((Reply*)self.theID).replyComments addObject:repcom];
                        self.mycell.dynamic.rowHigh+=28;
                        [self.tableV reloadData];
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
                        [self.tableV reloadData];
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

	
    [UIView commitAnimations];
    NSLog(@"%f",self.view.frame.size.height);
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeActionImageView];
    self.mycell = nil;
    [self keyBoardResign];    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DelegateAndDataSource * dad  = (DelegateAndDataSource *)self.tableV.dataSource;
    Dynamic*dyn = dad.dataSourceArray[indexPath.row];
    return dyn.rowHigh;
}
#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{//开始拖拽
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self removeActionImageView];
    self.mycell = nil;
    [self keyBoardResign];
    if (scrollView.contentSize.height<_tableV.frame.size.height+100) {
        scrollView.contentSize = CGSizeMake(320, _tableV.frame.size.height+100);
        scrollView.contentOffset = CGPointMake(0, 100);
    }
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
    self.mycell = nil;
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
    //停止减速
    if (_tableV.contentOffset.y<100&&_tableV.contentOffset.y>0) {
        [UIView animateWithDuration:0.3 animations:^{
             _tableV.contentOffset = CGPointMake(0, 100);
        }];
    }
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
    //开始减速
}
#pragma mark - cell button action
-(void)showButton:(DynamicCell*)cell
{
    CGRect cellRect=[self.view convertRect:cell.frame fromView:_tableV];
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
-(void)deleteDynamic:(Dynamic*)dyn
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"" forKey:@"transmitUrl"];
    [params setObject:dyn.transmitMsg forKey:@"transmitMsg"];
    [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"submitTime"];
    [params setObject:[NSString stringWithFormat:@"%d", dyn.ifTransmitMsg] forKey:@"ifTransmitMsg"];
    [params setObject:dyn.msg forKey:@"msg"];
    [params setObject:dyn.imageID forKey:@"imgid"];
    [params setObject:dyn.petUser.userId forKey:@"userid"];
    [params setObject:dyn.dynamicID forKey:@"userStateId"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"delUserState" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray removeObject:dyn];
        [self.tableV reloadData];
    }];
}
-(void)recalledreply:(id)theID cell:(DynamicCell*)cell//回复评论
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
