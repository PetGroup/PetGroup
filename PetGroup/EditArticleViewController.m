//
//  EditArticleViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EditArticleViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "FastTextView.h"
#import "IdentifyingString.h"
//#import "ImageAttachmentCell.h"
#import "SlideAttachmentCell.h"
#import "EmotionAttachmentCell.h"
#import <CoreText/CoreText.h>
#import "UIImage-Extensions.h"
#import "NSAttributedString+TextUtil.h"
#import "TextConfig.h"
@interface EditArticleViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
    MBProgressHUD * hud;
    
    BOOL isAddSlide;

    CGFloat origin_y;
    NSMutableString * stringToPublish;
    NSMutableArray * tagArray;
    NSMutableArray * tagPositionArray;
//    FastTextView *_dynamicTV;
}
@property (nonatomic,strong)UITextField* titleTF;
@property (nonatomic,strong)FastTextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;
@end

@implementation EditArticleViewController

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
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"chat_bg"]];
    [self.view addSubview:bgimgV];
    
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
//    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
//    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
//    [self.view addSubview:backButton];
//    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 5+diffH, 70, 34);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    if (diffH==0.0f) {
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    }
    [cancelBtn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"新话题"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    if (diffH==0.0f) {
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImage * bgImage = [[UIImage imageNamed:@"shurukuang.png"]
               stretchableImageWithLeftCapWidth:0 topCapHeight:65];
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5, self.view.frame.size.height-(diffH+55.57+253+44))];
    editIV.image = bgImage ;
    [self.view addSubview:editIV];
    
    self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(22.75, 63.75+diffH, 272.5, 20)];
    _titleTF.placeholder = @"标题";
    _titleTF.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleTF];
    
    self.dynamicTV = [[FastTextView alloc]initWithFrame:CGRectMake(13.75, 91.75+diffH, 292.5,self.view.frame.size.height-(diffH+55.57+253+44)-20-20)];
//    _dynamicTV.backgroundColor = [UIColor clearColor];
//    _dynamicTV.font = [UIFont systemFontOfSize:16];
//    _dynamicTV.delegate = self;
    
    _dynamicTV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dynamicTV.delegate = (id<FastTextViewDelegate>)self;
    _dynamicTV.attributeConfig=[TextConfig editorAttributeConfig];
    _dynamicTV.delegate = (id<FastTextViewDelegate>)self;
    _dynamicTV.placeHolder=@"好好写点^_^";
    [_dynamicTV setFont:[UIFont systemFontOfSize:17]];
    _dynamicTV.pragraghSpaceHeight=15;
    _dynamicTV.backgroundColor=[UIColor clearColor];

    [self.view addSubview:_dynamicTV];
    [_titleTF becomeFirstResponder];
    
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
    imageB.frame = CGRectMake(270, 4, 32, 32);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
