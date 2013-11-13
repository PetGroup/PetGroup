//
//  NotificationViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NotificationViewController.h"
#import "CustomTabBar.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"收到的消息"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(245, 5+diffH, 70, 34);
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    if (diffH==0.0f) {
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    }
    [clearBtn addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    self.notiTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH) style:UITableViewStylePlain];
    [self.view addSubview:self.notiTableV];
    self.notiTableV.dataSource = self;
    self.notiTableV.delegate = self;
    [self.view addSubview:self.notiTableV];
    
    self.appDel = [[UIApplication sharedApplication] delegate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.appDel.xmppHelper.commentDelegate = self;
    [self readNewNoti];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    [defaultUserD setObject:self.notiArray forKey:notiKey];
    [defaultUserD synchronize];

}
-(void)readNewNoti
{
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    NSArray * tempNewNotiArray = [defaultUserD objectForKey:notiKey];
    if (tempNewNotiArray) {
        if (tempNewNotiArray.count>0) {
            self.notiArray = [NSMutableArray arrayWithArray:tempNewNotiArray];
        }
        else{
            self.notiArray = [NSMutableArray array];
        }
    }
    else
        self.notiArray = [NSMutableArray array];
    [self.notiTableV reloadData];
    
}
-(void)newCommentReceived:(NSDictionary *)theDict
{
    [self storeReceivedNotification:theDict];
}
-(void)storeReceivedNotification:(NSDictionary *)theDict
{
    AudioServicesPlayAlertSound(1003);
    [self.notiArray insertObject:theDict atIndex:0];
    [self.notiTableV reloadData];
}


-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearAll
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清空所有未读消息吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
        NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        [defaultUserD removeObjectForKey:notiKey];
        [defaultUserD synchronize];
        [self readNewNoti];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cDict = self.notiArray[indexPath.row];
    CGSize size;
    CGSize labelsize;
    if ([[cDict objectForKey:@"contentType"] isEqualToString:@"topic"]) {
        size = CGSizeMake(250,80);
        labelsize = [[cDict objectForKey:@"replyContent"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    else
    {
        size = CGSizeMake(150,80);
        labelsize = [[cDict objectForKey:@"replyContent"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return 100+((labelsize.height-20)>0?(labelsize.height-20):0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.notiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"notiCell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    NSDictionary * cDict = self.notiArray[indexPath.row];
    NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[self getHead:[cDict objectForKey:@"fromHeadImg"]]]];
    cell.headImageV.imageURL = theUrl;
    // Configure the cell...
    cell.nameLabel.text = [cDict objectForKey:@"fromNickname"];
    cell.timeLabel.text = [Common CurrentTime:[Common getCurrentTime] AndMessageTime:[cDict objectForKey:@"time" ]];
//    if ([[cDict objectForKey:@"contentType"] isEqualToString:@"dynamic"]) {
//        cell.contentLabel.text = [cDict objectForKey:@"content"];
//        if ([[cDict objectForKey:@"replyContent"] isEqualToString:@"iszan"]) {
//            cell.replyLabel.text = @"赞了你的动态";
//        }
//        else
//            cell.replyLabel.text = [cDict objectForKey:@"replyContent"];
//    }
//    else
//        cell.replyLabel.text = [NSString stringWithFormat:@"评论了你的帖子：\n%@",[cDict objectForKey:@"content"]];
    cell.replyLabel.text = [cDict objectForKey:@"replyContent"];
    CGSize size;
    if ([[cDict objectForKey:@"contentType"] isEqualToString:@"topic"]) {
        size = CGSizeMake(250,80);
        cell.replyLabel.backgroundColor = [UIColor clearColor];
        CGSize labelsize = [[cDict objectForKey:@"replyContent"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        cell.replyLabel.frame = CGRectMake(cell.replyLabel.frame.origin.x, cell.replyLabel.frame.origin.y, 250, labelsize.height);
        cell.replyBgImageV.frame = CGRectMake(cell.replyLabel.frame.origin.x-5, cell.replyLabel.frame.origin.y-5, 260, labelsize.height+10);
        cell.replyBgImageV.hidden = NO;
        cell.contentLabel.hidden = YES;
        cell.contentImageV.hidden = YES;
    }
    else
    {
        cell.replyBgImageV.hidden = YES;
        size = CGSizeMake(150,80);
        cell.replyLabel.backgroundColor = [UIColor clearColor];
        CGSize labelsize = [[cDict objectForKey:@"replyContent"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        cell.replyLabel.frame = CGRectMake(cell.replyLabel.frame.origin.x, cell.replyLabel.frame.origin.y, 150, labelsize.height);
        
        if ([[cDict objectForKey:@"picID"] length]>1) {
            cell.contentImageV.hidden = NO;
            cell.contentLabel.hidden = YES;
            [cell.contentImageV setImageWithURL:[NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[self getHead:[cDict objectForKey:@"picID"]]]]];
        }
        else
        {
            cell.contentImageV.hidden = NO;
            cell.contentImageV.image = nil;
            cell.contentLabel.hidden = NO;
            cell.contentLabel.text = [cDict objectForKey:@"content"];
        }
    }
    //计算实际frame大小，并将label的frame变成实际大小
    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        // [DataStoreManager deleteMsgsWithSender:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] Type:COMMONUSER];
        [self.notiArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * tempID = [self.notiArray[indexPath.row] objectForKey:@"contentID"];
    if ([[self.notiArray[indexPath.row] objectForKey:@"contentType"] isEqualToString:@"topic"]) {
        ArticleViewController * articleVC = [[ArticleViewController alloc]init];
        articleVC.articleID = tempID;
        articleVC.floor = [[self.notiArray[indexPath.row] objectForKey:@"floor"] intValue];
        [self.navigationController pushViewController:articleVC animated:YES];

    }
    else
    {
        OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
        odVC.dynamic = [[Dynamic alloc] init];
        odVC.needRequestDyn = YES;
        odVC.dynamic.dynamicID = tempID;
        [self.navigationController pushViewController:odVC animated:YES];
    }
    [self.notiArray removeObjectAtIndex:indexPath.row];
    [self.notiTableV reloadData];
    NSUserDefaults * defaultUserD = [NSUserDefaults standardUserDefaults];
    NSString * notiKey = [NSString stringWithFormat:@"%@_%@",NewComment,[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    [defaultUserD setObject:self.notiArray forKey:notiKey];
    [defaultUserD synchronize];
}
-(NSString *)getHead:(NSString *)headImgStr
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
    }//动态大图ID数组和小图ID数组
    return littleHeadArray.count>0?littleHeadArray[0]:@"no";
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
