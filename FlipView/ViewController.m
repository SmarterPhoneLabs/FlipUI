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


#define REFRESH_HEADER_HEIGHT_IPHONE 75.0f
#define REFRESH_HEADER_HEIGHT_IPAD 150.0f



@implementation ViewController
@synthesize lblSelectMarket;


@synthesize tileWidthTemplate;
@synthesize tileHeightTemplate;
@synthesize tileMargin;
@synthesize imgScrollArrow;
@synthesize lblLastRefreshDate;
@synthesize lblReleaseToRefresh;
@synthesize svMain;
@synthesize sbMain;
@synthesize itemList;
@synthesize searchTimer;
@synthesize scMain;
@synthesize penrose;

int unlockSize;
int lastX;
int lastY;
int colCount;
int rowCount;

CGFloat     lastScale;
CGPoint     lastPoint;

bool debugMode = YES;
CGRect  tempRect;


bool IsSearching;



-(void)doLog:(NSString*)LogMessage
{
    if(debugMode == YES)
    {
        NSLog(LogMessage);
        
    }
}

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
    [self doLog:@"Search Now..."];


    searchTimer = [[NSTimer alloc]init];
    
    
    for(AsyncImageView *myPOI in itemList)
    {
        [myPOI blastOff];
    }
    [itemList removeAllObjects];
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *markets = [delegate getMarkets];
    if(markets.length ==0 || [markets isEqualToString:@"0"])
    {
        lblSelectMarket.hidden = NO;
    }
    else
    {
        lblSelectMarket.hidden = YES;
    }
    if(sbMain.text.length == 0)
    {
        [service List_All_tbl_Booking_Weekly_V2:self action:@selector(handleList:) Markets:markets];
    }
    else 
    {
        [service Search_Bookings_V2:self action:@selector(handleList:) Phrase:sbMain.text Markets:markets] ;
    }
    [service release];
    
    [lblLastRefreshDate setAlpha:1.0];
    [lblReleaseToRefresh setAlpha:1.0];
    [imgScrollArrow setAlpha:1.0];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:0.75
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 
                 [lblLastRefreshDate setAlpha:0.0];
                 [lblReleaseToRefresh setAlpha:0.0];
                 [imgScrollArrow setAlpha:0.0];
             }
                             completion:nil];
            
        });
    });
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if(iPad == YES)
    {
        CGRect contentRect = CGRectMake(0, 0, 768, 1024);
        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
    }
    else
    {
        CGRect contentRect = CGRectMake(0, 0, 320, 480);
        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
    } 
    
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




-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"Flip Tabs";
        itemList    = [[NSMutableArray alloc] init];
        
        
        
    }
    return self;

}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Flip Tabs";
        itemList    = [[NSMutableArray alloc] init];
        


    }
    return self;
    
}



-(void)arrangeTiles
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad == YES)
    {
                CGRect contentRect = CGRectMake(0, 0, 768,  1024);
                    [(UIScrollView*)self.svMain setContentSize: contentRect.size];
    }
    else
    {
                CGRect contentRect = CGRectMake(0, 0, 320,  480);                
        [(UIScrollView*)self.svMain setContentSize: contentRect.size];
    }

    
    rowCount = 0;
    colCount =0;
    lastX = 0;
    lastY = 0;
    [self doLog:[NSString stringWithFormat:@"item count %i", itemList.count]];
    for(AsyncImageView *myPOI in itemList)
    {
    

        
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
                    tileMargin = 7;
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

        [self doLog:[NSString stringWithFormat:@"Scroller Height %f",self.svMain.contentSize.height]];

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
    for(SQLSTUDIOtbl_Booking_Result_V2 *myPOI in myData)
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
        myTile.isAd = myPOI.Is_Ad;
        myTile.hits = [[NSNumber alloc] initWithInt:myPOI.Views];
        myTile.market = myPOI.Market_ID;
        myTile.name = [NSString stringWithFormat:@"%@ %@",myPOI.First_Name, myPOI.Last_Name] ;
        myTile.sex = myPOI.Sex;
        myTile.Booking_Date = myPOI.Date_Of_Offense;
        myTile.crimeTypeImageLink = [NSString stringWithFormat:@"http://jail-bookings.com/%@",myPOI.Crime_Type_Image];
       // [self doLog:        myTile.crimeTypeImageLink];
        
        [self.svMain addSubview:myTile];
        myTile.personName = @"";                
        //[myTile setCrimeType];
        
        [itemList addObject:myTile];
        [myTile release];
    }


      [self arrangeTiles];
    [self SortTiles: NO];        
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    lblLastRefreshDate.text = [NSString stringWithFormat:@"Last Updted %@", dateString];
   [dateFormatter release];
 
}


