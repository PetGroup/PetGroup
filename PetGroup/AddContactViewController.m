//
//  AddContactViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AddContactViewController.h"
#import "JSON.h"
#import "DataStoreManager.h"
#import "TempData.h"
@interface AddContactViewController ()

@end

@implementation AddContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pageIndex = 0;
        self.resultArray = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;

    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];

    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"搜索用户";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(240, diffH, 80, 44)];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [doneBtn setTitle:@"按手机号" forState:UIControlStateNormal];
    [self.view addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    
    searchCondition = @"nickname";
    
    self.resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    [self.view addSubview:self.resultTable];
    self.resultTable.dataSource = self;
    self.resultTable.delegate = self;
    self.resultTable.rowHeight = 60;
    asearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    asearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    asearchBar.placeholder = @"输入昵称查找用户";
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.resultTable.tableHeaderView = asearchBar;
   // asearchBar.barStyle = UIBarStyleBlackTranslucent;
    UIView * dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dd setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    
    [asearchBar insertSubview:dd atIndex:1];
    asearchBar.delegate = self;
    
    noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150+diffH, 320, 60)];
    [noResultLabel setTextAlignment:NSTextAlignmentCenter];
    noResultLabel.text = @"不好意思呀，没找到^_^";
//    noResultLabel.adjustsFontSizeToFitWidth = YES;
    noResultLabel.backgroundColor = [UIColor clearColor];
    noResultLabel.textColor = [UIColor grayColor];
    [self.view addSubview:noResultLabel];
    noResultLabel.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)doneBtnDo:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"按手机号"]) {
        [sender setTitle:@"按昵称" forState:UIControlStateNormal];
        asearchBar.placeholder = @"输入手机号查找用户";
        searchCondition = @"username";
    }
    else
    {
        [sender setTitle:@"按手机号" forState:UIControlStateNormal];
        asearchBar.placeholder = @"输入昵称查找用户";
        searchCondition = @"nickname";
    }
}

-(void)searchUser
{
    NSMutableDictionary * locationDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [locationDict setObject:asearchBar.text forKey:@"condition"];
    [locationDict setObject:searchCondition forKey:@"conditionType"];
//    [locationDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"searchUser" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.resultArray =responseObject;
        NSMutableArray * tempArray = [self.resultArray mutableCopy];
        for (NSDictionary* dic in tempArray) {
            if ([[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"] integerValue]] isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
                [self.resultArray removeObject:dic];
            }
        }
        if (self.resultArray.count>0) {
            noResultLabel.hidden = YES;
        }
        else
            noResultLabel.hidden = NO;
        [self.resultTable reloadData];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];

        
    }];
    
//    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"shifangle");
//    }];
    
}

#pragma mark -
#pragma mark TableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell = @"cell";
    ContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (!cell) {
        cell = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (![[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"img"] isKindOfClass:[NSNull class]] ) {
        NSString * imgStr = [self getFistHeadImg:[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"img"]];
        
        [cell.headImageV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,imgStr]] placeholderImage:[UIImage imageNamed:@"moren_people.png"]];
    }
    [cell.nameLabel setText:[[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"nickname"] isKindOfClass:[NSNull class]]?@"123":[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"nickname"]];
    NSString* sigStr = [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"signature"];
    if (![sigStr isKindOfClass:[NSNull class]]&&![sigStr isEqualToString:@""]) {
        [cell.signatureLabel setText:sigStr];
    }else{
        [cell.signatureLabel setText:@"该用户没有设置签名"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
    HostInfo * hostInfo = [[HostInfo alloc] initWithNewHostInfo:[self.resultArray objectAtIndex:indexPath.row] PetsArray:nil];
    detailV.hostInfo = hostInfo;
    detailV.needRequestPet = YES;
    [self.navigationController pushViewController:detailV animated:YES];
    
}
-(NSString *)getFistHeadImg:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];

    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>1) {
        for (NSString* a in i) {
            NSArray *arr = [a componentsSeparatedByString:@"_"];
            if (arr.count>1) {
                [littleHeadArray addObject:arr[0]];
            }
        }
    }
    if (littleHeadArray.count>0) {
        return littleHeadArray[0];
    }
    else
        return @"no";
}

#pragma mark -
#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.pageIndex = 0;
    if (![hud superview]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.delegate = self;
        hud.labelText = @"搜索中...";
    }

    [hud show:YES];
    
    [asearchBar resignFirstResponder];
    [self searchUser];

}

-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
