//
//  MapViewController.m
//  CoffeeShop
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    __weak IBOutlet MKMapView *myMapView;
    CLPlacemark *storePlaceMark;
    CLLocationCoordinate2D coordinate;
}
@end

@implementation MapViewController

-(void)viewDidLoad{

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, width, 50)];
    [self.view addSubview:naviBar];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] init];
    naviItem.leftBarButtonItem = backItem;
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

    locationManager = [[CLLocationManager alloc] init];
//    [locationManager requestWhenInUseAuthorization];

    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.delegate = self;

    geoCoder = [[CLGeocoder alloc] init];

    [self getCoordinateFromAddress];

//    [locationManager startUpdatingLocation];
}

-(void)getCoordinateFromAddress{


    [geoCoder geocodeAddressString:self.address completionHandler:^(NSArray *placemarks, NSError *error) {

        NSLog(@"geocodeAddressString %lu", placemarks.count);

        if(error == nil && placemarks.count > 0)
        {
            CLPlacemark *placeMark = placemarks[0];
            storePlaceMark = placeMark;
            NSLog(@"getCoordinateFromAddress %@", placeMark.location);
            NSLog(@"getCoordinateFromAddress %@", storePlaceMark.location);


            coordinate = storePlaceMark.location.coordinate;

            MyAnnotation *annotation1 = [[MyAnnotation alloc]
                                         initWithCoordinate:coordinate
                                         title:self.shopName
                                         subtitle:@""];
            [myMapView addAnnotation:annotation1];

                //以使用者位置為地圖中心點
            NSLog(@"userLocation %.8f", storePlaceMark.location.coordinate.latitude);
            [myMapView setCenterCoordinate:storePlaceMark.location.coordinate animated:YES];

            /*
             MKCoordinateRegion region;
             region.center = userLocation.location.coordinate;
             MKCoordinateSpan mapSpan;
             mapSpan.latitudeDelta = 0.005;
             mapSpan.longitudeDelta = 0.005;
             region.span = mapSpan;
             mapView.region = region;
             */

            MKCoordinateRegion region;
            region.center = storePlaceMark.location.coordinate;
            MKCoordinateSpan mapSpan;
            mapSpan.latitudeDelta = 0.005;
            mapSpan.longitudeDelta = 0.005;
            region.span = mapSpan;
            myMapView.region = region;
                //        mapView.region =
                //        MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000 );
            [myMapView setRegion:region animated:YES];
        }
        
    }];
}

-(void)backButtonPressed{

    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
