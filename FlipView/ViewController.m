//
//  ViewController.m
//  FlipView
//
//  Created by johnathan rossitter on 6/30/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SQLSTUDIOMyService.h"
#import "SQLSTUDIOServices.h"
#import "AsyncImageView.h"
#import "BackSideView.h"

CGRect  tempRect;


@implementation ViewController

@synthesize tileWidthTemplate;
@synthesize tileHeightTemplate;
@synthesize tileMargin;
@synthesize svMain;
@synthesize sbMain;
@synthesize itemList;
@synthesize searchTimer;

int unlockSize;
int lastX;
int lastY;
int colCount;
int rowCount;

CGFloat     lastScale;
CGPoint     lastPoint;

bool IsSearching;

//search delegate
-(void)doneEditing
{
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    searchBar.showsScopeBar = YES;  
    [searchBar sizeToFit];  
    
    [searchBar setShowsCancelButton:YES animated:YES];  
    

    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if(iPad == YES)
    {
        searchBar.frame = CGRectMake(0, 0, 768, 44);
    }
    else
    {
        searchBar.frame = CGRectMake(0, 0, 320, 44);       
    }
    
    return YES;  
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    searchBar.showsScopeBar = NO;  
    [searchBar sizeToFit];  
    
    [searchBar setShowsCancelButton:NO animated:YES];  
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if(iPad == YES)
    {
        sbMain.frame =  CGRectMake(0, 0, 768, 44);
    }
    else
    {
        sbMain.frame =  CGRectMake(0, 0, 320, 44);        
    }
    
    
    
    return YES;  
}  

-(void)searchTimerDidFinish:(NSTimer *) timer
{

    NSLog(@"Search Now...");
    searchTimer = [[NSTimer alloc]init];
}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    [searchTimer invalidate];
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(searchTimerDidFinish:)
                                                     userInfo:nil
                                                      repeats:NO];   
    

    
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneEditing)];
    
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
}


//-(void) handleSingleTap:(UITapGestureRecognizer *)gr 
//{
//    switch (tileHeightTemplate) {
//        case 25:
//            tileHeightTemplate = 50;
//            tileWidthTemplate = 50;
//            break;
//        case 50:
//            tileHeightTemplate = 100;
//            tileWidthTemplate = 100;
//            break;            
//        case 100:
//            tileHeightTemplate = 200;
//            tileWidthTemplate = 200;
//            break;            
//        case 200:
//            tileHeightTemplate = 25;
//            tileWidthTemplate = 25;
//            break;            
//            
//        default:
//            break;
//    }
//    [self arrangeTiles];
//
//}




-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Flip Tabs";
        itemList    = [[NSMutableArray alloc] init];
        
        
//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        
//        singleTap.numberOfTapsRequired = 2;
//        singleTap.numberOfTouchesRequired = 1;
//        [self.view addGestureRecognizer: singleTap];
//        [singleTap release];
        
        

        
    }
    return self;
    
}



-(void)arrangeTiles
{
    colCount =0;
    lastX = 0;
    lastY = 0;
    
    for(AsyncImageView *myPOI in itemList)
    {
    
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            switch (tileHeightTemplate) {
                    
                    //                
                case 200:
                    tileMargin =  42;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 3)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 768,  3500+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;                
                    
                case 100:
                    tileMargin = 5;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 7)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 768,  1024+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                case 50:
                    tileMargin =  8;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 13)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 768,  1024+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                    
                    
                case 25:
                    tileMargin =  8;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 23)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 768,  1024+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                    
                default:
                    break;
            }
        }
        else
        {
            switch (tileHeightTemplate) {
                    
                    //                
                case 200:
                    tileMargin =  60;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 1)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 320,  480+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;                
                    
                case 100:
                    tileMargin = 5;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 3)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 320,  480+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                case 50:
                    tileMargin =  12;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);
                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 5)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 320,  480+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                    
                    
                case 25:
                    tileMargin =  10;
                    myPOI.frame  = CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate);
                    
                    lastX = lastX + tileWidthTemplate + tileMargin;
                    colCount++;
                    if(colCount == 9)
                    {
                        rowCount++;
                        lastX = 0;
                        colCount = 0;
                        lastY = lastY + tileHeightTemplate + tileMargin;
                        
                        CGRect contentRect = CGRectMake(0, 0, 320,  480+ (tileHeightTemplate * rowCount));
                        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
                        
                    }
                    break;
                    
                    
                default:
                    break;
            }
        } 
    }
}