- (void)viewDidLoad
{

    [super viewDidLoad];

    
    UIScrollView *theScroll = (UIScrollView*)self.svMain;
    
    
    
    UIImage *img = [UIImage imageNamed:@"image-1-1024x960.jpg"];
    [theScroll setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    penrose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penrose.png"]];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad == YES)
    {
        penrose.frame = CGRectMake(200 ,200, 400, 400);    
    }
    else
    {
        penrose.frame = CGRectMake(60 ,100, 200, 200);
    }

    penrose.contentMode = UIViewContentModeScaleAspectFill;
    [penrose setAlpha:0.0];
    [theScroll addSubview:penrose];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:5.0
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 [penrose setAlpha:1.0];
             }
                             completion:nil];
            
        });
    });

    
    theScroll.decelerationRate = UIScrollViewDecelerationRateNormal;
	
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.tileSize == 1)
    {
        tileWidthTemplate = 25;
        tileHeightTemplate = 25;

    }
    else
    {
        if(delegate.tileSize == 2)
        {
            tileWidthTemplate = 50;
            tileHeightTemplate = 50;
            
        }  
        else
        {
            if(delegate.tileSize == 3)
            {
                tileWidthTemplate = 100;
                tileHeightTemplate = 100;
                
            }    
            else
            {
                tileWidthTemplate = 200;
                tileHeightTemplate = 200;                
            }
        }
    }
    
//    tileWidthTemplate = 100;
//    tileHeightTemplate = 100;
 
    colCount =0;
    lastX = 0;
    lastY = 0;

    



    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.tileSize == 1)
    {
        tileWidthTemplate = 25;
        tileHeightTemplate = 25;
        
    }
    else
    {
        if(delegate.tileSize == 2)
        {
            tileWidthTemplate = 50;
            tileHeightTemplate = 50;
            
        }  
        else
        {
            if(delegate.tileSize == 3)
            {
                tileWidthTemplate = 100;
                tileHeightTemplate = 100;
                
            }    
            else
            {
                tileWidthTemplate = 200;
                tileHeightTemplate = 200;                
            }
        }
    }

    
    for(AsyncImageView *myPOI in itemList)
    {
        [myPOI blastOff];
        
    }
    [itemList removeAllObjects];
    
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;

    NSString *markets = [delegate getMarkets];
    if(markets.length ==0 || [markets isEqualToString:@"0"])
    {
        lblSelectMarket.hidden = NO;
    }
    else
    {
        lblSelectMarket.hidden = YES;
    }
    [service List_All_tbl_Booking_Weekly_V2:self action:@selector(handleList:) Markets:markets];
    [service release];
}

-(void) handleURL:(id)result
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
    SQLSTUDIOtbl_Ads_Result *myResult = (SQLSTUDIOtbl_Ads_Result*)result;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate launchURL:myResult.Ad_Target];

}


