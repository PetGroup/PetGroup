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
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude=0;
    theCoordinate.longitude=0;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //赋予个初值
    self.userPoint=[[CLLocation alloc]initWithLatitude:0 longitude:0];
}
-(void)getUserLocation
{
    if (_mapView.userLocation.location.coordinate.latitude>0) {
        CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:_mapView.userLocation.location.coordinate.latitude longitude:_mapView.userLocation.location.coordinate.longitude];
        self.userPoint = newLocation;
       // _mapView = nil;
    }
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userPoint = userLocation.location;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