-(void)handleList:(id)result
{
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
    
    [itemList removeAllObjects];
    
    NSMutableArray *myData = (NSMutableArray*)result;
    for(SQLSTUDIOtbl_Booking_Result *myPOI in myData)
    {
        NSString *myTilePath = [NSString stringWithFormat:@"http://www.jail-bookings.com/%@",myPOI.ssImage_Booking_Image_2];
         NSURL *url = [NSURL URLWithString:myTilePath];
        AsyncImageView *myTile;
        myTile = [[AsyncImageView alloc] initWithFrame:CGRectMake(lastX + tileMargin, lastY + tileMargin,tileWidthTemplate,tileHeightTemplate)];
        myTile.useGlass = YES;   
        [myTile loadImageFromURL:url];
        myTile.delegate = self;
        myTile.tileID = myPOI.Booking_ID;
        myTile.useRotation = YES;
        
        [self.svMain addSubview:myTile];
        myTile.personName = @"";                

        
        [itemList addObject:myTile];
        [myTile release];
    }
        [self arrangeTiles];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *theScroll = (UIScrollView*)self.svMain;
    
    UIImage *img = [UIImage imageNamed:@"image-1-1024x960.jpg"];
    [theScroll setBackgroundColor:[UIColor colorWithPatternImage:img]];

    
    theScroll.decelerationRate = UIScrollViewDecelerationRateNormal;
	
    tileWidthTemplate = 100;
    tileHeightTemplate = 100;
 
    colCount =0;
    lastX = 0;
    lastY = 0;

    
    
}
-(void)touchedOK:(AsyncImageView *) controller
{   
    if(controller.flipModeOn == YES)
    {
        UIScrollView *theScroll = (UIScrollView*)self.svMain;
        [theScroll setScrollEnabled: NO];
        for(AsyncImageView *myPOI in itemList)
        {
            if(myPOI.tileID != controller.tileID)
            {
                myPOI.isTouchable = NO;
                [myPOI blastOff];
            }
        }
        
        BackSideView *bSV = [[BackSideView alloc] initWithFrame:CGRectMake(0,0, 320, 480) andTag:controller.tileID];
        controller.backSideView = bSV;
        [controller addSubview:controller.backSideView];
        [controller.imageView setAlpha:0.1];
        [bSV release];
        //[controller.lblMain setText:controller.personName];

        tempRect = controller.frame;
        
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
                    UIScrollView *svX = (UIScrollView*)self.svMain;
        if(iPad == YES)
        {

            [controller maximize:svX.contentOffset.y];
        }
        else
        {
            [controller maximize:svX.contentOffset.y];
        }
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:controller cache:YES]; 
        [UIView setAnimationDuration:1.5];
        [UIView commitAnimations]; 
    }
    else
    {
        UIScrollView *theScroll = (UIScrollView*)self.svMain;
        [theScroll setScrollEnabled: YES];
        
        [UIView beginAnimations:@"animation" context:nil];
        [controller minimize:tempRect];
        [controller.imageView setAlpha:1.0];
        [controller addSubview:controller.imageView ];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:controller  cache:YES]; 
        [UIView setAnimationDuration:1.5];
        
        [UIView commitAnimations]; 
        
        for(AsyncImageView *myPOI in itemList)
        {
            if(myPOI.tileID != controller.tileID)
            {
                myPOI.isTouchable = YES;
                [myPOI blastBack];
                [self.svMain addSubview:myPOI];
            }
            else
            {
                [myPOI.backSideView remove];
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    NSString *markets = @"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18";
    [service List_All_tbl_Booking_Weekly:self action:@selector(handleList:) Markets:markets];
    [service release];

}
- (void)viewDidUnload
{
    [self setSbMain:nil];
    [self setSvMain:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [itemList release];
    [sbMain release];
    [svMain release];
    [searchTimer release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else 
    {
        return YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for(AsyncImageView *myPOI in itemList)
    {
        [myPOI setOpacity:0.65];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(AsyncImageView *myPOI in itemList)
    {
        [myPOI setOpacity:1.0];
        [myPOI setBackgroundColor:[UIColor clearColor]];
    }
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif

    if(iPad == YES)
    {
        sbMain.frame =  CGRectMake(0, 0, 768, 44);
    }
    else
    {
        sbMain.frame =  CGRectMake(0, 0, 320, 44);        
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{  

}

@end
