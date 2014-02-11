//
//  QRCustomViewControllerViewController.m
//  PetGroup
//
//  Created by wangxr on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "QRCustomViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QRCodeReader.h>
#import <TwoDDecoderResult.h>
@interface QRCustomViewController ()<UIAlertViewDelegate, DecoderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    float diffH;
    NSTimer * timer;
}
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic,retain)UIImageView * anminIV ;

@end

@implementation QRCustomViewController
- (void)dealloc
{
    NSLog(@"dealloc");
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self timerDown];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.2 target:self selector:@selector(timerDown) userInfo:nil repeats:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCapture];
    diffH = [Common diffHeight:self];
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
//    [self.view addSubview:TopBarBGV];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 2+diffH, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = @"二维码";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * blackVL = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + diffH, 40, self.view.frame.size.height-44-diffH)];
    blackVL.backgroundColor = [UIColor blackColor];
    blackVL.alpha = 0.7;
    [self.view addSubview:blackVL];
    
    UIView * blackVR = [[UIView alloc]initWithFrame:CGRectMake(280, 44 + diffH, 40, self.view.frame.size.height-44-diffH)];
    blackVR.backgroundColor = [UIColor blackColor];
    blackVR.alpha = 0.7;
    [self.view addSubview:blackVR];
    
    UIView * blackVT = [[UIView alloc]initWithFrame:CGRectMake(40, 44 + diffH, 240, 50)];
    blackVT.backgroundColor = [UIColor blackColor];
    blackVT.alpha = 0.7;
    [self.view addSubview:blackVT];
    
    UIView * blackVD = [[UIView alloc]initWithFrame:CGRectMake(40, 334 + diffH, 240, self.view.frame.size.height-304-diffH)];
    blackVD.backgroundColor = [UIColor blackColor];
    blackVD.alpha = 0.7;
    [self.view addSubview:blackVD];
    
    UIImageView * LTimageV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 94 + diffH, 10, 10)];
    LTimageV.image = [UIImage imageNamed:@"QRCodeCorner_LeftTop"];
    [self.view addSubview:LTimageV];
    UIImageView * RTimageV = [[UIImageView alloc]initWithFrame:CGRectMake(270, 94 + diffH, 10, 10)];
    RTimageV.image = [UIImage imageNamed:@"QRCodeCorner_RightTop"];
    [self.view addSubview:RTimageV];
    UIImageView * LDimageV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 324 + diffH, 10, 10)];
    LDimageV.image = [UIImage imageNamed:@"QRCodeCorner_LeftButtom"];
    [self.view addSubview:LDimageV];
    UIImageView * RDimageV = [[UIImageView alloc]initWithFrame:CGRectMake(270, 324 + diffH, 10, 10)];
    RDimageV.image = [UIImage imageNamed:@"QRCodeCorner_RightButtom"];
    [self.view addSubview:RDimageV];
    
    self.anminIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 94 + diffH, 320, 12)];
    _anminIV.image = [UIImage imageNamed:@"QRCodeScanLine"];
    [self.view addSubview:_anminIV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)timerDown
{
    [UIView animateWithDuration:3 animations:^{
        _anminIV.frame = CGRectMake(0, 322 + diffH, 320, 12);
    } completion:^(BOOL finished) {
        _anminIV.frame = CGRectMake(0, 94 + diffH, 320, 12);
    }];
}
- (void)back
{
//    if (_delegate && [_delegate respondsToSelector:@selector(customViewControllerDidCancel:)]) {
//        [self.delegate customViewControllerDidCancel:self];
//    }
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.captureSession addOutput:captureOutput];
    
    NSString* preset = 0;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
         supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame1280x720]) {
            // NSLog(@"960");
            preset = AVCaptureSessionPresetiFrame1280x720;
        }
    if (!preset) {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetHigh;
    }
    self.captureSession.sessionPreset = preset;
    
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    [self.captureSession startRunning];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    CGRect rect = CGRectMake( 96*9/4 + diffH*9/4,40 *9/4 , 240*9/4, 240*9/4);//创建矩形框
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(cgImage, rect)];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSLog(@"%f,%f",image.size.width,image.size.height);
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}

- (void)decodeImage:(UIImage *)image
{
    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];
    
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self decodeImage:image];
}

#pragma mark - DecoderDelegate

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [self.captureSession stopRunning];
    [self.view.layer removeAllAnimations];


    if (_delegate && [_delegate respondsToSelector:@selector(customViewController:didScanResult:)]) {
            [self.delegate customViewController:self didScanResult:result.text];
    }
    

}
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    
}
@end
