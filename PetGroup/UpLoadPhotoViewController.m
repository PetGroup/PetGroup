//
//  UpLoadPhotoViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "UpLoadPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataStoreManager.h"
#import "MBProgressHUD.h"

@interface UpLoadPhotoViewController ()
{
    int clicked;
    MBProgressHUD * hud;
    
    BOOL haveHostImg;
    BOOL havePetImg;
}
@property (nonatomic,strong)NSString* hostIMG;
@property (nonatomic,strong)NSString* petIMG;
@property (nonatomic,strong)UIImageView* hostPhoto;
@property (nonatomic,strong)UIImageView* petPhoto;

@end

@implementation UpLoadPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        haveHostImg = NO;
        havePetImg = NO;
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
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==0) {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }

    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"上传头像"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel * hostLael = [[UILabel alloc] initWithFrame:CGRectMake(10, 70+diffH, 295, 30)];
    [hostLael setText:@"上传真实头像，拉近真实的距离"];
    [hostLael setBackgroundColor:[UIColor clearColor]];
    [hostLael setTextColor:[UIColor darkGrayColor]];
    [hostLael setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:hostLael];
    
    UIView * bg1 = [[UIView alloc] initWithFrame:CGRectMake(10, 100+diffH, 300, 130)];
    [bg1 setBackgroundColor:[UIColor whiteColor]];
    [bg1 setAlpha:0.5];
    bg1.layer.cornerRadius = 5;
    [self.view addSubview:bg1];
    
    self.hostPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110+diffH, 110, 110)];
    [_hostPhoto setImage:[UIImage imageNamed:@"zhuren"]];
    [self.view addSubview:_hostPhoto];
    
    UILabel* hostL = [[UILabel alloc]initWithFrame:CGRectMake(7, 85, 96, 17)];
    hostL.text = @"主人头像";
    hostL.font = [UIFont boldSystemFontOfSize:13];
    hostL.textAlignment = NSTextAlignmentCenter;
    hostL.textColor = [UIColor whiteColor];
    hostL.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
    [_hostPhoto addSubview:hostL];
    
    UIButton * tpic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tpic1 setFrame:CGRectMake(160, 117+diffH, 115, 30)];
    [tpic1 setImage:[UIImage imageNamed:@"takepic.png"] forState:UIControlStateNormal];
//    [tpic1 setImage:[UIImage imageNamed:@"xiangche-click"] forState:UIControlStateHighlighted];
    [tpic1 setTag:1];
    [tpic1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tpic1];
    
    UIButton * tpic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tpic2 setFrame:CGRectMake(160, 182+diffH, 115, 30)];
    [tpic2 setImage:[UIImage imageNamed:@"choosegallery.png"] forState:UIControlStateNormal];
//    [tpic2 setImage:[UIImage imageNamed:@"paizhao-click"] forState:UIControlStateHighlighted];
    [tpic2 setTag:2];
    [tpic2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tpic2];
    
    if (self.petType == PetTypeStyleNone) {
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
        [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.view addSubview:backButton];
        [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UILabel * petLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230+diffH, 295, 30)];
        [petLabel setText:@"爱宠的真实头像，方便小伙伴找到它"];
        [petLabel setTextColor:[UIColor darkGrayColor]];
        [petLabel setBackgroundColor:[UIColor clearColor]];
        [petLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.view addSubview:petLabel];
        
        UIView * bg2 = [[UIView alloc] initWithFrame:CGRectMake(10, 260+diffH, 300, 130)];
        [bg2 setBackgroundColor:[UIColor whiteColor]];
        [bg2 setAlpha:0.5];
        bg2.layer.cornerRadius = 5;
        [self.view addSubview:bg2];
        
        self.petPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 270+diffH, 110, 110)];
        [_petPhoto setImage:[UIImage imageNamed:@"chongwu"]];
        [self.view addSubview:_petPhoto];
        
        UILabel* petL = [[UILabel alloc]initWithFrame:CGRectMake(7, 85, 96, 17)];
        petL.text = @"宠物头像";
        petL.font = [UIFont boldSystemFontOfSize:13];
        petL.textAlignment = NSTextAlignmentCenter;
        petL.textColor = [UIColor whiteColor];
        petL.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
        [_petPhoto addSubview:petL];
        
        UIButton * tpic21 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tpic21 setFrame:CGRectMake(160, 280+diffH, 114, 30)];
        [tpic21 setImage:[UIImage imageNamed:@"takepic.png"] forState:UIControlStateNormal];
//        [tpic21 setImage:[UIImage imageNamed:@"xiangche-click"] forState:UIControlStateHighlighted];
        [tpic21 setTag:21];
        [tpic21 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tpic21];
        
        UIButton * tpic22 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tpic22 setFrame:CGRectMake(160, 340+diffH, 114, 30)];
        [tpic22 setImage:[UIImage imageNamed:@"choosegallery.png"] forState:UIControlStateNormal];
