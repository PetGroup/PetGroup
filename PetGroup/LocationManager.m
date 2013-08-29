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
    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
//    MKCoordinateSpan theSpan;
//    //地图的范围 越小越精确
//    theSpan.latitudeDelta=0.05;
//    theSpan.longitudeDelta=0.05;
//    MKCoordinateRegion theRegion;
//    theRegion.center=theCoordinate;
//    theRegion.span=theSpan;
//    [_mapView setRegion:theRegion];
    _mapView.showsUserLocation = NO;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //赋予个初值
    self.userPoint=[[CLLocation alloc]initWithLatitude:0 longitude:0];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userPoint = userLocation.location;
    NSLog(@"hhkkkk:%f,%f",[self getLatitude],[self getLongitude]);
    _mapView.showsUserLocation = NO;
    
}
-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
//    _mapView.showsUserLocation = NO;
}
-(void)startCheckLocationWithSuccess:(void(^)(double lat,double lon))success Failure:(void(^)(void))failure
{
        _mapView.showsUserLocation = YES;
        dispatch_queue_t queue = dispatch_queue_create("com.pet.getLatLon", NULL);
        dispatch_async(queue, ^{
            NSTimeInterval hh = [[NSDate date] timeIntervalSince1970];
            while (true) {
                usleep(100000);
                NSTimeInterval jj = [[NSDate date] timeIntervalSince1970];
                if (!_mapView.showsUserLocation) {
                    success(self.userPoint.coordinate.latitude,self.userPoint.coordinate.longitude);
                    break;
                }
                if (jj-hh>20) {
                    _mapView.showsUserLocation = NO;
                    failure();
                    break;
                }
            }
        });

    
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
