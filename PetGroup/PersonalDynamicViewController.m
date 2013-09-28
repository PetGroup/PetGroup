//
//  PersonalDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonalDynamicViewController.h"
#import "CustomTabBar.h"
#import "DynamicCell.h"
#import "MBProgressHUD.h"
#import "EGOImageButton.h"
#import "PersonalDynamicCell.h"
#import "EGOImageView.h"
#import "UIExpandingTextView.h"
#import "TempData.h"
#import "ReplyComment.h"
#import "MyDynamicDelegateAndDataSource.h"
#import "HeightCalculate.h"
#import "ReplyListViewController.h"
#import "EditDynamicViewController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
@interface PersonalDynamicViewController ()<MBProgressHUDDelegate,UIExpandingTextViewDelegate>
{
    UIButton * assessB;
    UIButton * reprintB;
    
    MBProgressHUD * hud;
    
    int assessOrPraise;
    
    UIImageView * inputbg;
    UIView * inPutView;
    BOOL request;
    UIButton *replyB;
}
@property (nonatomic,retain)UIView* headV;
@property (nonatomic,strong)UIView* footV;
@property (nonatomic,strong)UIActivityIndicatorView * act;
@property (nonatomic,strong)UIActivityIndicatorView * footAct;
@property (nonatomic,strong)UIImageView*  actionIV;
@property (nonatomic,weak)PersonalDynamicCell* mycell;
@property (nonatomic,weak)id theID;
@property (nonatomic,strong)UIExpandingTextView* inputTF;
@end

@implementation PersonalDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appDel = [[UIApplication sharedApplication] delegate];
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

    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"个人动态";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.dataSource isKindOfClass:[MyDynamicDelegateAndDataSource class]]) {
        UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
        publishButton.frame=CGRectMake(278, 3, 35, 33);
        [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
        [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:publishButton];
    }
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    _tableV.delegate = self;
    _tableV.dataSource = self.dataSource;
    [self.view addSubview:_tableV];
    _tableV.showsVerticalScrollIndicator=NO;
   
    self.headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 240.5)];
    _headV.backgroundColor = [UIColor whiteColor];
    self.tableV.tableHeaderView = _headV;
    
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220.5)];
    imageV.image = [UIImage imageNamed:@"morenbeijing"];
    imageV.userInteractionEnabled = YES;
    [_headV addSubview:imageV];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(170, 190, 60, 20)];
    nameL.font = [UIFont systemFontOfSize:16];
    
    nameL.text = self.userName;
    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameL.frame = CGRectMake(220-size.width, 190, size.width, 20);
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    [imageV addSubview:nameL];

    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 160, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [imageV addSubview:photoIV];
    photoIV.userInteractionEnabled = YES;
    
    EGOImageView* headIV = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
    headIV.frame = CGRectMake(5, 5, 70, 70);
    headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.HeadImageID]];
    [photoIV addSubview:headIV];
    
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
    hud.labelText = @"正在加载，请稍后";
    
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
    if ([self.dataSource isKindOfClass:[MyDynamicDelegateAndDataSource class]]) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *dicArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:NewComment]];
        if (dicArray.count>0) {
            _headV.frame = CGRectMake(0, 0, 320, 280.5);
            if (!replyB) {
                replyB = [UIButton buttonWithType:UIButtonTypeCustom];
                [replyB setBackgroundImage:[UIImage imageNamed:@"notiBG2"] forState:UIControlStateNormal];
                [replyB setBackgroundImage:[UIImage imageNamed:@"notiBG"] forState:UIControlStateHighlighted];
                [replyB addTarget:self action:@selector(kanpinlun) forControlEvents:UIControlEventTouchUpInside];
            }
            replyB.frame = CGRectMake(100, 245.5, 120, 30);
            [replyB setTitle:[NSString stringWithFormat:@"%d条新消息",dicArray.count] forState:UIControlStateNormal];
            replyB.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [_headV addSubview:replyB];
        }else{
            _headV.frame = CGRectMake(0, 0, 320, 240.5);
            [replyB removeFromSuperview];
        }
        _tableV.tableHeaderView = _headV;
        self.appDel.xmppHelper.commentDelegate = self;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.dataSource isKindOfClass:[MyDynamicDelegateAndDataSource class]]) {
        MLNavigationController* nav = self.customTabBarController.viewControllers[0];
        self.appDel.xmppHelper.commentDelegate = nav.viewControllers[0];
    }
}
-(void)newCommentReceived:(NSDictionary *)theDict
{
    
    [self requestOneStateByStateID:[theDict objectForKey:@"dynamicID"] WithDict:theDict];
    
}

