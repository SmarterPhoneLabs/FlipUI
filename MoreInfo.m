//
//  MoreInfo.m
//  JailBookings
//
//  Created by johnathan rossitter on 7/13/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MoreInfo.h"

@interface MoreInfo ()

@end

@implementation MoreInfo
@synthesize btnSPL;

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
    UIImageView *penrose;
    
    UIImage *img = [UIImage imageNamed:@"image-1-1024x960.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
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
    [self.view addSubview:penrose];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:5.0
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 [penrose setAlpha:0.75];
             }
                             completion:nil];
            
        });
    });
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBtnSPL:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [btnSPL release];
    [super dealloc];
}
- (IBAction)btnSPL_Touch:(id)sender 
{
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smarterphonelabs.com"]]; 
    
}
@end
