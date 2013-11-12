//
//  FriendCircleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "TempData.h"
#import "EditDynamicViewController.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "OnceDynamicViewController.h"
#import "PhotoViewController.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
#import "SomeOneDynamicViewController.h"
#import "HostInfo.h"
#import "PersonDetailViewController.h"
@interface FriendCircleViewController ()<UITableViewDelegate,DynamicCellDelegate,TableViewDatasourceDidChange,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SRRefreshDelegate,MJRefreshBaseViewDelegate>
{
    BOOL free;
}
@property (nonatomic,retain)UIView* backV;
@property (nonatomic,retain)MJRefreshFooterView* footer;
@property (nonatomic,retain)SRRefreshView* refreshView;
@property (nonatomic,retain)UIView* headV;
@property (nonatomic,retain)EGOImageView* imageV;
@property (nonatomic,retain)UITableView* tableV;
@property (nonatomic,retain)FriendCircleDataSource* friendCircleDS;
@end

@implementation FriendCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendCircleDS = [[FriendCircleDataSource alloc]init];
        _friendCircleDS.myController = self;
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
    [titleLabel setText:@"朋友圈"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame=CGRectMake(278, 3+diffH, 35, 33);
    [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(updateSelfMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishButton];
    
    NSDictionary* dic = [DataStoreManager queryMyInfo];
    self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(0, -6, 320, 320)];
    _imageV.placeholderImage = [UIImage imageNamed:@"morenbeijing"];
    _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",[dic objectForKey:@"backgroundImg"]]];
    [self.view addSubview:_imageV];
    [self.view sendSubviewToBack:_imageV];
    
    self.backV = [[UIView alloc]initWithFrame:CGRectMake(0, 245, 320, 300)];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backV];
    [self.view insertSubview:_backV aboveSubview:_imageV];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-44-diffH)];
    _tableV.delegate = self;
    _tableV.dataSource = self.friendCircleDS;
    _tableV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableV];
    
    self.headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 220)];
    _headV.backgroundColor = [UIColor clearColor];
    self.tableV.tableHeaderView = _headV;
    
    UIButton* changeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeB addTarget:self action:@selector(changeCoverImage) forControlEvents:UIControlEventTouchUpInside];
    changeB.frame =CGRectMake(0, 0, 320, 180);
    [_headV addSubview:changeB];
    
    UIView* whiteV = [[UIView alloc]initWithFrame:CGRectMake(0, 180, 320, 40)];
    whiteV.backgroundColor = [UIColor whiteColor];
    [_headV addSubview:whiteV];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 210, 20)];
    nameL.font = [UIFont boldSystemFontOfSize:18];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = NSTextAlignmentRight;
    nameL.textColor = [UIColor whiteColor];
    nameL.shadowColor = [UIColor blackColor];
    [_headV addSubview:nameL];
    
    UIImageView * photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(230, 120, 80, 80)];
    photoIV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [_headV addSubview:photoIV];
    photoIV.userInteractionEnabled = YES;
    
    EGOImageButton*headIV = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
    headIV.frame = CGRectMake(5, 5, 70, 70);
    [photoIV addSubview:headIV];
    [headIV addTarget:self action:@selector(headAct) forControlEvents:UIControlEventTouchUpInside];
    
    nameL.text = [dic objectForKey:@"nickname"];
