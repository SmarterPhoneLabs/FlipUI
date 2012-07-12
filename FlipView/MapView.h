//
//  MapView.h
//  JailBookings
//
//  Created by Johnathan Rossitter on 5/25/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import"MyAnnotation.h"
#import "MapOptions.h"

@interface MapView : UIViewController
{
    IBOutlet MKMapView *mvMain;
    IBOutlet UIActivityIndicatorView *avtivityMain;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avtivityMain;
@property (retain, nonatomic) IBOutlet MKMapView *mvMain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBooking:(int)Booking_ID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMissing:(int)Missing_ID;
@end
