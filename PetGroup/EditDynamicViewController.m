//
//  EditDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EditDynamicViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "Dynamic.h"
@interface EditDynamicViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
    MBProgressHUD * hud;
}
@property (nonatomic,strong)UITextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;
@end

@implementation EditDynamicViewController

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
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"chat_bg"]];
    [self.view addSubview:bgimgV];
    float diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"新动态"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(240, 0+diffH, 80, 44);
    [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==20.0f) {
//        
//    }
//    else
//    {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5, 128)];
    editIV.image = [UIImage imageNamed:@"edit_bg"] ;
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5,128)];
    _dynamicTV.backgroundColor = [UIColor clearColor];
    _dynamicTV.font = [UIFont systemFontOfSize:17];
    _dynamicTV.delegate = self;
    [self.view addSubview:_dynamicTV];
    
    
    UIImageView* tool = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (diffH==0.0f) {
        tool.image = [UIImage imageNamed:@"table_bg"];
    }
    else
    {
        tool.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        tool.layer.borderColor = [[UIColor grayColor] CGColor];
        tool.layer.borderWidth = 1;
    }
    tool.userInteractionEnabled = YES;
    _dynamicTV.inputAccessoryView = tool;
    
    UIButton* imageB = [UIButton buttonWithType:UIButtonTypeCustom];
    imageB.frame = CGRectMake(270, 4, 35, 35);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 62.75+diffH, 200, 20)];
    _placeholderL.backgroundColor = [UIColor clearColor];
    _placeholderL.textColor = [UIColor grayColor];
    _placeholderL.text = @"今天想跟别人说点什么……";
    [self.view addSubview:_placeholderL];
    
    
    PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoB.frame = CGRectMake(13, 195+diffH, 48.5, 48.5);
    [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
    [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    PhotoB.hidden = YES;
    [self.view addSubview:PhotoB];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在为您发布...";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.dynamicTV becomeFirstResponder];
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
-(void)next
{
    if (_dynamicTV.text.length<=0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"你还没有想好说些什么!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [hud show:YES];
    [self.dynamicTV resignFirstResponder];
    if (self.pictureArray.count>0) {
        [self.view bringSubviewToFront:hud];
        NSMutableArray* imageArray = [[NSMutableArray alloc]init];
        NSMutableArray* nameArray = [[NSMutableArray alloc]init];
        for (int i = 0;i< self.pictureArray.count;i++) {
            [imageArray addObject:((UIImageView*)self.pictureArray[i]).image];
            [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [NetManager uploadImagesWithCompres:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSDictionary* CompresID = responseObject;
            [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                self.imageId = [[NSMutableString alloc]init];
                for (NSString*a in responseObject) {
                    [_imageId appendFormat:@"%@_%@,",[CompresID objectForKey:a],[responseObject objectForKey:a]];
                }
             [self publishWithImageString:_imageId];
             
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else
    {
        [self publishWithImageString:@""];
    }
}
-(void)publishWithImageString:(NSString*)imageID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"" forKey:@"transmitUrl"];
    [params setObject:@"" forKey:@"transmitMsg"];
    [params setObject:@"0" forKey:@"ifTransmitMsg"];
    [params setObject:self.dynamicTV.text forKey:@"msg"];
    [params setObject:imageID forKey:@"imgid"];
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
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString*dateS = [dateF stringFromDate:[NSDate date]];
        NSDictionary* d = [DataStoreManager queryMyInfo];
        NSString* dynamicid = responseObject;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:dynamicid forKey:@"id"];
        [dic setObject:[d objectForKey:@"nickname"] forKey:@"nickname"];
        [dic setObject:[d objectForKey:@"username"] forKey:@"username"];
        [dic setObject:[d objectForKey:@"img"] forKey:@"userImage"];
        [dic setObject:@"false" forKey:@"ifTransmitMsg"];
        [dic setObject:imageID forKey:@"imgid"];
        [dic setObject:self.dynamicTV.text forKey:@"msg"];
        [dic setObject:[d objectForKey:@"id"] forKey:@"userid"];
        [dic setObject:dateS forKey:@"ct"];
        [dic setObject:@"" forKey:@"transmitUrl"];
        [dic setObject:@"3" forKey:@"state"];
        [dic setObject:@"0" forKey:@"reportTimes"];
        [dic setObject:@"" forKey:@"transmitMsg"];
        [dic setObject:@"0" forKey:@"totalPat"];
        [dic setObject:@"0" forKey:@"didIpat"];
        Dynamic* dynamic = [[Dynamic alloc]initWithNSDictionary:dic];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListAddOneDynamic:)]) {
            [self.delegate dynamicListAddOneDynamic:dynamic];
        }
        [self backButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
    }];
}
-(void)getAnActionSheet
{
    if (_pictureArray.count<9) {
        self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [_addActionSheet showInView:self.view];
    }
}
-(void)tapImage:(UIGestureRecognizer*)tapGR
{
    deleteIV = (UIImageView*)tapGR.view;
    self.deleteActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [_deleteActionSheet showInView:self.view];
}
#pragma mark - text view delegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length>2&&[[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
//        textView.text = [textView.text substringToIndex:textView.text.length-2];
//    }
//    if (textView.text.length>0) {
//        _placeholderL.text = @"";
//    }else{
//        _placeholderL.text = @"今天想跟别人说点什么……";
//    }
//    if (textView.text.length>500)
//    {
//        textView.text=[textView.text substringToIndex:500];
//    }
//    
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>2&&[[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
        textView.text = [textView.text substringToIndex:textView.text.length-2];
    }
    if (textView.text.length>0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"今天想跟别人说点什么……";
    }
    if (textView.text.length>500)
    {
        textView.text=[textView.text substringToIndex:500];
    }
    return YES;
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_dynamicTV resignFirstResponder];
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _addActionSheet) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//                    [self presentModalViewController:imagePicker animated:YES];
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
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//                    [self presentModalViewController:imagePicker animated:YES];
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
    }else{
        if (buttonIndex == 0) {
            NSUInteger index = [_pictureArray indexOfObject:deleteIV];
            [UIView animateWithDuration:0.3 animations:^{
                PhotoB.frame = ((UIImageView*)[_pictureArray lastObject]).frame;
                for (int i = _pictureArray.count-1; i > index ; i-- ) {
                    ((UIImageView*)_pictureArray[i]).frame = ((UIImageView*)_pictureArray[i-1]).frame;
                }
            }];
            [deleteIV removeFromSuperview];
            [_pictureArray removeObject:deleteIV];
            PhotoB.hidden = NO;
        }
    }
    [self.dynamicTV becomeFirstResponder];
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.pictureArray == nil) {
        self.pictureArray = [[NSMutableArray alloc]init];
    }
    PhotoB.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
    imageV.userInteractionEnabled = YES;
    imageV.image = selectImage;
    [self.view addSubview:imageV];
    if (PhotoB.frame.origin.x < 250) {
        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }else{
        PhotoB.frame = CGRectMake(13, 280.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }
    [_pictureArray addObject:imageV];
    if (_pictureArray.count == 9) {
        PhotoB.hidden = YES;
    }
    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [imageV addGestureRecognizer:tapGR];
    [self.dynamicTV becomeFirstResponder];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
@end
