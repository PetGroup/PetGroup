//
//  ArticleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ArticleViewController.h"
#import "MJRefresh.h"
#import "TempData.h"
@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)NSMutableArray* dataSourceArray;
@property (nonatomic,retain)UITableView*tableV;
@property (nonatomic,assign)int pageNo;
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
    [titleLabel setText:@"帖子详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-93-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    UIImageView* bottomIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
    bottomIV.image = [UIImage imageNamed:@"dibuanniu_bg"];
    bottomIV.userInteractionEnabled = YES;
    [self.view addSubview:bottomIV];
    
    UIButton* showB = [UIButton buttonWithType:UIButtonTypeCustom];
    [showB setTitle:@"举报" forState:UIControlStateNormal];
    showB.frame = CGRectMake(10, 4.5, 60, 40);
    [bottomIV addSubview:showB];
    
    UIButton* replyB = [UIButton  buttonWithType:UIButtonTypeCustom];
    [replyB setTitle:@"回复" forState:UIControlStateNormal];
    replyB.frame = CGRectMake(80, 4.5, 240, 40);
    [bottomIV addSubview:replyB];
    
    CGSize size = [self.article.name sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(300, 90) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel* titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, size.height)];
    titleL.numberOfLines = 0;
    titleL.text = self.article.name;
    titleL.font = [UIFont systemFontOfSize:18.0];
    UIView* headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, size.height+50)];
    _tableV.tableHeaderView = headV;
    [headV addSubview:titleL];
    
    UILabel*readL = [[UILabel alloc]initWithFrame:CGRectMake(170, size.height+20, 70, 12)];
    readL.text = [NSString stringWithFormat:@"浏览:%@",self.article.clientCount];
    readL.font = [UIFont systemFontOfSize:14];
    readL.textColor = [UIColor grayColor];
    [headV addSubview:readL];

    UILabel*replyL = [[UILabel alloc]initWithFrame:CGRectMake(250, size.height+20, 70, 12)];
    replyL.text = [NSString stringWithFormat:@"回复:%@",self.article.replyCount];
    replyL.font = [UIFont systemFontOfSize:14];
    replyL.textColor = [UIColor grayColor];
    [headV addSubview:replyL];
    
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.article.articleID forKey:@"noteid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"detailNote" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        //未完待续
        
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
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ArticleViewController * articleVC = [[ArticleViewController alloc]init];
//    articleVC.article = hotPintsDS.dataSourceArray[indexPath.row];
//    [self.navigationController pushViewController:articleVC animated:YES];
}
#pragma mark - table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
        return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"OwnerCell";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        return cell;
    }
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark - load data
-(void)reloadData
{
    self.pageNo = 0;
    [self loadMoreData];
}
-(void)loadMoreData
{
    //body={"method":"getAllReplyNoteByNoteid","token":"","params":{"noteId":"816B9BA15E8B48E5ADF282BCB7FD640E","pageNo":"1","pageSize":"3"}}
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    [params setObject:self.article.articleID forKey:@"noteId"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getAllReplyNoteByNoteid" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray* array = responseObject;
        //未完待续
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSAttributedString *)getAttributedString:(NSString *)theStr
{
    NSAttributedString *uu =[self _attributedStringForSnippetUsingiOS6Attributes:NO String:theStr];
    return uu;
    
}
-(NSNumber *)getRequiredHeightForTextView:(NSAttributedString *)attributeStr
{
    DTAttributedTextContentView * atextView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    atextView.attributedString = attributeStr;
    atextView.shouldDrawImages = YES;
    atextView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    atextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGSize gg = [atextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:320];
    return [NSNumber numberWithFloat:gg.height];
}
- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes String:(NSString *)contentStr
{
    NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
	return attributedString;
}

-(void)presentUIWebViewWithURL:(NSURL *)addressURL
{
    WebViewViewController * webV = [[WebViewViewController alloc] init];
    webV.addressURL = addressURL;
    [self presentViewController:webV animated:YES completion:^{
        
    }];
}

@end