//    CGSize size = [nameL.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(220, 20) lineBreakMode:NSLineBreakByWordWrapping];
//    nameL.frame = CGRectMake(220-size.width, 140, size.width, 20);
    NSString * imageID = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",imageID]];
    
    UILabel*signatureL  = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 300, 20)];
    signatureL.font = [UIFont systemFontOfSize:16];
    signatureL. textAlignment = NSTextAlignmentRight;
    signatureL.backgroundColor = [UIColor clearColor];
    signatureL.textColor = [UIColor blackColor];
    signatureL.text = [dic objectForKey:@"signature"];
    [_headV addSubview:signatureL];
    
    self.refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:010/255.0 alpha:1];
    _refreshView.slime.skinColor = [UIColor whiteColor];
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.0];
    
    [self.tableV addSubview:_refreshView];
    
    self.footer = [[MJRefreshFooterView alloc]init];
    _footer.delegate = self;
    _footer.scrollView = self.tableV;
    
    [self reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    free = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (free) {
        [_footer free];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)headAct
{
    free = NO;
    SomeOneDynamicViewController* sodVC = [[SomeOneDynamicViewController alloc]init];
    sodVC.userInfo = [[HostInfo alloc]initWithNewHostInfo:[DataStoreManager queryMyInfo] PetsArray:nil];
    [self.navigationController pushViewController:sodVC animated:YES];
}
-(void)changeCoverImage
{
    UIActionSheet* addActionSheet = [[UIActionSheet alloc]initWithTitle:@"更换您的封面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [addActionSheet showInView:self.view];
}
-(void)backButton
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateSelfMassage
{
    free = NO;
    EditDynamicViewController* editVC = [[EditDynamicViewController alloc]init];
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController * imagePicker;
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                //                    [self presentModalViewController:imagePicker animated:YES];
                free = NO;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [cameraAlert show];
            }
        }break;
        case 1:
        {
            UIImagePickerController * imagePicker;
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                //                    [self presentModalViewController:imagePicker animated:YES];
                free = NO;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                [libraryAlert show];
            }
            
        }break;
        default:
            break;
    }
    
}
#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    selectImage = [FriendCircleViewController compressImageDownToPhoneScreenSize:selectImage targetSizeX:320 targetSizeY:320];
    selectImage = [FriendCircleViewController image:selectImage centerInSize:CGSizeMake(320, 320)];
    _imageV.image = selectImage;
  //修改相册封面，未完待续
    [NetManager uploadImage:selectImage WithURLStr:BaseUploadImageUrl ImageName:@"CoverImage" TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*imageID = responseObject;
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setObject:imageID forKey:@"backgroundImg"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:params forKey:@"params"];
        [body setObject:@"updateUser" forKey:@"method"];
        [body setObject:@"service.uri.pet_user" forKey:@"service"];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [DataStoreManager saveMyBackgroungImg:imageID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _refreshView) {
        [self reloadData];
    }
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _tableV){
        [_refreshView scrollViewDidScroll];
    }
    _backV.frame = CGRectMake(0, -scrollView.contentOffset.y+245, 320, 300);
    _imageV.frame = CGRectMake(0, -scrollView.contentOffset.y/2, 320, 320);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableV) {
        [_refreshView scrollViewDidEndDraging];
    }
}
#pragma mark MJRefreshBaseView delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData];
    }
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell heightForRowWithDynamic:self.friendCircleDS.dataSourceArray[indexPath.row]];
//    return ];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    free = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.delegate = self;
    [self.navigationController pushViewController:odVC animated:YES];
}
#pragma mark - dynamic cell delegate
-(void)dynamicCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath
{
    if ([((Dynamic*)self.friendCircleDS.dataSourceArray[indexPath.row]).userID isEqualToString:[[TempData sharedInstance] getMyUserID]]) {
        [self headAct];
        return;
    }
    free = NO;
    PersonDetailViewController* personDVC = [[PersonDetailViewController alloc]init];
    personDVC.hostInfo = [[HostInfo alloc]init];
    personDVC.hostInfo.userId = ((Dynamic*)self.friendCircleDS.dataSourceArray[indexPath.row]).userID;
    personDVC.hostInfo.nickName = ((Dynamic*)self.friendCircleDS.dataSourceArray[indexPath.row]).nickName;
    personDVC.needRequest = YES;
    personDVC.needRequestPet = YES;
    [self.navigationController pushViewController:personDVC animated:YES];
}
-(void)dynamicCellPressZanButtonAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indext= %d= %d",indexPath.section,indexPath.row);
    Dynamic* dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    if (!dynamic.ifIZaned) {
        dynamic.ifIZaned = !dynamic.ifIZaned;
        dynamic.countZan++;
    }else{
        dynamic.ifIZaned = !dynamic.ifIZaned;
        dynamic.countZan--;
    }
    [self.tableV reloadData];
    if (dynamic.ifIZaned) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:dynamic.dynamicID forKey:@"srcid"];
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
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:dynamic.dynamicID forKey:@"srcid"];
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
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
-(void)dynamicCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath
{
    free = NO;
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.delegate = self;
    odVC.onceDynamicViewControllerStyle = OnceDynamicViewControllerStyleReply;
    [self.navigationController pushViewController:odVC animated:YES];
}
-(void)dynamicCellPressZhuangFaButtonAtIndexPath:(NSIndexPath *)indexPath
{
    free = NO;
    OnceDynamicViewController * odVC = [[OnceDynamicViewController alloc]init];
    odVC.dynamic = self.friendCircleDS.dataSourceArray[indexPath.row];
    odVC.onceDynamicViewControllerStyle = OnceDynamicViewControllerStyleZhuanfa;
    odVC.delegate = self;
    [self.navigationController pushViewController:odVC animated:YES];
}
-(void)dynamicCellPressImageButtonWithSmallImageArray:(NSArray*)smallImageArray andImageIDArray:(NSArray*)idArray indext:(int)indext
{
    free = NO;
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:smallImageArray images:idArray indext:indext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - dynamic list reload data
-(void)dynamicListDeleteOneDynamic:(Dynamic*)dynamic
{
    NSUInteger a = [self.friendCircleDS.dataSourceArray indexOfObject:dynamic];
//    [self.friendCircleDS.rowHighArray removeObjectAtIndex:a];
    [self.friendCircleDS.dataSourceArray removeObjectAtIndex:a];
    [self.tableV reloadData];
}
-(void)dynamicListAddOneDynamic:(Dynamic*)dynamic
{
    [self.friendCircleDS.dataSourceArray insertObject:dynamic atIndex:0];
//    [self.friendCircleDS.rowHighArray insertObject:[NSString stringWithFormat:@"%f",[DynamicCell heightForRowWithDynamic:dynamic]] atIndex:0];
    [self.tableV reloadData];
}
-(void)dynamicListJustReload
{
    [self.tableV reloadData];
}
#pragma mark - load data
-(void)reloadData
{
    [_friendCircleDS reloadDataSuccess:^{
        [self.tableV reloadData];
        [_refreshView endRefresh];
    } failure:^{
        [_refreshView endRefresh];
    }];
}
-(void)loadMoreData
{
    [_friendCircleDS loadMoreDataSuccess:^{
        [self.tableV reloadData];
        [_footer endRefreshing];
    } failure:^{
        [_footer endRefreshing];
    }];
}
#pragma mark - 压缩图片
+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY
{
	
	UIImage * bigImage = theImage;
	
	float actualHeight = bigImage.size.height;
	float actualWidth = bigImage.size.width;
	
	float imgRatio = actualWidth / actualHeight;
	float maxRatio = sizeX / sizeY;
    
    if(imgRatio < maxRatio){
        imgRatio = sizeX / actualWidth;
        actualHeight = imgRatio * actualHeight;
        actualWidth = sizeX;
    } else {
        imgRatio = sizeY / actualHeight;
        actualWidth = imgRatio * actualWidth;
        actualHeight = sizeY;
        
    }
	CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[bigImage drawInRect:rect];  // scales image to rect
	theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}
+ (UIImage *) image: (UIImage *) image centerInSize: (CGSize) viewsize
{
	CGSize size = image.size;
	
	UIGraphicsBeginImageContext(viewsize);
	float dwidth = (viewsize.width - size.width) / 2.0f;
	float dheight = (viewsize.height - size.height) / 2.0f;
	
	CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
	[image drawInRect:rect];
	
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newimg;
}
@end
