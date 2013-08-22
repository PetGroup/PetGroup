//
//  LocationManager.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-16.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
@interface LocationManager : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocation *startPoint;
    //  CLLocationManager *_locationManager;
    MKMapView * _mapView;
}
@property(nonatomic,strong)CLLocation *userPoint;
-(void)initLocation;
-(void)getUserLocation;
@end
