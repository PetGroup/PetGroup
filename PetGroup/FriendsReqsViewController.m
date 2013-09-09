//
//  FriendsReqsViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendsReqsViewController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
@interface FriendsReqsViewController ()

@end

@implementation FriendsReqsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        receivedHellos = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = [[UIApplication sharedApplication] delegate];
    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"添加好友请求";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    

    self.reqTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.view addSubview:self.reqTableV];
    self.reqTableV.dataSource = self;
    self.reqTableV.delegate = self;
    
    [self loadTableviewData];
    [DataStoreManager blankReceivedHellosUnreadCount];
	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return receivedHellos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell3 = @"cellreq";
    addFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell3];
    if (!cell) {
        cell = [[addFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell3];
    }
    [cell.headImageV setImage:[UIImage imageNamed:@"moren_people.png"]];
    [cell.headImageV setImageWithURL:[NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]] placeholderImage:[UIImage imageNamed:[BaseImageUrl stringByAppendingFormat:@"%@",[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]]];
    cell.nameLabel.text = [[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"nickName"];
    cell.agreeBtn.tag = indexPath.row+1;
    cell.rejectBtn.tag = indexPath.row+1;
    [cell.agreeBtn addTarget:self action:@selector(acceptAddReq:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectBtn addTarget:self action:@selector(rejectAddreq:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"accept"]) {
        cell.agreeBtn.hidden = YES;
        [cell.rejectBtn setTitle:@"已同意" forState:UIControlStateNormal];
    }
    else if([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"rejected"]){
        cell.agreeBtn.hidden = YES;
        [cell.rejectBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [cell.rejectBtn setEnabled:NO];
    }
    else if([[[receivedHellos objectAtIndex:indexPath.row] objectForKey:@"acceptStatus"] isEqualToString:@"waiting"]){
        cell.agreeBtn.hidden = NO;
        cell.rejectBtn.hidden = NO;
        [cell.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    
    return cell;
}
-(void)acceptAddReq:(UIButton *)sender
{
    [self.appDel.xmppHelper addOrDenyFriend:YES user:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [DataStoreManager updateReceivedHellosStatus:@"accept" ForPerson:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self loadTableviewData];
    
}
-(void)rejectAddreq:(UIButton *)sender
{
    [self.appDel.xmppHelper addOrDenyFriend:NO user:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [DataStoreManager updateReceivedHellosStatus:@"rejected" ForPerson:[[receivedHellos objectAtIndex:(sender.tag-1)] objectForKey:@"userName"]];
    [self loadTableviewData];
}
-(void)loadTableviewData
{
    receivedHellos = [DataStoreManager queryAllReceivedHellos];
    [self.reqTableV reloadData];
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
