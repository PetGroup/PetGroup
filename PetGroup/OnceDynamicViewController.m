//
//  OnceDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OnceDynamicViewController.h"
#import "MJRefresh.h"
#import "TempData.h"
#import "DetailsDynamicCell.h"
#import "UIExpandingTextView.h"
#import "BHExpandingTextView.h"
#import "Reply.h"
#import "ReplyCell.h"
#import "ArticleViewController.h"
#import "PhotoViewController.h"
#import "PersonDetailViewController.h"
#import "SomeOneDynamicViewController.h"
@interface OnceDynamicViewController ()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIExpandingTextViewDelegate,BHExpandingTextViewDelegate,HPGrowingTextViewDelegate,MJRefreshBaseViewDelegate>
{
    UIImageView* bottomIV;
    int assessOrPraise;
    UIImageView * inputbg;
    UIView * inPutView;
    BOOL request;
}
@property (strong,nonatomic) NSMutableArray* zanPonsenArrey;
@property (strong,nonatomic) NSMutableString* zanPonsen;
@property (strong,nonatomic) UITableView * tableV;
@property (strong,nonatomic) MJRefreshFooterView * footer;
@property (strong,nonatomic) NSMutableArray * resultArray;
@property (strong,nonatomic) UIActionSheet* delAction;
@property (strong,nonatomic) UIActionSheet* reportAction;
@property (strong,nonatomic) UIActionSheet* delReplyAction;
@property (strong,nonatomic) UIActionSheet* delReplyOrReplyAction;
@property (strong,nonatomic) UIAlertView* delReplyAlert;
@property (strong,nonatomic) UIAlertView* delAlert;
@property (strong,nonatomic) UIAlertView* reportAlert;
@property (nonatomic,strong)HPGrowingTextView* inputTF;
@property (assign,nonatomic) int pageNo;
@property (nonatomic,retain) NSString* pid;
@property (nonatomic,retain) NSString* puserid;
@property (nonatomic,retain) NSIndexPath* indexPath;
@end