//        [tpic22 setImage:[UIImage imageNamed:@"paizhao-click"] forState:UIControlStateHighlighted];
        [tpic22 setTag:22];
        [tpic22 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tpic22];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在完善您的信息...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - upload image 
-(void)uploadUserImage
{
    [NetManager uploadImageWithCompres:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* a = responseObject;
        [NetManager uploadImage:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* b = responseObject;
            self.hostIMG = [NSString stringWithFormat:@"%@_%@,",a,b];
            [self updataUserAndPetInFo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertView];
            [hud hide:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertView];
        [hud hide:YES];
    }];
}
-(void)uploadPetImage
{
    [NetManager uploadImageWithCompres:_petPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* a = responseObject;
        [NetManager uploadImage:_petPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* b = responseObject;
            self.petIMG = [NSString stringWithFormat:@"%@_%@,",a,b];
            [self uploadUserImage];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertView];
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertView];
    }];
}
-(void)updataUserAndPetInFo
{
    
    if (self.petType == PetTypeStyleNone) {
        [self updataUserInfo];
    }else{
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setObject:[self.petDic objectForKey:@"nickname"] forKey:@"nickname"];
        [params setObject:[self.petDic objectForKey:@"gender"] forKey:@"gender"];
        [params setObject:[self.petDic objectForKey:@"type"] forKey:@"type"];
        [params setObject:[self.petDic objectForKey:@"birthdate"] forKey:@"birthdate"];
        [params setObject:self.petIMG forKey:@"img"];
        [params setObject:[self.petDic objectForKey:@"trait"] forKey:@"trait"];
        [params setObject:[self.petDic objectForKey:@"id"] forKey:@"id"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"updatePetinfo" forKey:@"method"];
        [body setObject:@"service.uri.pet_user" forKey:@"service"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self savePetInfo:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
            [self updataUserInfo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertView];
            [hud hide:YES];
        }];
    }
}
-(void)updataUserInfo
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[self.hostDic objectForKey:@"nickname"] forKey:@"nickname"];
    [params setObject:[self.hostDic objectForKey:@"gender"] forKey:@"gender"];
    [params setObject:[self.hostDic objectForKey:@"birthdate"] forKey:@"birthdate"];
    [params setObject:[self.hostDic objectForKey:@"city"] forKey:@"city"];
    [params setObject:@"" forKey:@"backgroundImg"];
    [params setObject:self.hostIMG forKey:@"img"];
    switch (self.petType) {
        case 1:
        {
            [params setObject:@"任狗虐我千百遍，我待狗狗如初恋" forKey:@"signature"];
            [params setObject:@"带着大狗狗遛弯" forKey:@"hobby"];
        }break;
        case 2:
        {
            [params setObject:@"家有喵星人，生活事事顺" forKey:@"signature"];
            [params setObject:@"和小猫一起睡懒觉" forKey:@"hobby"];
        }break;
        case 3:
        {
            [params setObject:@"爱宠之心，人皆有知" forKey:@"signature"];
            [params setObject:@"养宠物" forKey:@"hobby"];
        }break;
        case 4:
        {
            [params setObject:@"做快乐的自己" forKey:@"signature"];
            [params setObject:@"睡懒觉" forKey:@"hobby"];
        }break;
        default:
            break;
    }
    [body setObject:params forKey:@"params"];
    [body setObject:@"updateUser" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [params setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
        [params setObject:[DataStoreManager getMyUserID] forKey:@"id"];
        [DataStoreManager saveUserInfo:params];
        [hud hide:YES];
//        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertView];
        [hud hide:YES];
    }];

}
-(void)saveUserInfo:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
    [DataStoreManager saveUserInfo:dic];
}
-(void)savePetInfo:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
//    [DataStoreManager saveUserInfo:dic];
}
-(void)showAlertView
{
    [hud hide:YES];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
    [alert show];
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next
{
    if (self.petType == PetTypeStyleNone) {
        if (!haveHostImg) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择主人头像" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [self uploadUserImage];
    }else{
        if (!haveHostImg) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择主人头像" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            return;
        }
        if (!havePetImg) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择宠物头像" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [self uploadPetImage];
    }
    [hud show:YES];
}
-(void)btnClicked:(UIButton *)sender
{
    clicked = sender.tag;
    if (sender.tag==2||sender.tag==22) {
        UIImagePickerController * imagePicker;
        if (imagePicker==nil) {
            imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate=self;
            imagePicker.allowsEditing = YES;
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [cameraAlert show];
        }
        
    }
    else
    {
        UIImagePickerController * imagePicker;
        if (imagePicker==nil) {
            imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate=self;
            imagePicker.allowsEditing = YES;
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
            [libraryAlert show];
        }
        
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (clicked==1||clicked==2) {
        [_hostPhoto setImage:headImage];
        haveHostImg = YES;
    }
    else
    {
        [_petPhoto setImage:headImage];
        havePetImg = YES;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
