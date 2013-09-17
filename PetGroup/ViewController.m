//
//  ViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-13.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DataStoreManager setDefaultDataBase:@"LocalDataStore" AndDefaultModel:@"LocalStore"];
  //  [self postTest];
   // [self testUpload];
  //  [self testUploadMoreThanOnePics];
//    [MagicalRecord setDefaultModelNamed:@"LocalStore.momd"];
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"LocalDataStore.sqlite"];
//    NSDate * date = [NSDate date];
//    [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:@"Tolecen" forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
////    double dd = [[NSDate date] timeIntervalSince1970];
////    NSLog(@"time Before:%f",dd);
//    for (int i = 0; i<1000; i++) {
//        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"222%d",i],@"username",[NSString stringWithFormat:@"aaaaaaaa%d",i],@"nickname",@"sigq",@"signature", nil];
//        //    [DataStoreManager storeNewMsgs:dict senderType:COMMONUSER];
//         //   [DataStoreManager addFriendToLocal:dict];
//        //    [DataStoreManager updateFriendInfo:dict ForUser:[dict objectForKey:@"username"]];
//        [DataStoreManager updateFriendInfo:dict ForUser:[NSString stringWithFormat:@"ddd%d",i]];
//    }
//    NSLog(@"time After:%f, %f",[[NSDate date] timeIntervalSince1970],[[NSDate date] timeIntervalSince1970]-dd);
    
//    [DataStoreManager qureyAllFriends];
//    [DataStoreManager addFriendToLocal:[NSDictionary dictionaryWithObjectsAndKeys:@"wwow",@"username",@"eeee",@"nickname", nil]];
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)doit:(id)sender
{
    [MagicalRecord cleanUp];
    [MagicalRecord setDefaultModelNamed:@"Sacew.momd"];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"1234567890.sqlite"];
    [DataStoreManager addFriendToLocal:[NSDictionary dictionaryWithObjectsAndKeys:@"ppppppppp",@"username",@"77777777",@"nickname", nil]];
}
-(void)postTest
{
//    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
////    [userInfoDict setObject:@"asw" forKey:@"username"];
////    [userInfoDict setObject:@"111111" forKey:@"password"];
////    //            [userInfoDict setObject:@"31" forKey:@"imgId"];
////    [userInfoDict setObject:@"2" forKey:@"type"];
//    [postDict setObject:userInfoDict forKey:@"params"];
//    [postDict setObject:@"1" forKey:@"channel"];
//    [postDict setObject:@"open" forKey:@"method"];
//    [postDict setObject:@"" forKey:@"token"];
//    [postDict setObject:@"wwwwww" forKey:@"mac"];
//    [postDict setObject:@"iphone" forKey:@"imei"];
//    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];

//    long long a = (long long)(cT*1000);
//    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"createTime"];

   NSDictionary * postDict = [MakeDict dictWithUsualElements:@[@"1",@"open",@"776ffca1-6eeb-493a-8c44-8cf1afa6bfe6",@"wwww",@"iphone",@""] ForKeys:@[@"channel",@"method",@"token",@"mac",@"imei",@"connectTime"] AndParams:@[@"asw",@"111111",@"31",@"2"] ForParamsKey:@[@"username",@"password",@"imgId",@"type"]];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * hhh = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"ssss:%@",hhh);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"netManagerError:%@",error);
    }];
    
    [NetManager downloadImageWithBaseURLStr:BaseImageUrl ImageId:@"413" success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 70, 70)];
        [imageView setImage:image];
        [self.view addSubview:imageView];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"DownLoadError:%@",error);
    }];
    
}
-(void)testUpload
{
    [NetManager uploadImage:[UIImage imageNamed:@"222222.jpg"] WithURLStr:BaseUploadImageUrl ImageName:@"2222.jpg" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        NSLog(@"uploadImg:%@",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}
-(void)testUploadMoreThanOnePics
{
//    NSArray * imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"222222.jpg"],[UIImage imageNamed:@"333.png"],[UIImage imageNamed:@"4444.png"], [UIImage imageNamed:@"tupian1.png"],[UIImage imageNamed:@"tupian2.png"],[UIImage imageNamed:@"tupian3.png"],nil];
//    NSArray * imageNameArray = [NSArray arrayWithObjects:@"222222.jpg",@"333.jpg",@"444.jpg",@"tupian1.jpg",@"tupian2.jpg",@"tupian3.jpg", nil];
//    [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:imageNameArray Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    } Success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
//       // NSString *response = [operation responseString];
//        NSLog(@"uploadImg:%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error:%@",error);
//    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
