//
//  LocationManager.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-16.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@end

@implementation LocationManager
static  LocationManager *sharedInstance=nil;

+(LocationManager *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
           
        }
        return sharedInstance;
    }
}
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
}
-(void)initLocation
{
//    CLLocationCoordinate2D theCoordinate;
//    theCoordinate.latitude=0;
//    theCoordinate.longitude=0;
    lat = 0.0;
    lon = 0.0;
    goUpdate = NO;
    self.locType = @"open";
    needManualFail = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=0.5;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation]; // 开始定位
    
//    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
////    MKCoordinateSpan theSpan;
////    //地图的范围 越小越精确
////    theSpan.latitudeDelta=0.05;
////    theSpan.longitudeDelta=0.05;
////    MKCoordinateRegion theRegion;
////    theRegion.center=theCoordinate;
////    theRegion.span=theSpan;
////    [_mapView setRegion:theRegion];
//    _mapView.showsUserLocation = NO;
//    _mapView.delegate = self;
//    [self.view addSubview:_mapView];
    //赋予个初值
    self.userPoint=[[CLLocation alloc]initWithLatitude:0 longitude:0];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userPoint = userLocation.location;
    lat = self.userPoint.coordinate.latitude;
    lon = self.userPoint.coordinate.longitude;
    NSLog(@"hhkkkk:%f,%f",[self getLatitude],[self getLongitude]);
    _mapView.showsUserLocation = NO;
    
}
-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
//    _mapView.showsUserLocation = NO;
}
-(void)startCheckLocationWithSuccess:(void(^)(double lat,double lon))success Failure:(void(^)(void))failure
{
//        _mapView.showsUserLocation = YES;
    needManualFail = NO;
    [locationManager startUpdatingLocation];
        dispatch_queue_t queue = dispatch_queue_create("com.pet.getLatLon", NULL);
        dispatch_async(queue, ^{
            NSTimeInterval hh = [[NSDate date] timeIntervalSince1970];
            while (true) {
                usleep(100000);
                NSTimeInterval jj = [[NSDate date] timeIntervalSince1970];
                if (lat!=0.0&&lon!=0.0) {
                    [[TempData sharedInstance] setLat:lat Lon:lon];


//                    dispatch_async(dispatch_get_main_queue(), ^{
                        //            UIAlertView *succeful=[[UIAlertView alloc]initWithTitle:nil message:@"录音压缩完成,可以上传!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //            [succeful show];
                        //            self.textView.text = @"";
                        success(lat,lon);
                        
//                    });
//                    success(lat,lon);
                    lat = 0.0;
                    lon = 0.0;
                    break;
                }
                if (needManualFail) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //            UIAlertView *succeful=[[UIAlertView alloc]initWithTitle:nil message:@"录音压缩完成,可以上传!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //            [succeful show];
                        //            self.textView.text = @"";
                        failure();

                    });
                    break;
                }
//                if (jj-hh>10) {
//                    _mapView.showsUserLocation = NO;
//                    [locationManager startUpdatingLocation];
//                }
                if (jj-hh>20) {
//                    _mapView.showsUserLocation = NO;
                    [locationManager stopUpdatingLocation];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //            UIAlertView *succeful=[[UIAlertView alloc]initWithTitle:nil message:@"录音压缩完成,可以上传!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //            [succeful show];
                        //            self.textView.text = @"";
                        failure();
                        
                    });
                    break;
                }
            }
        });
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    needManualFail = NO;
    CLLocationCoordinate2D mylocation = newLocation.coordinate;
    Location loc;
    loc.lat = mylocation.latitude;
    loc.lng = mylocation.longitude;
    loc=transformFromWGSToGCJ(loc);

    lat = loc.lat;
    lon = loc.lng;
    [locationManager stopUpdatingLocation];
}
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    needManualFail = YES;
    switch([error code]) {
        case kCLErrorDenied:
        {
            //Access denied by user
            errorString = @"您没有允许宠物圈获取您的位置，请到系统的设置-隐私-定位服务中允许宠物圈使用您的位置";
            //Do something...
            if (![self.locType isEqualToString:@"open"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];

            }
        }
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"地理位置获取失败,请稍后重试";
            if (![self.locType isEqualToString:@"open"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            //Do something else...
            break;
        default:
            errorString = @"地理位置获取失败，请稍后重试";
            if (![self.locType isEqualToString:@"open"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            break;
    }


}


-(double)getLatitude
{
    return self.userPoint.coordinate.latitude;
}
-(double)getLongitude
{
    return self.userPoint.coordinate.longitude;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
