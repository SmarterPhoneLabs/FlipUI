//
//  MapOptions.m
//  JailBookings
//
//  Created by johnathan rossitter on 7/11/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MapOptions.h"
#import "AppDelegate.h"
#import "SQLSTUDIOMyService.h"
#import "SQLSTUDIOServices.h"

@interface MapOptions ()

@end

@implementation MapOptions
@synthesize dgMain;
@synthesize rawData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rawData = [[NSMutableArray alloc] init];
        
        UIImageView *penrose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penrose.png"]];
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
        [penrose release];
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [rawData removeAllObjects];
    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
    service.logging = NO;
    [service List_All_tbl_Crime_Type:self action:@selector(handleList:)];
    [service release];
    // Do any additional setup after loading the view from its nib.
}

-(void)handleList:(id)result
{
    //[activityMain stopAnimating];
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
    [rawData removeAllObjects];
    NSMutableArray *myData = (NSMutableArray*)result;
    for(SQLSTUDIOArrayOftbl_Crime_Type_Result *myPOI in myData)
    {


        [rawData addObject:myPOI];
    }
    [dgMain reloadData];
    
}

- (void)viewDidUnload
{
    [self setDgMain:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [dgMain release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rawData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero]autorelease];
        CGRect frame;
        frame.origin.x = 40;
        frame.origin.y = 5;
        frame.size.height = 20;
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            frame.size.width = 580;            
        }
        else
        {
            frame.size.width = 200;            
        }    
        UILabel *labelName = [[UILabel alloc]initWithFrame:frame];
        labelName.tag = 1;
        [cell.contentView addSubview:labelName];
        labelName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.textColor = [UIColor whiteColor];
        [labelName release];
        
        frame.origin.y += 20;
        UILabel *lblDetails = [[UILabel alloc]initWithFrame:frame];
        lblDetails.tag = 2;
        [cell.contentView addSubview:lblDetails];
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails.backgroundColor = [UIColor clearColor];
        lblDetails.textColor = [UIColor grayColor];
        [lblDetails release];
        
    }
    
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    
    SQLSTUDIOtbl_Crime_Type_Result *myGSO = [rawData objectAtIndex:indexPath.row];
    nameLabel.text = myGSO.Crime_Type_Name;
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor grayColor]];
    [cell setSelectedBackgroundView:bgColorView];
    [bgColorView release]; 
    
    NSString *isChecked = (NSString*)[delegate.crimeMapList objectForKey:[NSString stringWithFormat:@"%i", myGSO.Crime_Type_ID]];
    UISwitch *mySwitch = [[[UISwitch alloc] init] autorelease];
    mySwitch.onTintColor = [UIColor blackColor];
    if([isChecked isEqualToString:@"YES"])
    {
        [mySwitch setOn:YES];        
    }
    else
    {
        [mySwitch setOn:NO];
    }
    
    mySwitch.tag = myGSO.Crime_Type_ID;
    [mySwitch addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
    
    
    
    cell.accessoryView = mySwitch;
    

    
    
    UIImage *imgFoo = [delegate getImage:[NSString stringWithFormat:@"http://www.jail-bookings.com/%@", myGSO.ssImage_Crime_Type_Image] size:CGSizeMake(28, 28)  isWebBased:YES];
        [self scaleMe:cell.imageView.image toSize:CGSizeMake(28, 28)];
    [cell.imageView setImage:imgFoo ];            
 
    


   // cell.imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    return cell;
    
}

- (UIImage *)scaleMe:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (IBAction)flip:(UISwitch*)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    bool isOn = sender.on;
    int marketID = (int)sender.tag;
    NSString *isOnString;
    if(isOn == YES)
    {
        isOnString = @"YES";
    }
    else
    {
        isOnString = @"NO";
    }
    
    [delegate.crimeMapList setValue:isOnString forKey:[NSString stringWithFormat:@"%i",marketID]];
    [self gumballSave];
}
-(void)gumballSave
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSUserDefaults standardUserDefaults] setObject:delegate.crimeMapList forKey:@"CrimeMapList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
