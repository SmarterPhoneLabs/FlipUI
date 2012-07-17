//
//  MapView.m
//  JailBookings
//
//  Created by Johnathan Rossitter on 5/25/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MapView.h"
#import "AppDelegate.h"
#import "SQLSTUDIOServices.h"
#import "BackSideView.h"
#import "MapOptions.h"
#import "BackSideView.h"
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344
int selectedLocation;
int selectedX;

@implementation MapView
@synthesize mvMain;
@synthesize avtivityMain;

bool allowTouch = YES;

BackSideView *bSV;

-(void)touchedOK:(BackSideView *) controller
{ 
    
    [UIView beginAnimations:@"animation" context:nil];
    [bSV removeFromSuperview];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES]; 
    [UIView setAnimationDuration:1.0];
    [UIView commitAnimations];  
}
-(void)showDetails:(id)sender
{
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    

    if(iPad)
    {
        bSV  = [[BackSideView alloc] initWithFrame:CGRectMake(0,0, 768, 1024) andTag:selectedLocation];
    }
    else 
    {
        bSV = [[BackSideView alloc] initWithFrame:CGRectMake(0,0, 320, 480) andTag:selectedLocation];                
    }
    bSV.parentController = self;
     
    bSV.delegate = self;
    [UIView beginAnimations:@"animation" context:nil];
    [self.view addSubview:bSV];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES]; 
    [UIView setAnimationDuration:1.0];
    [UIView commitAnimations];
    [bSV release];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MyAnnotation *mA = (MyAnnotation*)view.annotation;
    BOOL test = [mA isKindOfClass:[MyAnnotation class]];
    if(test == YES)
    {
        selectedLocation = mA.locationID;
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MKPinAnnotationView *pinAnnotation = nil;
    if(annotation != mvMain.userLocation) 
    {
        static NSString *defaultPinID = @"myPin";
        pinAnnotation = (MKPinAnnotationView *)[mvMain dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinAnnotation == nil )
            pinAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        pinAnnotation.canShowCallout = YES;
        MyAnnotation *ma = (MyAnnotation*)annotation;

                pinAnnotation.image = [delegate scaleMe:[delegate getImage:[NSString stringWithFormat:@"http://www.jail-bookings.com/%@", ma.imgURL] size:CGSizeMake(0, 0) isWebBased:YES] toSize:CGSizeMake(24, 24)  ];


        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [infoButton addTarget:self
                       action:@selector(showDetails:)
             forControlEvents:UIControlEventTouchUpInside];
        
        pinAnnotation.rightCalloutAccessoryView = infoButton;
        
    }
    
    return pinAnnotation;
}

-(void)gumballSingle:(int)Booking_ID
{
//    [activityMain startAnimating];
    [mvMain removeAnnotations:mvMain.annotations];
    

    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;

    [service Get_tbl_Booking:self action:@selector(handleListSingle:) Booking_ID:Booking_ID];
    [service release];
    
    mvMain.showsUserLocation= YES;
}

-(void)gumballSingleMissing:(int)Missing_ID
{
    //[activityMain startAnimating];
    [mvMain removeAnnotations:mvMain.annotations];
    
    
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    
    [service Get_tbl_Missing_Child:self action:@selector(handleListSingleMissing:) Child_ID:Missing_ID];
    [service release];
    
    mvMain.showsUserLocation= YES;
}

-(void)gumball
{
   // [activityMain startAnimating];
    [mvMain removeAnnotations:mvMain.annotations];

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    NSString *markets = [delegate getMarkets];
    [service List_Geo_Locations_Of_Bookings:self action:@selector(handleList:) Markets:markets];
    [service release];
    
    mvMain.showsUserLocation= YES;
}