-(void)requestOneStateByStateID:(NSString *)theID WithDict:(NSDictionary *)theDict
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * locationDict = [NSMutableDictionary dictionary];
    [locationDict setObject:theID forKey:@"stateid"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"findOneState" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        NSLog(@"rrrrrrrr:%@",recDict);
        
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary * mydynamicDict = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:MyDynamic]];
        if (!mydynamicDict) {
            mydynamicDict = [NSMutableDictionary dictionary];
        }
        [mydynamicDict setObject:recDict forKey:theID];
        
        
        NSMutableArray * replyArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:NewComment]];
        if (!replyArray) {
            replyArray = [NSMutableArray array];
        }
        NSMutableDictionary * replyDict = [NSMutableDictionary dictionary];
        [replyDict setObject:[theDict objectForKey:@"sender"] forKey:@"username"];
        [replyDict setObject:[theDict objectForKey:@"msg"] forKey:@"replyContent"];
        [replyDict setObject:theID forKey:@"dynamicID"];
        [replyDict setObject:[theDict objectForKey:@"time"] forKey:@"time"];
        [replyDict setObject:[theDict objectForKey:@"msgType"] forKey:@"theType"];
        [replyDict setObject:[theDict objectForKey:@"fromNickname"] forKey:@"fromNickname"];
        [replyDict setObject:[theDict objectForKey:@"fromHeadImg"] forKey:@"fromHeadImg"];
        [replyArray insertObject:replyDict atIndex:0];
        [userDefault setObject:replyArray forKey:NewComment];
        [userDefault setObject:mydynamicDict forKey:MyDynamic];
        [userDefault synchronize];
        
        
        if (!replyB) {
            replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [replyB setBackgroundImage:[UIImage imageNamed:@"notiBG2"] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"notiBG"] forState:UIControlStateHighlighted];
        [replyB addTarget:self action:@selector(kanpinlun) forControlEvents:UIControlEventTouchUpInside];
        replyB.frame = CGRectMake(100, 245.5, 120, 30);
        replyB.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_headV addSubview:replyB];
        _headV.frame = CGRectMake(0, 0, 320, 280.5);
        _tableV.tableHeaderView = _headV;
        [replyB setTitle:[NSString stringWithFormat:@"%d条新消息",replyArray.count] forState:UIControlStateNormal];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)updateSelfMassage
{
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    editVC.viewC = self;
    [self.navigationController pushViewController:editVC animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)kanpinlun
{
    ReplyListViewController* rel = [[ReplyListViewController alloc]init];
    [self.navigationController pushViewController:rel animated:YES];
}
-(void)backButton:(UIButton*)button
{
    [hud hide:YES];
    [self keyBoardResign];
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
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
                [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"petuserId"];
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
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    Reply* rep = [[Reply alloc]initWithDictionary:dic];
                    [self.mycell.dynamic.replyViews addObject:rep];
                    NSString* repS = [NSString stringWithFormat:@"%@:%@",rep.petUser.nickName,rep.msg];
                    CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:210];
                    self.mycell.dynamic.rowHigh += (size.height+5);
                    [self.tableV reloadData];
                    self.mycell = nil;
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
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
                    [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userid"];
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
                    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [hud hide:YES];
                        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        PersonalDynamic* b = [[PersonalDynamic alloc]initWithNSDictionary:dic];
                        if ([self.dataSource isKindOfClass:[MyDynamicDelegateAndDataSource class]]) {
                            [((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray insertObject:b atIndex:0];
                        }
                        [self.tableV reloadData];
                        self.mycell = nil;
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [hud hide:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                        [alert show];
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
                [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"commentUserid"];
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
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    ReplyComment* repcom = [[ReplyComment alloc]initWithDictionary:dic];
                    if ([self.theID isKindOfClass:[Reply class]]) {
                        [((Reply*)self.theID).replyComments addObject:repcom];
                        NSString* repS = [NSString stringWithFormat:@"%@回复%@:%@",repcom.commentUserView.nickName,repcom.replyUserView.nickName,repcom.commentsMsg];
                        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:210];
                        self.mycell.dynamic.rowHigh += (size.height+5);
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
                        NSString* repS = [NSString stringWithFormat:@"%@回复%@:%@",repcom.commentUserView.nickName,repcom.replyUserView.nickName,repcom.commentsMsg];
                        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:210];
                        self.mycell.dynamic.rowHigh += (size.height+5);
                        [self.tableV reloadData];
                    }
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    self.mycell = nil;
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
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
{
    //开始拖拽
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self removeActionImageView];
    self.mycell = nil;
    [self keyBoardResign];
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
#pragma mark - cell button action
-(void)showButton:(PersonalDynamicCell*)cell
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
        _actionIV.frame = CGRectMake(280, cellRect.origin.y+cell.moveB.frame.origin.y-5, 0, 44);
        [self.view addSubview:_actionIV];
        self.mycell = cell;
        [UIView animateWithDuration:0.3 animations:^{
            _actionIV.frame = CGRectMake( 158, cellRect.origin.y+cell.moveB.frame.origin.y-5, 127, 44);
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
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [((DelegateAndDataSource*)self.tableV.dataSource).dataSourceArray removeObject:dyn];
        [self.tableV reloadData];
    }];
}
-(void)recalledreply:(id)theID cell:(PersonalDynamicCell*)cell//回复评论
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
    request = YES;
    [(DelegateAndDataSource*)self.tableV.dataSource reloadDataSuccess:^{
        [self.tableV reloadData];
        [_act stopAnimating];
        [self.act stopAnimating];
        request = NO;
        [hud hide:YES];
    } failure:^{
        [self showAlertView];
        [_act stopAnimating];
        [self.act stopAnimating];
        request = NO;
        [hud hide:YES];
    }];
}
-(void)loadMoreData
{
    request = YES;
    [(DelegateAndDataSource*)self.tableV.dataSource loadMoreDataSuccess:^{
        [self.tableV reloadData];
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
        request = NO;
        [hud hide:YES];
    } failure:^{
        [self showAlertView];
        [_footAct stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _tableV.tableFooterView = nil;
        }];
        request = NO;
        [hud hide:YES];
    }];
}
@end
