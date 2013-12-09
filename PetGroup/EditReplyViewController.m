//
//  EditReplyViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-11-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EditReplyViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
#import "FastTextView.h"
#import "SlideAttachmentCell.h"
#import "EmotionAttachmentCell.h"
#import <CoreText/CoreText.h>
#import "UIImage-Extensions.h"
#import "NSAttributedString+TextUtil.h"
#import "TextConfig.h"
#import "IdentifyingString.h"
@interface EditReplyViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
    MBProgressHUD * hud;
    
    BOOL isAddSlide;
    
    CGFloat origin_y;
    NSMutableString * stringToPublish;
    NSMutableArray * tagArray;
    NSMutableArray * tagPositionArray;
}
@property (nonatomic,strong)FastTextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;

@end

@implementation EditReplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.replyID = @"";
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
    
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

//    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
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
    [titleLabel setText:@"回复"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
//    if (diffH==0.0f) {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImage * bgImage = [[UIImage imageNamed:@"edit_bg"]
                         stretchableImageWithLeftCapWidth:0 topCapHeight:65];
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5, self.view.frame.size.height-(diffH+55.57+253+44))];
    editIV.image = bgImage ;
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[FastTextView alloc]initWithFrame:CGRectMake(13.75, 55.75+diffH, 292.5,self.view.frame.size.height-(diffH+55.57+253+44))];
//    _dynamicTV.backgroundColor = [UIColor redColor];
    _dynamicTV.font = [UIFont systemFontOfSize:16];
    //    _dynamicTV.delegate = self;
    
    _dynamicTV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dynamicTV.delegate = (id<FastTextViewDelegate>)self;
    _dynamicTV.attributeConfig=[TextConfig editorAttributeConfig];
    _dynamicTV.delegate = (id<FastTextViewDelegate>)self;
    _dynamicTV.placeHolder=@"好好写点^_^";
    [_dynamicTV setFont:[UIFont systemFontOfSize:16]];
    _dynamicTV.pragraghSpaceHeight=10;
    _dynamicTV.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_dynamicTV];
    
    
    UIImageView* tool = [[UIImageView alloc]initWithFrame:CGRectMake(0, _dynamicTV.frame.origin.y+_dynamicTV.frame.size.height+2, 320, 44)];
    tool.backgroundColor = [UIColor clearColor];
    //    if (diffH==0.0f) {
    //        tool.image = [UIImage imageNamed:@"table_bg"];
    //    }
    //    else
    //    {
    //        tool.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    //        tool.layer.borderColor = [[UIColor grayColor] CGColor];
    //        tool.layer.borderWidth = 1;
    //    }
    tool.userInteractionEnabled = YES;
    //    _dynamicTV.inputAccessoryView = tool;
    [self.view addSubview:tool];
    imageB = [UIButton buttonWithType:UIButtonTypeCustom];
    imageB.frame = CGRectMake(270, 4, 32, 32);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(220,-2 , 45, 45)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [tool addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253) WithSendBtn:NO];
    theEmojiView.delegate = self;
    [self.view addSubview:theEmojiView];
    theEmojiView.hidden = YES;
    
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
-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!ifEmoji) {
        [_dynamicTV resignFirstResponder];
        ifEmoji = YES;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        [self showEmojiScrollView];
        
    }
    else
    {
        [_dynamicTV becomeFirstResponder];
        ifEmoji = NO;
        theEmojiView.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
}
-(void)showEmojiScrollView
{
    theEmojiView.hidden = NO;
    [theEmojiView setFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253)];
}
-(void)backBtnDo
{
    if (_dynamicTV.text.length>=1) {
        _dynamicTV.text = [_dynamicTV.text substringToIndex:(_dynamicTV.text.length-1)];
    }
    
}
-(void)deleteEmojiStr
{
    //    if (self.textView.text.length>=1) {
    //        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    //    }
}
-(NSString *)selectedEmoji:(NSString *)ssss
{
    //	if (_dynamicTV.text == nil) {
    //		_dynamicTV.text = ssss;
    //	}
    //	else {
    UITextRange *selectedTextRange = [_dynamicTV selectedTextRange];
    if (!selectedTextRange) {
        UITextPosition *endOfDocument = [_dynamicTV endOfDocument];
        selectedTextRange = [_dynamicTV textRangeFromPosition:endOfDocument toPosition:endOfDocument];
    }
    UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
    
    //        unichar attachmentCharacter = FastTextAttachmentCharacter;
    [_dynamicTV replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"%@",ssss]];
    
    //    startPosition=[_fastTextView positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
    UITextPosition *endPosition = [_dynamicTV positionFromPosition:startPosition offset:1];
    selectedTextRange = [_dynamicTV textRangeFromPosition:startPosition toPosition:endPosition];
    
    
    NSMutableAttributedString *mutableAttributedString=[_dynamicTV.attributedString mutableCopy];
    
    NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
    NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
    
    if (en < st) {
        return 0;
    }
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
    if (mutableAttributedString) {
        _dynamicTV.attributedString = mutableAttributedString;
    }
    //		_dynamicTV.text = [_dynamicTV.text stringByAppendingString:ssss];
    //	}
    
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)next
{
    if (_dynamicTV.text.length<4||[IdentifyingString isValidateAllSpace:_dynamicTV.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不写点内容能行么，至少4个字吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [hud show:YES];
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
{
    if (![self.replyID isEqualToString:@""]) {
        NSString* st = [NSString stringWithFormat:@"<p style=\"color:gray\">回复%d楼</p>",self.row];
        imageString =[NSString stringWithFormat:@"%@%@",st,imageString];
    }
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([[TempData sharedInstance] getMyUserID]&&[[[TempData sharedInstance] getMyUserID] isKindOfClass:[NSNull class]]) {
        [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userid"];
    }
    [params setObject:self.articleID forKey:@"noteId"];
    [params setObject:imageString forKey:@"content"];
    [params setObject:self.replyID forKey:@"pid"];
    NSMutableDictionary* body = [NSMutableDictionary dictionary];
    [body setObject:params forKey:@"params"];
    [body setObject:@"replyNote" forKey:@"method"];
    [body setObject:@"service.uri.pet_bbs" forKey:@"service"];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        NSLog(@"stringuu = %@",responseObject);
        if (self.delegate&&[self.delegate respondsToSelector:@selector(editReplyViewDidEdit)]) {
            [self.delegate editReplyViewDidEdit];
        }
        [self backButton:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:@"发布失败,请稍候再试!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertV show];
        [hud hide:YES];
    }];
}
-(void)getAnActionSheet
{
    NSArray *fileArray=[NSAttributedString getAttachmentsForNewFileName:_dynamicTV.attributedString];
    if (fileArray.count>0) {
        NSArray * dd = fileArray[0];
        if (dd.count>=3) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加了3张图片了，休息一会吧，或者换个楼层发吧~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
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
//        //        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
//        //        wrapper.filename = [[rep url] lastPathComponent];
//        UIImage *img=[UIImage imageWithData:data];
    
        NSString *newfilename=[NSAttributedString scanAttachmentsForNewFileName:_dynamicTV.attributedString];
        
        NSString *path = [RootDocPath stringByAppendingPathComponent:@"UploadTopicPics"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:path] == NO)
        {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        //        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString * _documentDirectory = [[NSString alloc] initWithString:[_paths objectAtIndex:0]];
        
        
        UIImage *thumbimg=[img imageByScalingProportionallyToSize:CGSizeMake(320,640)];
        
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
- (void)keyboardWillShow:(NSNotification *)notification {
    
    ifEmoji = NO;
    theEmojiView.hidden = YES;
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    
    
}
-(void)scrollToBottomw
{
    CGPoint bottomOffset = CGPointMake(0, _dynamicTV.contentSize.height - _dynamicTV.bounds.size.height);
    [_dynamicTV setContentOffset:bottomOffset animated:YES];
}
@end
