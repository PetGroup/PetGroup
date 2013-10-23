//
//  ArticleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ArticleViewController.h"
#import "TempData.h"
@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView*tableV;
@end

@implementation ArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"帖子详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-93)];
    _tableV.delegate = self;
//    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    UIView* bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    bottomV.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomV];
    
    UIButton* showB = [UIButton buttonWithType:UIButtonTypeCustom];
    [showB setTitle:@"分享" forState:UIControlStateNormal];
    showB.frame = CGRectMake(10, 4.5, 60, 40);
    [bottomV addSubview:showB];
    
    UIButton* replyB = [UIButton  buttonWithType:UIButtonTypeCustom];
    [replyB setTitle:@"回复" forState:UIControlStateNormal];
    replyB.frame = CGRectMake(80, 4.5, 240, 40);
    [bottomV addSubview:replyB];
    
    //body={"method":"getAllReplyNoteByNoteid","token":"","params":{"noteId":"816B9BA15E8B48E5ADF282BCB7FD640E","pageNo":"1","pageSize":"3"}}
//    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//    long long a = (long long)(cT*1000);
//    NSMutableDictionary* params = [NSMutableDictionary dictionary];
//    [params setObject:@"1" forKey:@"pageNo"];
//    [params setObject:self.noteId forKey:@"noteId"];
//    [params setObject:@"20" forKey:@"pageSize"];
//    NSMutableDictionary* body = [NSMutableDictionary dictionary];
//    [body setObject:params forKey:@"params"];
//    [body setObject:@"getAllReplyNoteByNoteid" forKey:@"method"];
//    [body setObject:@"1" forKey:@"channel"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//    [body setObject:@"iphone" forKey:@"imei"];
//    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//       
//        //未完待续
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
   // body={"method":"detailNote","token":"","params":{"noteid":"C5564A82DBC749C2A78DE5B0215B41DA"}}
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.noteId forKey:@"noteid"];
    [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userId"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"detailNote" forKey:@"method"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        UILabel* a = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 20)];
        [self.view addSubview:a];
        a.text = [[dic objectForKey:@"entity"][0] objectForKey:@"content"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
