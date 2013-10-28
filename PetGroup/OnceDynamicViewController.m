//
//  OnceDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "OnceDynamicViewController.h"
#import "PullingRefreshTableView.h"
#import "TempData.h"
#import "DetailsDynamicCell.h"
#import "UIExpandingTextView.h"
#import "BHExpandingTextView.h"
#import "Reply.h"
#import "ReplyCell.h"
@interface OnceDynamicViewController ()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate,PullingRefreshTableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIExpandingTextViewDelegate,BHExpandingTextViewDelegate,HPGrowingTextViewDelegate>
{
    int assessOrPraise;
    UIImageView * inputbg;
    UIView * inPutView;
    BOOL request;
}
@property (strong,nonatomic) PullingRefreshTableView * tableV;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    diffH = [Common diffHeight:self];
    
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
    
    self.tableV = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.pullingDelegate = self;
    [self.view addSubview:_tableV];
    
    UIImageView* bottomIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    bottomIV.image = [UIImage imageNamed:@"dibuanniu_bg"];
    bottomIV.userInteractionEnabled = YES;
    [self.view addSubview:bottomIV];
    
    UIButton * zanB = [UIButton buttonWithType:UIButtonTypeCustom];
    zanB.frame = CGRectMake(10, 9, 94.5, 31);
    if (self.dynamic.ifIZaned) {
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zaned_normal"] forState:UIControlStateNormal];
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zaned_click"] forState:UIControlStateHighlighted];
    }else{
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zan_normal"] forState:UIControlStateNormal];
        [zanB setBackgroundImage:[UIImage imageNamed:@"bottom_zan_click"] forState:UIControlStateHighlighted];
    }
    [zanB addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:zanB];
    
    UIButton * replyB = [UIButton buttonWithType:UIButtonTypeCustom];
    replyB.frame = CGRectMake(114.5, 9, 94.5, 31);
    [replyB setBackgroundImage:[UIImage imageNamed:@"bottom_pl_normal"] forState:UIControlStateNormal];
    [replyB setBackgroundImage:[UIImage imageNamed:@"bottom_pl_click"] forState:UIControlStateHighlighted];
    [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:replyB];
    
    UIButton * zhuanfaB = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuanfaB.frame = CGRectMake(215, 9, 94.5, 31);
    [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"bottom_zf_normal"] forState:UIControlStateNormal];
    [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"bottom_zf_click"] forState:UIControlStateHighlighted];
    [zhuanfaB addTarget:self action:@selector(zhuanfaAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomIV addSubview:zhuanfaB];
    
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
        [button setBackgroundImage:[UIImage imageNamed:@"bottom_zaned_click"] forState:UIControlStateHighlighted];
    }else{
        self.dynamic.ifIZaned = !self.dynamic.ifIZaned;
        self.dynamic.countZan--;
        [button setBackgroundImage:[UIImage imageNamed:@"bottom_zan_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bottom_zan_click"] forState:UIControlStateHighlighted];
    }
    [self.delegate dynamicListNeedReloadData:nil];
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
    [_inputTF becomeFirstResponder];
    assessOrPraise = 1;
    self.inputTF.placeholder = [NSString stringWithFormat:@"评论:%@",self.dynamic.nickName];
    NSIndexPath*index = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableV scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)zhuanfaAction//转发
{
    [_inputTF becomeFirstResponder];
    assessOrPraise = 2;
    self.inputTF.placeholder = @"转发至我的动态";
    NSIndexPath*index = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableV scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)didInput
{
    switch (assessOrPraise) {
        case 1:{//评论{"msg":"回复内容","pid":"被回复的回复ID","puserid":"被回复的回复人ID","stateid":"动态ID"}
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
                
                //未完待续
                if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListNeedReloadData:)]) {
                    [self.delegate dynamicListNeedReloadData:nil];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }break;
        case 2:{
            //转发
            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            long long a = (long long)(cT*1000);
            [params setObject:@"" forKey:@"transmitUrl"];
            [params setObject:self.inputTF.text forKey:@"transmitMsg"];
            [params setObject:@"1" forKey:@"ifTransmitMsg"];
            [params setObject:self.dynamic.msg forKey:@"msg"];
            [params setObject:self.dynamic.imageID forKey:@"imgid"];
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
                NSLog(@"%@",responseObject);
                
                //未完待续
                if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListNeedReloadData:)]) {
                    [self.delegate dynamicListNeedReloadData:nil];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
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
#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
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
    }else
    {
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
    static NSString *cellIdentifier = @"replyCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [DetailsDynamicCell heightForRowWithDynamic:self.dynamic];
    }else{
        return [ReplyCell heightForRowWithDynamic:self.resultArray[indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inputTF.isFirstResponder) {
        [_inputTF resignFirstResponder];
        return;
    }
    if (indexPath.section == 0) {
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
    [_tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    assessOrPraise = 1;
    self.pid = ((Reply*)self.resultArray[indexPath.row]).replyID;
    self.puserid = ((Reply*)self.resultArray[indexPath.row]).userID;
    _inputTF.text = [NSString stringWithFormat:@"回复 %@:",((Reply*)self.resultArray[indexPath.row]).nickName];
    [_inputTF becomeFirstResponder];
}
#pragma mark - ScrollDelegate

//刷新必须调用ScrollViewDelegate方法（从写的方法）

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if (self.resultArray.count>0) {
        [self.tableV tableViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.resultArray.count>0) {
        [self.tableV tableViewDidEndDragging:scrollView];
    }
}




#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self reloadData];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self loadMoreData];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return date;
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
    }
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == 0) {
        if (alertView == _delAlert) {
            //body={"service":"service.uri.pet_states","method":"delUserState","token":"XXX","channel":"","mac":"","imei":"","params":{"stateid":""}}
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
                NSLog(@"%@",responseObject);
                
                //未完待续
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        if (alertView == _reportAlert) {
            //body={"service":"service.uri.pet_states","method":"reportContent","token":"XXX","channel":"","mac":"","imei":"","params":{"stateid":""}}
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
            [body setObject:@"reportContent" forKey:@"method"];
            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                //未完待续
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}
#pragma mark - load data
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
            [self.tableV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
/*    //获取回复总数
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:@"service.uri.pet_states" forKey:@"service"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getTotalReply" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];*/
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
            [self.tableV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inPutView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inPutView.frame = r;
}
- (BOOL)expandingTextViewShouldReturn:(BHExpandingTextView *)expandingTextView
{
    if (expandingTextView.text.length>=1) {
        [self didInput];
        expandingTextView.text = @"";
        [expandingTextView resignFirstResponder];
    }
    return YES;
}
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length>=1) {
        [self didInput];
        growingTextView.text = @"";
        [growingTextView resignFirstResponder];
    }
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
