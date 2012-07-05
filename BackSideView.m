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
#import "AppDelegate.h"


@interface BackSideView ()

@end

@implementation BackSideView
@synthesize imgConvict;
@synthesize activityMain;
@synthesize txtCharges;
@synthesize lblName;


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
   
    NSString *imagePaht = [NSString stringWithFormat:@"http://www.jail-bookings.com/%@",myResult.ssImage_Booking_Image_1];
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
    [super dealloc];
}
@end
