//
//  BackSideView.m
//  FlipView
//
//  Created by Johnathan Rossitter on 7/2/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "BackSideView.h"
#import "AppDelegate.h"
#import "SQLSTUDIOMyService.h"
#import "SQLSTUDIOServices.h"



@interface BackSideView ()

@end

@implementation BackSideView
@synthesize lblGender;
@synthesize lblDOB;
@synthesize lblDOO;
@synthesize lblMarketName;
@synthesize txtStory;
@synthesize lblBond;
@synthesize btnTwitter;

NSString *cachedImage;
int selectedBooking;
@synthesize btnFacebook;
@synthesize imgConvict;
@synthesize activityMain;
@synthesize txtCharges;
@synthesize lblName;
@synthesize imgCrimeType;
@synthesize parentController;

int selectedMarket;
-(void) handleMarkets:(id)result
{
    [activityMain stopAnimating];
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
    SQLSTUDIOArrayOftbl_Market_Result *results =(SQLSTUDIOArrayOftbl_Market_Result*) result;
    for(SQLSTUDIOtbl_Market_Result *result in results)
    {
        if (result.Market_ID = selectedMarket)
        {
            lblMarketName.text = result.Market_Name;
        }
    }

    
}
-(void) handleIt:(id)result
{
    [activityMain stopAnimating];
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
    SQLSTUDIOtbl_Booking_Result_V2 *myResult = (SQLSTUDIOtbl_Booking_Result_V2*)result;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    lblName.text = [NSString stringWithFormat:@"%@ %@", myResult.First_Name, myResult.Last_Name];
    txtCharges.text = myResult.Charge;
    if(myResult.Sex == 1)
    {
        lblGender.text = @"Male";
    }
    else
    {
        lblGender.text = @"Female";
    }
    
    txtStory.text = myResult.Story;

    
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        NSString *dateString = [dateFormatter stringFromDate:myResult.Date_Of_Birth];
        lblDOB.text = [NSString stringWithFormat:@"%@", dateString];
    
        dateString = [dateFormatter stringFromDate:myResult.Date_Of_Offense];
        lblDOO.text = [NSString stringWithFormat:@"%@", dateString];
        [dateFormatter release];
    
    if([myResult.Bond_Amount doubleValue] <= 0.00)
    {
        lblBond.text = @"Unknown at this time";    
    }
    else
    {
        NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = @"USD";
        
        NSString * formattedAmount = [formatter stringFromNumber: myResult.Bond_Amount];
        lblBond.text = [NSString stringWithFormat:@"%@",formattedAmount];
    }
    
    [imgCrimeType setImage: [delegate getImage:[NSString stringWithFormat:@"http://www.jail-bookings.com/%@",myResult.Crime_Type_Image] size:CGSizeMake(72, 72) isWebBased:YES]];
    
    selectedMarket = myResult.Market_ID;
    
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];

    [service List_All_tbl_Market:self action:@selector(handleMarkets:)];
    [service release];
    
//    myResult.Views


    
   
    NSString *imagePaht = [NSString stringWithFormat:@"http://www.jail-bookings.com/%@",myResult.ssImage_Booking_Image_1];
    cachedImage = [imagePaht copy];

    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            
            [imgConvict setAlpha:0.0];
            if(iPad == YES)
            {
                [imgConvict  setImage:[delegate getImage:imagePaht size:CGSizeMake(500, 500)  isWebBased:YES]]; 
                [delegate addGradientImage:imgConvict];
            }
            else 
            {
                [imgConvict  setImage:[delegate getImage:imagePaht size:CGSizeMake(250, 250)  isWebBased:YES]]; 
                [delegate addGradientImage:imgConvict];
            }
            
            
            [UIView animateWithDuration:4.0 
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [imgConvict  setAlpha:1.0];
                             }
                             completion:nil];
            
            
        });
    });
    
}


-(id)initWithFrame:(CGRect)frame andTag:(int)TagID;
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        selectedBooking = TagID;
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif  
        NSArray *screens;
        if(iPad == YES)
        {
            screens  = [[NSBundle mainBundle] loadNibNamed:@"BackSideView_iPad" owner:self options:nil];
        }
        else
        {
            screens = [[NSBundle mainBundle] loadNibNamed:@"BackSideView" owner:self options:nil];        
        }
        
        [self addSubview:[screens objectAtIndex:0]];
    
        
        SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
        [service Get_tbl_Booking:self action:@selector(handleIt:) Booking_ID:TagID];
        [service List_All_tbl_Market:self action:@selector(handleMarkets:)];
        [service release];
        [activityMain startAnimating];
    }
    return self;

}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif  
    NSArray *screens;
    if(iPad == YES)
    {
        screens  = [[NSBundle mainBundle] loadNibNamed:@"BackSideView_iPad" owner:self options:nil];
    }
    else
    {
        screens = [[NSBundle mainBundle] loadNibNamed:@"BackSideView" owner:self options:nil];        
    }
    [self addSubview:[screens objectAtIndex:0]];

}


-(void)remove
{
    [self removeFromSuperview];
}

- (void)dealloc {
    [lblName release];
    [txtCharges release];
    [activityMain release];
//    [imgConvict release];
    [btnFacebook release];
    [btnTwitter release];
    [imgCrimeType release];
    [lblGender release];
    [lblDOB release];
    [lblDOO release];
    [lblMarketName release];
    [txtStory release];
    [lblBond release];
    [super dealloc];
}

- (IBAction)btnTwitter_Touch:(id)sender 
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    NSString *shortenURL = [NSString stringWithFormat:@"http://www.jail-bookings.com/Bookings.aspx?BookingID=%i",selectedBooking];
    NSString *shortenedURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt", @"smarterphonelabs", @"R_8b53e012ef62da83965a8a4d65e299e5", shortenURL]] encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString *tweetContent;
    tweetContent = [NSString stringWithFormat:@"%@ was booked. Read more at %@ @JailBookings", self.lblName.text, shortenedURL];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:tweetContent];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        //        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        
        // Dismiss the tweet composition view controller.
        [parentController dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [parentController presentModalViewController:tweetViewController animated:YES];   
}

- (IBAction)btnFacebook_Touch:(id)sender 
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate loginFacebook];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"146076692192037", @"app_id",
                                   [NSString stringWithFormat:@"http://www.jail-bookings.com/Bookings.aspx?BookingID=%i",selectedBooking], @"link",
                                   [NSString stringWithFormat:@"%@ booked",self.lblName.text], @"name",
                                   [NSString stringWithFormat:@"Booking information for %@", self.lblName.text], @"caption",
                                   [NSString stringWithFormat:@"%@ was booked for %@",lblName.text, txtCharges.text], @"description",
                                   @"Bookings",  @"message",
                                   cachedImage, @"picture",
                                   nil];
    
    [delegate.facebook dialog:@"feed" andParams:params andDelegate:delegate];
}
@end