-(void)handleListSingle:(id)result
{
    [avtivityMain stopAnimating];
    if([result isKindOfClass:[NSError class]]) 
    {
        NSError *MyError = (NSError*) result;
        if(MyError.code == 410)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
		return;
	}
    
    SQLSTUDIOtbl_Booking_Result *myPOI = (SQLSTUDIOtbl_Booking_Result*)result;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *crimeTypes = [delegate getMapCrimeTypes];
    NSRange textRange;
    textRange =[crimeTypes rangeOfString:[NSString stringWithFormat:@"%i,",myPOI.Crime_Type]];
    
    if(textRange.location != NSNotFound)
    {
        
        //Does contain the substring
    

        double longitude = [myPOI.Booking_Long doubleValue];
        double latitude = [myPOI.Booking_Lat doubleValue];
        
        MyAnnotation *annotation =[[MyAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = [NSString stringWithFormat:@"%@ %@",myPOI.First_Name,myPOI.Last_Name];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
        double distanceMiles = (distance / 1609.344);
        
        annotation.subtitle = [NSString stringWithFormat:@"%f miles",distanceMiles];
        annotation.pinColor = MKPinAnnotationColorPurple;
        annotation.locationID = myPOI.Booking_ID;
            annotation.locationType = myPOI.Crime_Type;
        
        [newLocation release];
        
        [mvMain addAnnotation:annotation];
        [annotation release];
    }
  //  [activityMain stopAnimating];
}

-(void)handleListSingleMissing:(id)result
{
        [avtivityMain stopAnimating];
    
    if([result isKindOfClass:[NSError class]]) 
    {
        NSError *MyError = (NSError*) result;
        if(MyError.code == 410)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
		return;
	}
    
    SQLSTUDIOtbl_Missing_Child_Result *myPOI = (SQLSTUDIOtbl_Missing_Child_Result*)result;
    
    double longitude = [myPOI.Missing_Long doubleValue];
    double latitude = [myPOI.Missing_Lat doubleValue];
    
    MyAnnotation *annotation =[[MyAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = [NSString stringWithFormat:@"%@ %@",myPOI.First_Name,myPOI.Last_Name];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
    double distanceMiles = (distance / 1609.344);
    
    annotation.subtitle = [NSString stringWithFormat:@"%f miles",distanceMiles];
    annotation.pinColor = MKPinAnnotationColorPurple;
    annotation.locationID = myPOI.Child_ID;
            annotation.locationType = 6;

    
    [newLocation release];
    
    [mvMain addAnnotation:annotation];
    [annotation release];
    
   // [activityMain stopAnimating];
}

-(void)handleList:(id)result
{

        [avtivityMain stopAnimating];
    if([result isKindOfClass:[NSError class]]) 
    {
        NSError *MyError = (NSError*) result;
        if(MyError.code == 410)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
		return;
	}

    NSMutableArray *myData = (NSMutableArray*)result;
    for(SQLSTUDIOtbl_Booking_Result *myPOI in myData)
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *crimeTypes = [delegate getMapCrimeTypes];
        NSRange textRange;
        textRange =[crimeTypes rangeOfString:[NSString stringWithFormat:@"%i,",myPOI.Crime_Type]];
        
        if(textRange.location != NSNotFound)
        {

        double longitude = [myPOI.Booking_Long doubleValue];
        double latitude = [myPOI.Booking_Lat doubleValue];
        
        MyAnnotation *annotation =[[MyAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = [NSString stringWithFormat:@"%@ %@",myPOI.First_Name,myPOI.Last_Name];

        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
        double distanceMiles = (distance / 1609.344);
        
        annotation.subtitle = [NSString stringWithFormat:@"%f miles",distanceMiles];
       //annotation.pinColor = MKPinAnnotationColorPurple;
        annotation.locationID = myPOI.Booking_ID;
        annotation.locationType = 999;
        annotation.imgURL = myPOI.Crime_Type_Image;

        
        [newLocation release];
        
        [mvMain addAnnotation:annotation];
        [annotation release];
        }
    }
    //[activityMain stopAnimating];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        mvMain = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
       [self.view addSubview:mvMain];
        selectedX = 0;
        allowTouch = YES;
        self.title = @"Crime Map";
        CLLocationCoordinate2D zoomLocation;
        
        
        CLLocationManager  *locationManager;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
        locationManager.distanceFilter = kCLDistanceFilterNone; 
        [locationManager startUpdatingLocation];
        
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        zoomLocation.latitude = coordinate.latitude;
        zoomLocation.longitude = coordinate.longitude;
    
        

       [self gumball];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 90*METERS_PER_MILE, 90*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mvMain regionThatFits:viewRegion];                
        [mvMain setRegion:adjustedRegion animated:YES]; 
        
    [locationManager release];
  
        
        
        UIImage *image = [UIImage imageNamed:@"cogs.png"];
        UIButton *myCustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myCustomButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
        [myCustomButton setImage:image forState:UIControlStateNormal];
        [myCustomButton addTarget:self action:@selector(showMapOptions) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:myCustomButton];
        self.navigationItem.rightBarButtonItem = button;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        
        [button release];
        [myCustomButton release];
        [image release];
        


    }
    return self;
}
-(void)showMapOptions
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif   
    [UIView beginAnimations:@"animation" context:nil];        
    MapOptions *newView2;
    if(iPad == YES)
    {
        newView2 = [[MapOptions alloc] initWithNibName:@"MapOptions_iPad" bundle:nil];              
    }
    else
    {
        newView2 = [[MapOptions alloc] initWithNibName:@"MapOptions" bundle:nil];              
    }        
    
    [self.navigationController  pushViewController:newView2 animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO]; 
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    [newView2 release];  
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBooking:(int)Booking_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        selectedX = Booking_ID;
        allowTouch = NO;
        self.title = @"Crime Map";
        CLLocationCoordinate2D zoomLocation;

        
        
        CLLocationManager  *locationManager;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
        locationManager.distanceFilter = kCLDistanceFilterNone; 
        [locationManager startUpdatingLocation];
        
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        zoomLocation.latitude = coordinate.latitude;
        zoomLocation.longitude = coordinate.longitude;
        [locationManager release];
        
        //      zoomLocation.latitude = 32.513236;
        //        zoomLocation.longitude = -93.749428;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 30*METERS_PER_MILE, 30*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mvMain regionThatFits:viewRegion];                
        [mvMain setRegion:adjustedRegion animated:YES]; 
        [self gumballSingle:Booking_ID];
        
        
        

  

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMissing:(int)Missing_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        selectedX = Missing_ID;
        
        allowTouch = NO;
        self.title = @"Crime Map";
        CLLocationCoordinate2D zoomLocation;
        
        
        CLLocationManager  *locationManager;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
        locationManager.distanceFilter = kCLDistanceFilterNone; 
        [locationManager startUpdatingLocation];
        
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        zoomLocation.latitude = coordinate.latitude;
        zoomLocation.longitude = coordinate.longitude;
        [locationManager release];
        
  //      zoomLocation.latitude = 32.513236;
//        zoomLocation.longitude = -93.749428;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 30*METERS_PER_MILE, 30*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mvMain regionThatFits:viewRegion];                
        [mvMain setRegion:adjustedRegion animated:YES]; 
        [self gumballSingleMissing:Missing_ID];

    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

        [self gumball];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

        [self gumball];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMvMain:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [mvMain release];
    //[bSV release];
    [super dealloc];
}


@end