//    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 95.75+diffH, 200, 20)];
//    self.placeholderL.font = [UIFont systemFontOfSize:16];
//    _placeholderL.backgroundColor = [UIColor clearColor];
//    _placeholderL.textColor = [UIColor grayColor];
//    _placeholderL.text = @"今天想跟别人说点什么……";
//    [self.view addSubview:_placeholderL];
    
    
    PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoB.frame = CGRectMake(13, 195+diffH, 48.5, 48.5);
    [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
    [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    PhotoB.hidden = YES;
 //   [self.view addSubview:PhotoB];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在为您发布...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
//    [[TempData sharedInstance] Panned:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
}

-(void)next
{
//    if (_dynamicTV.text.length<=0||_titleTF.text.length<=0) {
//        return;
//    }
//    if (self.pictureArray.count>0) {
//        NSMutableArray* imageArray = [[NSMutableArray alloc]init];
//        NSMutableArray* nameArray = [[NSMutableArray alloc]init];
//        self.imageId = [[NSMutableString alloc]init];
//        for (int i = 0;i< self.pictureArray.count;i++) {
//            [imageArray addObject:((UIImageView*)self.pictureArray[i]).image];
//            [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//        [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//            for (NSString*a in responseObject) {
//                [_imageId appendFormat:@"<img src=\""BaseImageUrl"%@"@"\">",[responseObject objectForKey:a]];
//            }
//         [self publishWithImageString:_imageId];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    }else{
//        [self publishWithImageString:nil];
//    }
    
//    if ([IdentifyingString isValidateAllSpace:_titleTF.text]) {
//
//    }
    if (_titleTF.text.length<3||[IdentifyingString isValidateAllSpace:_titleTF.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"写个标题吧，最少3个字吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_dynamicTV.text.length<4||[IdentifyingString isValidateAllSpace:_dynamicTV.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不写点内容能行么，至少4个字吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [hud show:YES];
    [_titleTF resignFirstResponder];
    [_dynamicTV resignFirstResponder];
    NSArray *fileArray=[NSAttributedString getAttachmentsForNewFileName:_dynamicTV.attributedString];
    if (fileArray.count>0) {
        NSMutableArray *uploadImageArray = [NSMutableArray array];
        NSArray * filenameArray = [fileArray objectAtIndex:0];
        NSArray * fileIndexArray = [fileArray objectAtIndex:1];
        NSMutableArray *imgWidthArray = [NSMutableArray array];
        NSMutableArray *imgHeightArray = [NSMutableArray array];
        for (NSString * fileName in filenameArray) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UploadTopicPics/%@",fileName]];
            UIImage * tempImg = [UIImage imageWithContentsOfFile:path];
            [imgWidthArray addObject:[NSString stringWithFormat:@"%f",280.0f]];
            [imgHeightArray addObject:[NSString stringWithFormat:@"%f",tempImg.size.height*280/tempImg.size.width]];
            [uploadImageArray addObject:tempImg];
        }
        [self uploadForMixingTypePics:uploadImageArray PicsName:filenameArray PositionArray:fileIndexArray Width:imgWidthArray Height:imgHeightArray];
        NSLog(@"theArray:%@",fileArray);

    }
    else
    {
        [self publishWithImageString:_dynamicTV.text];
    }
}
-(void)uploadForMixingTypePics:(NSArray *)imageArray PicsName:(NSArray *)picsNameArray PositionArray:(NSArray *)positionArray Width:(NSArray *)widthArray Height:(NSArray *)heightArray
{
    [NetManager uploadWaterMarkImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:picsNameArray TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSMutableArray * idArray = [NSMutableArray array];
        for (NSString * name in picsNameArray) {
            [idArray addObject:[responseObject objectForKey:name]];
        }
        NSString * finalStr = [self publishFinalTextWithImageIDArray:idArray imageSizeWidthArray:widthArray imageSizeHeightArray:heightArray];
        [self publishWithImageString:finalStr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(NSString *)publishFinalTextWithImageIDArray:(NSArray *)imageIDArray imageSizeWidthArray:(NSArray *)imgWidthArray imageSizeHeightArray:(NSArray *)imgHeightArray
{
    NSMutableString * finalT = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<p>%@</p>",_dynamicTV.text]];
    NSMutableArray * tagArraye = [NSMutableArray array];
    for (int i = 0; i<imageIDArray.count;i++) {
        [tagArraye addObject:[NSString stringWithFormat:@"</p><a href=\"%@%@\"><img align=\"center\" width=\"%d\" height=\"%d\" src=\"%@%@\"></a><p>",BaseImageUrl,[imageIDArray objectAtIndex:i],[[imgWidthArray objectAtIndex:i]intValue],[[imgHeightArray objectAtIndex:i]intValue],BaseImageUrl,[imageIDArray objectAtIndex:i]]];
    }
    unichar attachmentCharacter = FastTextAttachmentCharacter;
    NSArray * rrr = [finalT componentsSeparatedByString:[NSString stringWithCharacters:&attachmentCharacter length:1]];
    int tempCount = rrr.count;
    NSLog(@"rrr:%@",rrr);
    NSMutableArray * ggg = [NSMutableArray arrayWithArray:rrr];
    for (int i = 0; i<tagArraye.count; i++) {
        [ggg insertObject:tagArraye[tagArraye.count-i-1] atIndex:tempCount-i-1];
        NSLog(@"ssss:%@",ggg);
    }
    NSMutableString * ddd = [[NSMutableString alloc] init];
    for (NSString * uu in ggg) {
        [ddd appendString:uu];
//        [ddd stringByAppendingString:uu];
        NSLog(@"ysysysy:%@",uu);
    }
    NSLog(@"finalString:%@",ddd);
    return ddd;
}
-(void)publishWithImageString:(NSString*)imageString
{//body={"method":"sendNote","token":"","params":{"userId":"33333","forumId":"DBEF25E53AA5401384CFC60603CC3FC7","name":"子集4的帖子","content":"子集4的帖子"}}
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([[TempData sharedInstance] getMyUserID]&&[[[TempData sharedInstance] getMyUserID] isKindOfClass:[NSNull class]]) {
        [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userid"];
    }
    [params setObject:self.forumId forKey:@"forumId"];
    [params setObject:_titleTF.text forKey:@"name"];
    [params setObject:imageString forKey:@"content"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"sendNote" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        NSLog(@"stringuu = %@",responseObject);
        [self upOneDymicWithNoteID:responseObject];
        [self getMyArticleWithId:responseObject];
        
        [self backButton:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getMyArticleWithId:(NSString*)articleId
{
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString*dateS = [dateF stringFromDate:[NSDate date]];
    NSDictionary* d = [DataStoreManager queryMyInfo];
    NSString* articleid = articleId;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:articleid forKey:@"id"];
    [dic setObject:[d objectForKey:@"nickname"] forKey:@"nickname"];
    [dic setObject:[d objectForKey:@"img"] forKey:@"userIcon"];
    [dic setObject:[d objectForKey:@"id"] forKey:@"userId"];
    [dic setObject:self.titleTF.text forKey:@"name"];
    [dic setObject:dateS forKey:@"ct"];
    [dic setObject:dateS forKey:@"et"];
    [dic setObject:@"0" forKey:@"cTotalReply"];
    [dic setObject:@"0" forKey:@"clientCount"];
    [dic setObject:self.forumId forKey:@"forumId"];
    [dic setObject:@"0" forKey:@"isEute"];
    [dic setObject:@"0" forKey:@"isTop"];
    [dic setObject:@"0" forKey:@"totalReply"];
    [dic setObject:@"0" forKey:@"type"];
    Article* aricle = [[Article alloc]initWithDictionnary:dic];
    if (self.delegate&& [self.delegate respondsToSelector:@selector(editArticleViewDidEdit:)]) {
        [self.delegate editArticleViewDidEdit:aricle];
    }
}
-(void)upOneDymicWithNoteID:(NSString*)noteID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:[NSString stringWithFormat:@"bbsNoteId_%@",noteID] forKey:@"transmitUrl"];
    [params setObject:[NSString stringWithFormat:@"《%@》",self.titleTF.text] forKey:@"msg"];
    [params setObject:@"true" forKey:@"ifTransmitMsg"];
    [params setObject:[NSString stringWithFormat:@"我在%@发布了一篇帖子:",self.forumName] forKey:@"transmitMsg"];
    [params setObject:@"" forKey:@"imgid"];
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
        NSLog(@"dynamicID = %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getAnActionSheet
{
    NSArray *fileArray=[NSAttributedString getAttachmentsForNewFileName:_dynamicTV.attributedString];
    if (fileArray.count>0) {
        NSArray * dd = fileArray[0];
        if (dd.count>=5) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加了5张图片了，休息一会吧，或者换个楼层发吧~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
//    if (_pictureArray.count<=8) {
        self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [_addActionSheet showInView:self.view];
//    }
}
-(void)tapImage:(UIGestureRecognizer*)tapGR
{
    deleteIV = (UIImageView*)tapGR.view;
    self.deleteActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [_deleteActionSheet showInView:self.view];
}
#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"今天想跟别人说点什么……";
    }
    
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_titleTF resignFirstResponder];
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
                    isAddSlide=true;
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
                    isAddSlide=true;
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
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        CIImage *image = nil;
//        image = [CIImage imageWithCGImage:gotImage.CGImage
//                                  options:@{kCIImageProperties : [info  objectForKey:UIImagePickerControllerMediaMetadata]}];
        [self _addAttachmentFromAsset:gotImage];
    } else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
        [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
                 resultBlock:^(ALAsset *asset){
                     // This get called asynchronously (possibly after a permissions question to the user).
                     ALAssetRepresentation *rep = [asset defaultRepresentation];
                     NSMutableData *data = [NSMutableData dataWithLength:[rep size]];
                     NSError *error = nil;
                     if ([rep getBytes:[data mutableBytes] fromOffset:0 length:[rep size] error:&error] == 0) {
                         NSLog(@"error getting asset data %@", [error debugDescription]);
                     } else {
                         UIImage *img=[UIImage imageWithData:data];
                         [self _addAttachmentFromAsset:img];
                     }
                     
                 }
                failureBlock:^(NSError *error){
                    NSLog(@"error finding asset %@", [error debugDescription]);
                }];
    }
    
//    if (self.pictureArray == nil) {
//        self.pictureArray = [[NSMutableArray alloc]init];
//    }
//    PhotoB.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [_dynamicTV becomeFirstResponder];
//    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
//    imageV.userInteractionEnabled = YES;
//    imageV.image = selectImage;
//    [self.view addSubview:imageV];
//    if (PhotoB.frame.origin.x < 250) {
//        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
//    }else{
//        PhotoB.frame = CGRectMake(13, 250.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
//    }
//    [_pictureArray addObject:imageV];
//    if (_pictureArray.count == 8) {
//        PhotoB.hidden = YES;
//    }
//    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
//    [imageV addGestureRecognizer:tapGR];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [_dynamicTV becomeFirstResponder];
}
#pragma mark -
#pragma mark fastTextViewDelegate

- (BOOL)fastTextViewShouldBeginEditing:(FastTextView *)textView {
    return YES;
}

- (BOOL)fastTextViewShouldEndEditing:(FastTextView *)textView {
    return YES;
}

- (void)fastTextViewDidBeginEditing:(FastTextView *)textView {
}

- (void)fastTextViewDidEndEditing:(FastTextView *)textView {
}

- (void)fastTextViewDidChange:(FastTextView *)textView {
    UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
    if (!selectedTextRange) {
        UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
        selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
    }
    UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
    
    startPosition=[_dynamicTV positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
    UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
    selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
    
    
//    NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
//    NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
    
}

- (void)fastTextView:(FastTextView*)textView didSelectURL:(NSURL *)URL {
    
}



- (void)attachSlide:(id)sender;
{
    //    [self _logScrollInfo:@"fsfsdfsd"];
    //    NSLog(@"editor frame %@",NSStringFromCGRect(_editor.frame));
    //    return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    //    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
    //    [picker release];
    //
    //       [[OUIAppController controller] presentPopover:popover fromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //[picker release];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)_addAttachmentFromAsset:(UIImage *)img;
{
//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    NSMutableData *data = [NSMutableData dataWithLength:[rep size]];
//    
//    
//    
//    NSError *error = nil;
//    if ([rep getBytes:[data mutableBytes] fromOffset:0 length:[rep size] error:&error] == 0) {
//        NSLog(@"error getting asset data %@", [error debugDescription]);
//    } else {
        //        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        //        wrapper.filename = [[rep url] lastPathComponent];
        
        NSString *newfilename=[NSAttributedString scanAttachmentsForNewFileName:_dynamicTV.attributedString];
        
        NSString *path = [RootDocPath stringByAppendingPathComponent:@"UploadTopicPics"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:path] == NO)
        {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }

        
//        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString * _documentDirectory = [[NSString alloc] initWithString:[_paths objectAtIndex:0]];
        
        
        UIImage *thumbimg=[img imageByScalingProportionallyToSize:CGSizeMake(640,1136)];
        
        NSString *pngPath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",newfilename]];
        
        //[[AppDelegate documentDirectory] stringByAppendingPathComponent:@"tmp.jpg"];
        
        
        [UIImageJPEGRepresentation(thumbimg,0.7)writeToFile:pngPath atomically:YES];
        
        UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
        if (!selectedTextRange) {
            UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
            selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
        }
        UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
        
        unichar attachmentCharacter = FastTextAttachmentCharacter;
        [_dynamicTV replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"\n%@\n",[NSString stringWithCharacters:&attachmentCharacter length:1]]];
        
        startPosition=[_dynamicTV positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
        UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
        selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
        
        
        NSMutableAttributedString *mutableAttributedString=[_dynamicTV.attributedString mutableCopy];
        
        NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
        NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
        
        if (en < st) {
            return;
        }
        
        //        [stringToPublish insertString:@"</p><img src=\"565656\">" atIndex:st];
        
        NSUInteger contentLength = [[_dynamicTV.attributedString string] length];
        if (en > contentLength) {
            en = contentLength; // but let's not crash
        }
        if (st > en)
            st = en;
        NSRange cr = [[_dynamicTV.attributedString string] rangeOfComposedCharacterSequencesForRange:(NSRange){ st, en - st }];
        if (cr.location + cr.length > contentLength) {
            cr.length = ( contentLength - cr.location ); // but let's not crash
        }
        
        if(isAddSlide){
            
            FileWrapperObject *fileWp = [[FileWrapperObject alloc] init];
            [fileWp setFileName:newfilename];
            [fileWp setFilePath:pngPath];
            
            SlideAttachmentCell *cell = [[SlideAttachmentCell alloc] initWithFileWrapperObject:fileWp] ;
            //ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] init];
            cell.isNeedThumb=TRUE;
            cell.thumbImageWidth=200.0f;
            cell.thumbImageHeight=200.0f;
//            cell.txtdesc=@"幻灯片测试";
            
            [mutableAttributedString addAttribute: FastTextAttachmentAttributeName value:cell  range:cr];
            
            //[mutableAttributedString addAttribute:fastTextAttachmentAttributeName value:cell  range:selectedTextRange];
            
            
        }else{
            //            ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] initWithFileWrapper:wrapper] ;
            //            //ImageAttachmentCell *cell = [[ImageAttachmentCell alloc] init];
            //            cell.isNeedThumb=TRUE;
            //            cell.thumbImageWidth=200.0f;
            //            cell.thumbImageHeight=200.0f;
            //
            //            [mutableAttributedString addAttribute: fastTextAttachmentAttributeName value:cell  range:cr];
        }
        
        
        
        [tagPositionArray addObject:[NSNumber numberWithInteger:st]];
        [tagArray addObject:@"</p><img src=\"big pic\"><p>"];
        if (mutableAttributedString) {
            _dynamicTV.attributedString = mutableAttributedString;
        }
        [self performSelector:@selector(scrollToBottomw) withObject:nil afterDelay:0.3];
        //[_editor setValue:attachment forAttribute:OAAttachmentAttributeName inRange:selectedTextRange];
        
        
//    }
}
-(void)scrollToBottomw
{
    CGPoint bottomOffset = CGPointMake(0, _dynamicTV.contentSize.height - _dynamicTV.bounds.size.height);
    [_dynamicTV setContentOffset:bottomOffset animated:YES];
}
@end