@implementation OnceDynamicViewController
- (void)dealloc
{
    [_footer free];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.zanPonsenArrey = [NSMutableArray array];
        self.needRequestDyn = NO;
        self.resultArray = [[NSMutableArray alloc]init];
        self.onceDynamicViewControllerStyle = OnceDynamicViewControllerStyleNome;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    if (self.dynamic.countZan>0) {
        self.zanPonsen = [NSMutableString stringWithFormat:@"%d 人赞过这条动态",self.dynamic.countZan];
        if (self.dynamic.ifIZaned) {
            self.zanPonsen = [NSMutableString stringWithFormat:@"我等%d 人赞过这条动态",self.dynamic.countZan];
        }
    }
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    diffH = [Common diffHeight:self];
    
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *moveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moveButton.frame=CGRectMake(278, 3+diffH, 35, 33);
    [moveButton setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
    [moveButton addTarget:self action:@selector(showActionShoot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveButton];

    
    if (self.needRequestDyn) {
        [self getStateByID];
    }
    
    self.footer = [[MJRefreshFooterView alloc]init];
    _footer.delegate = self;
    _footer.scrollView = self.tableV;
    
    bottomIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    bottomIV.image = [UIImage imageNamed:@"dibuanniu_bg"];
    bottomIV.userInteractionEnabled = YES;
    [self.view addSubview:bottomIV];
    
    UIButton * zanB = [UIButton buttonWithType:UIButtonTypeCustom];
    zanB.frame = CGRectMake(0, 0, 320/3, 49);
    if (self.dynamic.ifIZaned) {
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zaned_normal"] forState:UIControlStateNormal];
    }else{
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zan_normal"] forState:UIControlStateNormal];
    }
    [zanB addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:zanB];
    
    UIButton * replyB = [UIButton buttonWithType:UIButtonTypeCustom];
    replyB.frame = CGRectMake(320/3, 0, 320/3, 49);
    [replyB setBackgroundImage:[UIImage imageNamed:@"bottom_pl_normal"] forState:UIControlStateNormal];
    [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:replyB];
    
    UIButton * zhuanfaB = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuanfaB.frame = CGRectMake(640/3, 0, 320/3, 49);
    [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"bottom_zf_normal"] forState:UIControlStateNormal];
    [zhuanfaB addTarget:self action:@selector(zhuanfaAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:zhuanfaB];
    
    if (_needRequestDyn) {
        bottomIV.hidden = YES;
    }
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    
	self.inputTF = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    self.inputTF.isScrollable = NO;
    self.inputTF.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.inputTF.minNumberOfLines = 1;
	self.inputTF.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.inputTF.returnKeyType = UIReturnKeySend; //just as an example
	self.inputTF.font = [UIFont systemFontOfSize:15.0f];
	self.inputTF.delegate = self;
    self.inputTF.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.inputTF.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:inPutView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_input.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(10, 10, 300, 35);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"inputbg.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, inPutView.frame.size.width, inPutView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.inputTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [inPutView addSubview:imageView];

    [inPutView addSubview:entryImageView];
    [inPutView addSubview:self.inputTF];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        [self loadZanList];
    }
    [self reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    switch (self.onceDynamicViewControllerStyle) {
        case OnceDynamicViewControllerStyleNome:{
            
        }break;
        case OnceDynamicViewControllerStyleReply:{
            [self replyAction];
        }break;
        case OnceDynamicViewControllerStyleZhuanfa:{
            [self zhuanfaAction];
        }break;
        default:
            break;
    }
}
-(void)getStateByID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getUserStateById" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        bottomIV.hidden = NO;
        self.dynamic = [[Dynamic alloc] initWithNSDictionary:responseObject];
        [self.tableV reloadData];
        if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
            [self loadZanList];
        }else {
            if (self.dynamic.countZan>0) {
                self.zanPonsen = [NSMutableString stringWithFormat:@"%d 人赞过这条动态",self.dynamic.countZan];
                if (self.dynamic.ifIZaned) {
                    self.zanPonsen = [NSMutableString stringWithFormat:@"我等%d 人赞过这条动态",self.dynamic.countZan];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:nil message:@"该动态不存在或已被删除" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        alertV.tag = 99;
        [alertV show];
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)zanAction:(UIButton*)button
{
    if (!self.dynamic.ifIZaned) {
        self.dynamic.ifIZaned = !self.dynamic.ifIZaned;
        self.dynamic.countZan++;
        [button setBackgroundImage:[UIImage imageNamed:@"bottom_zaned_normal"] forState:UIControlStateNormal];
        if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
            [self.zanPonsenArrey insertObject:@"我" atIndex:0];
            if (self.zanPonsenArrey.count>0&&self.zanPonsenArrey.count<5) {
                self.zanPonsen = [[NSMutableString alloc]init];
                for (NSString* str in self.zanPonsenArrey) {
                    [self.zanPonsen appendString:str];
                    if (![str isEqualToString:[self.zanPonsenArrey lastObject]]) {
                        [self.zanPonsen appendFormat:@","];
                    }
                }
                [self.zanPonsen appendFormat:@"\t赞过这条动态"];
            }
            if (self.zanPonsenArrey.count>=5) {
                self.zanPonsen = [[NSMutableString alloc]init];
                for (int i = 0; i<5 ;i++) {
                    [self.zanPonsen appendString:self.zanPonsenArrey[i]];
                    if (i!=4) {
                        [self.zanPonsen appendFormat:@","];
                    }
                }
                [self.zanPonsen appendFormat:@"\t等%d位好友赞过这条动态",self.zanPonsenArrey.count];
            }
        }else
            self.zanPonsen = [NSMutableString stringWithFormat:@"我等%d 人赞过这条动态",self.dynamic.countZan];
    }else{
        self.dynamic.ifIZaned = !self.dynamic.ifIZaned;
        self.dynamic.countZan--;
        [button setBackgroundImage:[UIImage imageNamed:@"bottom_zan_normal"] forState:UIControlStateNormal];
        if (self.dynamic.countZan==0) {
            self.zanPonsen = nil;
            [self.zanPonsenArrey removeObject:@"我"];
        }else
        {
            if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
                [self.zanPonsenArrey removeObject:@"我"];
                if (self.zanPonsenArrey.count>0&&self.zanPonsenArrey.count<5) {
                    self.zanPonsen = [[NSMutableString alloc]init];
                    for (NSString* str in self.zanPonsenArrey) {
                        [self.zanPonsen appendString:str];
                        if (![str isEqualToString:[self.zanPonsenArrey lastObject]]) {
                            [self.zanPonsen appendFormat:@","];
                        }
                    }
                    [self.zanPonsen appendFormat:@"\t赞过这条动态"];
                }
                if (self.zanPonsenArrey.count>=5) {
                    self.zanPonsen = [[NSMutableString alloc]init];
                    for (int i = 0; i<5 ;i++) {
                        [self.zanPonsen appendString:self.zanPonsenArrey[i]];
                        if (i!=4) {
                            [self.zanPonsen appendFormat:@","];
                        }
                    }
                    [self.zanPonsen appendFormat:@"\t等%d位好友赞过这条动态",self.zanPonsenArrey.count];
                }
            }else
                self.zanPonsen = [NSMutableString stringWithFormat:@"%d 人赞过这条动态",self.dynamic.countZan];
        }
    }
    [self.tableV reloadData];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListJustReload)]) {
        [self.delegate dynamicListJustReload];
    }
    if (request) {
        return;
    }
    if (self.dynamic.ifIZaned) {
        request = YES;
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:self.dynamic.dynamicID forKey:@"srcid"];
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
            request = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            request = NO;
        }];
    }else{
        request = YES;
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:self.dynamic.dynamicID forKey:@"srcid"];
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
            request = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            request = NO;
        }];
    }
}
-(void)replyAction//评论
{
    self.pid = @"";
    self.puserid = @"";
    self.inputTF.text = @"";
    [_inputTF becomeFirstResponder];
    assessOrPraise = 1;
    self.inputTF.placeholder = [NSString stringWithFormat:@"评论:%@",self.dynamic.nickName];
//    NSIndexPath*index = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableV scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)zhuanfaAction//转发
{
    self.inputTF.text = @"";
    [_inputTF becomeFirstResponder];
    assessOrPraise = 2;
    self.inputTF.placeholder = @"转发至我的动态";
//    NSIndexPath*index = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableV scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)didInput
{
    switch (assessOrPraise) {
        case 1:{
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:self.inputTF.text forKey:@"msg"];
            [params setObject:self.pid forKey:@"pid"];
            [params setObject:self.puserid forKey:@"puserid"];
            [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
            [body setObject:@"service.uri.pet_states" forKey:@"service"];
            [body setObject:@"1" forKey:@"channel"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
            [body setObject:@"iphone" forKey:@"imei"];
            [body setObject:params forKey:@"params"];
            [body setObject:@"addReply" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
                dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString*dateS = [dateF stringFromDate:[NSDate date]];
                NSDictionary* d = [DataStoreManager queryMyInfo];
                NSString* replyid = responseObject;
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setObject:replyid forKey:@"id"];
                [dic setObject:[d objectForKey:@"nickname"] forKey:@"nickname"];
                [dic setObject:[d objectForKey:@"username"] forKey:@"username"];
                [dic setObject:[d objectForKey:@"img"] forKey:@"userImage"];
                [dic setObject:[params objectForKey:@"msg"] forKey:@"msg"];
                [dic setObject:[d objectForKey:@"id"] forKey:@"userid"];
                [dic setObject:dateS forKey:@"ct"];
                [dic setObject:self.dynamic.dynamicID forKey:@"stateid"];
                [dic setObject:self.pid forKey:@"pid"];
                [dic setObject:self.puserid forKey:@"puserid"];
                Reply* reply = [[Reply alloc]initWithDictionary:dic];
                [self.resultArray addObject:reply];
                [self.tableV reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if ([[error domain] isEqualToString:@"noEntity"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败，可能动态已经被删除了" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }break;
        case 2:{
            //转发
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:@"" forKey:@"transmitUrl"];
            if (self.inputTF.text.length>0) {
                [params setObject:self.inputTF.text forKey:@"transmitMsg"];
            }else{
                [params setObject:@"转发" forKey:@"transmitMsg"];
            }
            [params setObject:@"true" forKey:@"ifTransmitMsg"];
            [params setObject:self.dynamic.msg.string forKey:@"msg"];
            if (self.dynamic.imageID) {
                [params setObject:self.dynamic.imageID forKey:@"imgid"];
            }
            if (self.dynamic.transmitUrl) {
                [params setObject:self.dynamic.transmitUrl forKey:@"transmitUrl"];
            }
            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
            [body setObject:@"service.uri.pet_states" forKey:@"service"];
            [body setObject:@"1" forKey:@"channel"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
            [body setObject:@"iphone" forKey:@"imei"];
            [body setObject:params forKey:@"params"];
            [body setObject:@"addUserState" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
                dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString*dateS = [dateF stringFromDate:[NSDate date]];
                NSDictionary* d = [DataStoreManager queryMyInfo];
                NSString* dynamicid = responseObject;
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setObject:dynamicid forKey:@"id"];
                [dic setObject:[d objectForKey:@"nickname"] forKey:@"nickname"];
                [dic setObject:[d objectForKey:@"username"] forKey:@"username"];
                [dic setObject:[d objectForKey:@"img"] forKey:@"userImage"];
                [dic setObject:@"1" forKey:@"ifTransmitMsg"];
                if (self.dynamic.imageID) {
                    [dic setObject:self.dynamic.imageID forKey:@"imgid"];
                }
                [dic setObject:self.dynamic.msg.string forKey:@"msg"];
                [dic setObject:[d objectForKey:@"id"] forKey:@"userid"];
                [dic setObject:dateS forKey:@"ct"];
                if (self.dynamic.transmitUrl) {
                    [dic setObject:self.dynamic.transmitUrl forKey:@"transmitUrl"];
                }
                [dic setObject:@"3" forKey:@"state"];
                [dic setObject:@"0" forKey:@"reportTimes"];
                if ([params objectForKey:@"transmitMsg"]) {
                    [dic setObject:[params objectForKey:@"transmitMsg"] forKey:@"transmitMsg"];
                }
                [dic setObject:@"0" forKey:@"totalPat"];
                [dic setObject:@"0" forKey:@"didIpat"];
                Dynamic* dynamic = [[Dynamic alloc]initWithNSDictionary:dic];
                if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListAddOneDynamic:)]) {
                    [self.delegate dynamicListAddOneDynamic:dynamic];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if ([[error domain] isEqualToString:@"noEntity"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }break;
        case 3:{
            
        }break;
        default:
            break;
    }
}
-(void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showActionShoot
{
    if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        self.delAction = [[UIActionSheet alloc]initWithTitle:@"您要做什么?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [_delAction showInView:self.view];
    }else{
        self.reportAction = [[UIActionSheet alloc]initWithTitle:@"您要做什么?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles: nil];
        [_reportAction showInView:self.view];
    }
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData];
    }
}
#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        if (self.zanPonsen) {
            return 1;
        }else{
            return 0;
        }
        
    }else{
        return self.resultArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"Cell";
        DetailsDynamicCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[DetailsDynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.dynamic  = self.dynamic;
        
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellIdentifier = @"zanCell";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
        }
        CGSize size = [self.zanPonsen sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        cell.textLabel.frame = CGRectMake(10, 10, 300, size.height);
        cell.textLabel.text = self.zanPonsen;
        return cell;
    }else {
        static NSString *cellIdentifier = @"replyCell";
        ReplyCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
        cell.reply = self.resultArray[indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [DetailsDynamicCell heightForRowWithDynamic:self.dynamic];
    }else if(indexPath.section == 1){
        CGSize size = [self.zanPonsen sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+20;
    }else{
        return [ReplyCell heightForRowWithDynamic:self.resultArray[indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inputTF.isFirstResponder) {
        [_inputTF resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [_tableV setFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    if (indexPath.section == 0) {
        if (self.dynamic.transmitUrl&&![self.dynamic.transmitUrl isEqualToString:@""]) {
            NSMutableString* noteId = [NSMutableString  stringWithString:self.dynamic.transmitUrl];
            [noteId deleteCharactersInRange:[noteId rangeOfString:@"bbsNoteId_"]];
            NSLog(@"%@",noteId);
            ArticleViewController * articleVC = [[ArticleViewController alloc]init];
            articleVC.articleID = noteId;
            [self.navigationController pushViewController:articleVC animated:YES];
        }
        return;
    }
    if (indexPath.section == 1) {
        return;
    }
    if ([((Reply*)self.resultArray[indexPath.row]).userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        self.indexPath = indexPath;
        self.delReplyAction = [[UIActionSheet alloc]initWithTitle:@"您要做什么?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [_delReplyAction showInView:self.view];
        return;
    }
    if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]&&![((Reply*)self.resultArray[indexPath.row]).userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        self.indexPath = indexPath;
        self.delReplyOrReplyAction = [[UIActionSheet alloc]initWithTitle:@"您要做什么?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复" ,nil];
        [_delReplyOrReplyAction showInView:self.view];
        return;
    }
    [self replyOneReplyWithIndexPath:indexPath];
}
-(void)replyOneReplyWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableV cellForRowAtIndexPath:indexPath];
    NSLog(@"cell_Frame:%f,%f,%f,%f;self view frame height:%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height,self.view.frame.size.height);
//    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.origin.y, 20, 20)];
//    [uu setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:uu];
//    return;
//    [_tableV setFrame:CGRectMake(0, -253, 320, self.view.frame.size.height-44-diffH)];
//    if (cell.frame.origin.y+44+diffH>self.view.frame.size.height-253) {
//        [UIView animateWithDuration:0.3 animations:^{
//            [_tableV setFrame:CGRectMake(0, -(cell.frame.origin.y+44+diffH-253), 320, self.view.frame.size.height-93-diffH)];
//        } completion:^(BOOL finished) {
//            [_tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }];
//        
//    }
    
    assessOrPraise = 1;
    self.pid = ((Reply*)self.resultArray[indexPath.row]).replyID;
    self.puserid = ((Reply*)self.resultArray[indexPath.row]).userID;
    _inputTF.text = [NSString stringWithFormat:@"回复 %@:",((Reply*)self.resultArray[indexPath.row]).nickName];
    [_inputTF becomeFirstResponder];
}
#pragma mark - dynmic delegate
-(void)dynamicCellPressNameButtonOrHeadButton
{
    if ([self.dynamic.userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        SomeOneDynamicViewController* sodVC = [[SomeOneDynamicViewController alloc]init];
        sodVC.userInfo = [[HostInfo alloc]initWithNewHostInfo:[DataStoreManager queryMyInfo] PetsArray:nil];
        [self.navigationController pushViewController:sodVC animated:YES];
        return;
    }
    PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
    personDVC.hostInfo = [[HostInfo alloc]init];
    personDVC.hostInfo.userId = self.dynamic.userID;
    personDVC.hostInfo.nickName = self.dynamic.nickName;
    personDVC.needRequest = YES;
    personDVC.needRequestPet = YES;
    [self.navigationController pushViewController:personDVC animated:YES];
}
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath
{
    if ([((Reply*)self.resultArray[indexPath.row]).userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        SomeOneDynamicViewController* sodVC = [[SomeOneDynamicViewController alloc]init];
        sodVC.userInfo = [[HostInfo alloc]initWithNewHostInfo:[DataStoreManager queryMyInfo] PetsArray:nil];
        [self.navigationController pushViewController:sodVC animated:YES];
        return;
    }
    PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
    personDVC.hostInfo = [[HostInfo alloc]init];
    personDVC.hostInfo.userId = ((Reply*)self.resultArray[indexPath.row]).userID;
    personDVC.hostInfo.nickName = ((Reply*)self.resultArray[indexPath.row]).nickName;
    personDVC.needRequest = YES;
    personDVC.needRequestPet = YES;
    [self.navigationController pushViewController:personDVC animated:YES];
}
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray *)smallImageArray andImageIDArray:(NSArray *)idArray indext:(int)indext
{
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:smallImageArray images:idArray indext:indext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        if (actionSheet == _delAction) {
            self.delAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除这条动态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_delAlert show];
        }
        if (actionSheet == _reportAction) {
            self.reportAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定举报这条动态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_reportAlert show];
        }
        if (actionSheet ==_delReplyAction||actionSheet == _delReplyOrReplyAction) {
            self.delReplyAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除这条评论?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_delReplyAlert show];
        }
    }else{
        if (actionSheet == _delReplyOrReplyAction&&buttonIndex == 1) {
            [self replyOneReplyWithIndexPath:self.indexPath];
        }
    }
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == 0) {
        if (alertView == _delReplyAlert) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:((Reply*)self.resultArray[self.indexPath.row]).replyID forKey:@"replyid"];
            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
            [body setObject:@"service.uri.pet_states" forKey:@"service"];
            [body setObject:@"1" forKey:@"channel"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
            [body setObject:@"iphone" forKey:@"imei"];
            [body setObject:params forKey:@"params"];
            [body setObject:@"delReply" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                [self.resultArray removeObjectAtIndex:self.indexPath.row];
                [self.tableV reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        if (alertView == _delAlert) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
            [body setObject:@"service.uri.pet_states" forKey:@"service"];
            [body setObject:@"1" forKey:@"channel"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
            [body setObject:@"iphone" forKey:@"imei"];
            [body setObject:params forKey:@"params"];
            [body setObject:@"delUserState" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListDeleteOneDynamic:)]) {
                    [self.delegate dynamicListDeleteOneDynamic:self.dynamic];
                }
                [self backButton];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        if (alertView == _reportAlert) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
            [body setObject:@"service.uri.pet_states" forKey:@"service"];
            [body setObject:@"1" forKey:@"channel"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
            [body setObject:@"iphone" forKey:@"imei"];
            [body setObject:params forKey:@"params"];
            [body setObject:@"addReport" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }

    }
    else
    {
        if (alertView.tag==99) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - load data
-(void)loadZanList
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.dynamic.dynamicID forKey:@"srcid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_pat" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getPat" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray*array = responseObject;
        if (array.count>0&&array.count<5) {
            self.zanPonsen = [[NSMutableString alloc]init];
            for (NSDictionary* dic in array) {
                if ([[dic objectForKey:@"id"] isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
                    [self.zanPonsen appendString:@"我"];
                    [self.zanPonsenArrey addObject:@"我"];
                }else{
                    [self.zanPonsen appendFormat:@"%@",[dic objectForKey:@"nickname"]];
                    [self.zanPonsenArrey addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]]];
                }
                if (![dic isEqualToDictionary:[array lastObject]]) {
                    [self.zanPonsen appendFormat:@","];
                }
            }
            [self.zanPonsen appendFormat:@"\t赞过这条动态"];
            [self.tableV reloadData];
        }
        if (array.count>=5) {
            self.zanPonsen = [[NSMutableString alloc]init];
            for (int i = 0; i<5 ;i++) {
                if ([[array[i] objectForKey:@"userid"] isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
                    [self.zanPonsen appendString:@"我"];
                }else{
                    [self.zanPonsen appendFormat:@"%@",[array[i] objectForKey:@"nickname"]];
                }
                if (i!=4) {
                    [self.zanPonsen appendFormat:@","];
                }
            }
            [self.zanPonsen appendFormat:@"\t等%d位好友赞过这条动态",array.count];
            [self.tableV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)reloadData
{
    self.pageNo = 0;
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getReply" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.resultArray removeAllObjects];
        NSArray* array = responseObject;
        if (array.count>0) {
            _pageNo++;
            for (NSDictionary* dic in array) {
                Reply* reply = [[Reply alloc]initWithDictionary:dic];
                [self.resultArray addObject:reply];
            }
        }
        [self.tableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)loadMoreData
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
    [params setObject:[NSString stringWithFormat:@"%d",_pageNo] forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getReply" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array = responseObject;
        if (array.count>0) {
            _pageNo++;
            for (NSDictionary* dic in array) {
                Reply* reply = [[Reply alloc]initWithDictionary:dic];
                [self.resultArray addObject:reply];
            }
        }
        [self.tableV reloadData];
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_footer endRefreshing];
    }];
}
#pragma mark - Responding to keyboard events
-(void)expandingTextView:(BHExpandingTextView *)expandingTextView willChangeHeight:(float)height
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
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.internalTextView.text.length>2&&[[Emoji allEmoji] containsObject:[growingTextView.internalTextView.text substringFromIndex:growingTextView.internalTextView.text.length-2]]) {
        growingTextView.internalTextView.text = [growingTextView.internalTextView.text substringToIndex:growingTextView.internalTextView.text.length-2];
    }
    if (growingTextView.internalTextView.text.length>400) {
        growingTextView.internalTextView.text=[growingTextView.internalTextView.text substringToIndex:400];
    }
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inPutView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inPutView.frame = r;
}
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (assessOrPraise == 2) {
        [self didInput];
        growingTextView.text = @"";
        [growingTextView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [_tableV setFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
        } completion:^(BOOL finished) {
            
        }];
        
        return YES;
    }
    if (growingTextView.text.length<1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"说点什么吧" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
        [alert show];
        return YES;
    }

    [self didInput];
    growingTextView.text = @"";
    [growingTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_tableV setFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    } completion:^(BOOL finished) {
        
    }];
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
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardRect.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	inPutView.frame = containerFrame;
    
	
	// commit animations
	[UIView commitAnimations];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    [self autoMovekeyBoard:keyboardRect.size.height];
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
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	inPutView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
//    [self autoMovekeyBoard:0];
}
-(void) autoMovekeyBoard: (float) h{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (iPhone5) {
        if (self.view.frame.size.height == 499.0+diffH) {
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height+49), 320.0f, inPutView.frame.size.height);
        }else{
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
        }
    }
    else
    {
        if (self.view.frame.size.height == 411.0+diffH) {
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
@end