-(void)touchedOK:(AsyncImageView *) controller
{  
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(controller.flipModeOn == YES)
    {

        [sbMain setAlpha:1.0];
        [scMain setAlpha:1.0];
        if(iPad == YES)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:0.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                                 [sbMain setAlpha:0.0];
                                 [scMain setAlpha:0.0];
                         svMain.frame = CGRectMake(0, 0, 768, 1024);
                     }
                                     completion:nil];
                    
                });
            });

        }
        else
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:0.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                                 [sbMain setAlpha:0.0];
                                 [scMain setAlpha:0.0];
                         svMain.frame = CGRectMake(0, 0, 320, 480);
                     }
                                     completion:nil];
                    
                });
            });           
        }
        if(controller.isAd == YES)
        {
            
            SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
            [service Get_tbl_Ads:self action:@selector(handleURL:) Ad_ID:controller.tileID];
            [service release];       
        }
        else
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
            BackSideView *bSV;
            if(iPad)
            {
               bSV  = [[BackSideView alloc] initWithFrame:CGRectMake(0,0, 768, 1024) andTag:controller.tileID];
            }
            else 
            {
                bSV = [[BackSideView alloc] initWithFrame:CGRectMake(0,0, 320, 480) andTag:controller.tileID];                
            }
            bSV.parentController = self;
            controller.backSideView = bSV;
            [controller addSubview:controller.backSideView];
            [controller.imageView setAlpha:0.1];
            [bSV release];     
            
            tempRect = controller.frame;
            

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

        //[controller.lblMain setText:controller.personName];


    }
    else
    {
        [sbMain setAlpha:0.0];
        [scMain setAlpha:0.0];
        if(iPad == YES)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:0.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                         [sbMain setAlpha:1.0];
                         [scMain setAlpha:1.0];
                         svMain.frame = CGRectMake(0, 72, 768, 1024);
                     }
                                     completion:nil];
                    
                });
            });
            
        }
        else
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:0.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                         [sbMain setAlpha:1.0];
                         [scMain setAlpha:1.0];
                         svMain.frame = CGRectMake(0, 72, 320, 480);
                     }
                                     completion:nil];
                    
                });
            });           
        }
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
                [myPOI sendSubviewToBack:myPOI.imageView ];
            }
            else
            {
                [myPOI.backSideView remove];
            }
        }
    }
}

- (void)viewDidUnload
{
    [self setSbMain:nil];
    [self setSvMain:nil];
    [self setLblReleaseToRefresh:nil];
    [self setLblLastRefreshDate:nil];
    [self setImgScrollArrow:nil];
    [self setScMain:nil];
    [self setLblSelectMarket:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [itemList release];
    [sbMain release];
    [svMain release];
    [searchTimer release];
    [lblReleaseToRefresh release];
    [lblLastRefreshDate release];
    [imgScrollArrow release];
    [scMain release];

    [lblSelectMarket release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif

    if(iPad == YES)
    {
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT_IPAD) 
        {
            [lblReleaseToRefresh setAlpha:1.0];
            [lblLastRefreshDate setAlpha:1.0];
            [imgScrollArrow setAlpha:1.0];
        }
        else
        {
            [lblReleaseToRefresh setAlpha:0.0];
            [lblLastRefreshDate setAlpha:0.0];
            [imgScrollArrow setAlpha:0.0];
        }
    }
    else
    {
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT_IPHONE) 
        {
            [lblReleaseToRefresh setAlpha:1.0];
            [lblLastRefreshDate setAlpha:1.0];
            [imgScrollArrow setAlpha:1.0];
        }
        else
        {
            [lblReleaseToRefresh setAlpha:0.0];
            [lblLastRefreshDate setAlpha:0.0];
            [imgScrollArrow setAlpha:0.0];
        }        
    }
    
    UIScrollView *theScroll = (UIScrollView*)self.svMain;


    if(iPad == YES)
    {
        penrose.frame = CGRectMake(200 ,200, 400, 400);    
        penrose.frame = CGRectMake(200,200 + theScroll.contentOffset.y, 400, 400);

    }
    else
    {
        penrose.frame = CGRectMake(60 ,100, 200, 200);
        penrose.frame = CGRectMake(60,100 + theScroll.contentOffset.y, 200, 200);
        
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
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT_IPAD) 
        {
            [self scrollRefresh];   
        }
    }
    else
    {
        sbMain.frame =  CGRectMake(0, 0, 320, 44);        
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT_IPHONE) 
        {
            [self scrollRefresh];   
        }
    }
    

}
-(void)scrollRefresh
{
    for(AsyncImageView *myPOI in itemList)
    {
        [myPOI blastOff];
    
    }
    [itemList removeAllObjects];
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *markets = [delegate getMarkets];
    if(markets.length ==0 || [markets isEqualToString:@"0"])
    {
        lblSelectMarket.hidden = NO;
    }
    else
    {
        lblSelectMarket.hidden = YES;
    }
    if(sbMain.text.length == 0)
    {
        [service List_All_tbl_Booking_Weekly_V2:self action:@selector(handleList:) Markets:markets];
    }
    else 
    {
        [service Search_Bookings_V2:self action:@selector(handleList:) Phrase:sbMain.text Markets:markets] ;
    }
    [service release];
    
    [lblLastRefreshDate setAlpha:1.0];
    [lblReleaseToRefresh setAlpha:1.0];
    [imgScrollArrow setAlpha:1.0];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:0.75
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 
                 [lblLastRefreshDate setAlpha:0.0];
                 [lblReleaseToRefresh setAlpha:0.0];
                 [imgScrollArrow setAlpha:0.0];
             }
                             completion:nil];
            
        });
    });
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{  

}

