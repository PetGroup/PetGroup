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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"上传头像"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel * hostLael = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 295, 30)];
    [hostLael setText:@"上传真实头像，拉近真实的距离"];
    [hostLael setBackgroundColor:[UIColor clearColor]];
    [hostLael setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:hostLael];
    
    UIView * bg1 = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 300, 130)];
    [bg1 setBackgroundColor:[UIColor whiteColor]];
    [bg1 setAlpha:0.5];
    bg1.layer.cornerRadius = 5;
    [self.view addSubview:bg1];
    
    self.hostPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 110, 110)];
    [_hostPhoto setImage:[UIImage imageNamed:@"zhuren"]];
    [self.view addSubview:_hostPhoto];
    
    UILabel* hostL = [[UILabel alloc]initWithFrame:CGRectMake(7, 85, 96, 17)];
    hostL.text = @"主淫头像";
    hostL.font = [UIFont boldSystemFontOfSize:13];
    hostL.textAlignment = UITextAlignmentCenter;
    hostL.textColor = [UIColor whiteColor];
    hostL.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
    [_hostPhoto addSubview:hostL];
    
    UIButton * tpic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tpic1 setFrame:CGRectMake(160, 117, 115, 30)];
    [tpic1 setImage:[UIImage imageNamed:@"xiangche-normal"] forState:UIControlStateNormal];
    [tpic1 setImage:[UIImage imageNamed:@"xiangche-click"] forState:UIControlStateHighlighted];
    [tpic1 setTag:1];
    [tpic1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tpic1];
    
    UIButton * tpic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tpic2 setFrame:CGRectMake(160, 182, 115, 30)];
    [tpic2 setImage:[UIImage imageNamed:@"paizhao-normal"] forState:UIControlStateNormal];
    [tpic2 setImage:[UIImage imageNamed:@"paizhao-click"] forState:UIControlStateHighlighted];
    [tpic2 setTag:2];
    [tpic2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tpic2];
    
    if (self.petType == PetTypeStyleNone) {
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(0, 0, 80, 44);
        [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.view addSubview:backButton];
        [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UILabel * petLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 295, 30)];
        [petLabel setText:@"爱宠得真实头像，方便小伙伴找到它"];
        [petLabel setBackgroundColor:[UIColor clearColor]];
        [petLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.view addSubview:petLabel];
        
        UIView * bg2 = [[UIView alloc] initWithFrame:CGRectMake(10, 260, 300, 130)];
        [bg2 setBackgroundColor:[UIColor whiteColor]];
        [bg2 setAlpha:0.5];
        bg2.layer.cornerRadius = 5;
        [self.view addSubview:bg2];
        
        self.petPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, 270, 110, 110)];
        [_petPhoto setImage:[UIImage imageNamed:@"chongwu"]];
        [self.view addSubview:_petPhoto];
        
        UILabel* petL = [[UILabel alloc]initWithFrame:CGRectMake(7, 85, 96, 17)];
        petL.text = @"宠物头像";
        petL.font = [UIFont boldSystemFontOfSize:13];
        petL.textAlignment = UITextAlignmentCenter;
        petL.textColor = [UIColor whiteColor];
        petL.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
        [_petPhoto addSubview:petL];
        
        UIButton * tpic21 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tpic21 setFrame:CGRectMake(160, 280, 115, 30)];
        [tpic21 setImage:[UIImage imageNamed:@"xiangche-normal"] forState:UIControlStateNormal];
        [tpic21 setImage:[UIImage imageNamed:@"xiangche-click"] forState:UIControlStateHighlighted];
        [tpic21 setTag:21];
        [tpic21 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tpic21];
        
        UIButton * tpic22 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tpic22 setFrame:CGRectMake(160, 340, 115, 30)];
        [tpic22 setImage:[UIImage imageNamed:@"paizhao-normal"] forState:UIControlStateNormal];
        [tpic22 setImage:[UIImage imageNamed:@"paizhao-click"] forState:UIControlStateHighlighted];
        [tpic22 setTag:22];
        [tpic22 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tpic22];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在发送，请稍后";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - upload image 
-(void)uploadUserImage
{
    [NetManager uploadImageWithCompres:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* a = [operation responseString];
        [NetManager uploadImage:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* b = [operation responseString];
            self.hostIMG = [NSString stringWithFormat:@"%@_%@,",a,b];
            [self updataUserAndPetInFo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertView];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertView];
    }];
}
-(void)uploadPetImage
{
    [NetManager uploadImageWithCompres:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* a = [operation responseString];
        [NetManager uploadImage:_hostPhoto.image WithURLStr:BaseUploadImageUrl ImageName:@"" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* b = [operation responseString];
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
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self savePetInfo:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
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
    [params setObject:self.hostIMG forKey:@"img"];
    switch (self.petType) {
        case 1:
        {
            [params setObject:@"" forKey:@"signature"];
            [params setObject:@"" forKey:@"hobby"];
        }break;
        case 2:
        {
            [params setObject:@"" forKey:@"signature"];
            [params setObject:@"" forKey:@"hobby"];
        }break;
        case 3:
        {
            [params setObject:@"" forKey:@"signature"];
            [params setObject:@"" forKey:@"hobby"];
        }break;
        case 4:
        {
            [params setObject:@"" forKey:@"signature"];
            [params setObject:@"" forKey:@"hobby"];
        }break;
        default:
            break;
    }
    [body setObject:params forKey:@"params"];
    [body setObject:@"saveUserinfo2" forKey:@"method"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveUserInfo:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
        [hud hide:YES];
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertView];
        [hud hide:YES];
    }];

}
-(void)saveUserInfo:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
//    [DataStoreManager saveUserInfo:dic];
}
-(void)savePetInfo:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
//    [DataStoreManager saveUserInfo:dic];
}
-(void)showAlertView
{
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
        if ([_hostPhoto.image isEqual:[UIImage imageNamed:@"zhuren"]]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择主人头像" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [self uploadUserImage];
    }else{
        if ([_hostPhoto.image isEqual:[UIImage imageNamed:@"zhuren"]]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择主人头像" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            return;
        }
        if ([_petPhoto.image isEqual:[UIImage imageNamed:@"chongwu"]]) {
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
            [self presentModalViewController:imagePicker animated:YES];
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
            [self presentModalViewController:imagePicker animated:YES];
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
    }
    else
    {
        [_petPhoto setImage:headImage];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