- (void)SortTiles:(BOOL)FadeModeOn
{
    if (FadeModeOn == YES)
    {
        
        for(AsyncImageView *myPOI in itemList)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:1.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                         
                         myPOI.alpha = 0.0;
                     }
                                     completion:nil];
                    
                });
            });
        }
    }
    NSArray *sortedArray;
    switch (self.scMain.selectedSegmentIndex) {
        case 0:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first = [(AsyncImageView*)a  Booking_Date];
                NSDate *second = [(AsyncImageView*)b Booking_Date];
                return [second compare:first];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
            }
            
            [self arrangeTiles];
            
            
            
            break;
            
        case 1:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [NSString stringWithFormat:@"%i",[(AsyncImageView*)a market]];
                NSString *second = [NSString stringWithFormat:@"%i", [(AsyncImageView*)b market]];
                return [first compare:second];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
            }
            [self arrangeTiles];
            break; 
            
        case 2:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [NSString stringWithFormat:@"%i",[(AsyncImageView*)a sex]];
                NSString *second = [NSString stringWithFormat:@"%i", [(AsyncImageView*)b sex]];
                return [first compare:second];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
            }
            [self arrangeTiles];            
            break; 
            
        case 3:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(AsyncImageView*)a name];
                NSString *second = [(AsyncImageView*)b name];
                return [first compare:second];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
            }
            [self arrangeTiles];            
            break;
            
        case 4:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSNumber *first = [(AsyncImageView*)a hits];
                NSNumber *second = [(AsyncImageView*)b hits];
                return [second compare:first];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
                
            }
            [self arrangeTiles];            
            break; 
            
        case 5:
            
            sortedArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(AsyncImageView*)a crimeTypeImageLink];
                NSString *second = [(AsyncImageView*)b crimeTypeImageLink];
                return [first compare:second];
            }];
            
            [itemList removeAllObjects];
            for(AsyncImageView *myPOI in sortedArray)
            {
                [itemList addObject:myPOI];
            }
            [self arrangeTiles];            
            break;            
            
        case 6:
            NSLog(@"Options");
            
            break;
        default:
            break;
    }
    
    if(FadeModeOn == YES)
    {
        for(AsyncImageView *myPOI in itemList)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    [UIView animateWithDuration:1.75
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                         
                         myPOI.alpha = 1.0;
                     }
                                     completion:nil];
                    
                });
            });
        }
    }
}

- (IBAction)scMain_Touch:(id)sender 
{
    [self SortTiles: YES];
}
@end
