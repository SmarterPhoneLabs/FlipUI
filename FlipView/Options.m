    //
//  Options.m
//  Bookings
//
//  Created by johnathan rossitter on 5/20/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "Options.h"
#import "AppDelegate.h"
#import "SQLSTUDIOMyService.h"
#import "SQLSTUDIOServices.h"


@implementation Options
@synthesize btnClearCache;
@synthesize swCaddo;
@synthesize swBossier;
@synthesize tblMarkets;
@synthesize slTileSize;
@synthesize btnSPL;
@synthesize btnMoreInfo;
@synthesize activityMain;
@synthesize rawData;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
        [activityMain startAnimating];
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate addGradient:btnClearCache];
        rawData = [[NSMutableArray alloc] init];
        

        [rawData removeAllObjects];
        SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
        service.logging = NO;
        [service List_All_tbl_Market:self action:@selector(handleList:)];
        [service release];
        
        int x = delegate.tileSize;
        float myf = 0.0;
        switch (x)
        {
            case 1:
                NSLog(@"");
                myf = 1.0;
                slTileSize.value = myf;
//                [slTileSize setValue:1.0f animated:YES];
                break;
            case 2:
                NSLog(@"");
                myf = 2.0;
                slTileSize.value = myf;
                //                [slTileSize setValue:2.0f animated:YES];
                break;
            case 3:
                
                NSLog(@"");
                myf = 3.0;
                slTileSize.value = myf;
//                [slTileSize setValue:3.0f animated:YES];
                break;
            case 4:
                NSLog(@"");
                myf = 4.0;
                slTileSize.value = myf;
//                [slTileSize setValue:4.0f animated:YES];
                break;                
                
            default:
                break;
        }

    }
    return self;
}



-(void)handleList:(id)result
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
    [rawData removeAllObjects];
    NSMutableArray *myData = (NSMutableArray*)result;
    for(SQLSTUDIOArrayOftbl_Market_Result *myPOI in myData)
    {
        SQLSTUDIOtbl_Market_Result *myMarket = (SQLSTUDIOtbl_Market_Result*)myPOI;
        if(myMarket.Market_Status ==1)
        {
            [rawData addObject:myPOI];
        }
    }
    [tblMarkets reloadData];

}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [activityMain startAnimating];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [activityMain stopAnimating];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   // UIScrollView *theScroll = (UIScrollView*)self.svMain;
    
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
                 [penrose setAlpha:1.0];
             }
                             completion:nil];
            
        });
    });
    
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate addGradient:btnMoreInfo];
    [delegate addGradient:btnClearCache];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSwCaddo:nil];
    [self setSwBossier:nil];
    [self setBtnSPL:nil];
    [self setBtnClearCache:nil];
    [self setTblMarkets:nil];
    rawData = nil;
    [self setActivityMain:nil];
    [self setBtnMoreInfo:nil];
    [self setSlTileSize:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [swCaddo release];
    [swBossier release];
    [btnSPL release];
    [btnClearCache release];
    [tblMarkets release];
        [rawData release];
    [activityMain release];
    [btnMoreInfo release];
    [slTileSize release];
    [super dealloc];
}
- (IBAction)btnSPL_Touch:(id)sender 
{
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smarterphonelabs.com"]]; 
}
-(void)gumballSave
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [[NSUserDefaults standardUserDefaults] setBool:swCaddo.on  forKey:@"CaddoOn"];
//    [[NSUserDefaults standardUserDefaults] setBool:swBossier.on  forKey:@"BossierOn"]; 
    [[NSUserDefaults standardUserDefaults] setObject:delegate.marketList forKey:@"MarketList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)swCaddo_Changed:(id)sender 
{
    [ self gumballSave ];
}

- (IBAction)swBossier_Changed:(id)sender 
{
    [self gumballSave];
}

- (IBAction)btnClearCache_Touch:(id)sender 
{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate clearImageCache];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SwipeDemoCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        frame.origin.x = 5;
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

    SQLSTUDIOtbl_Market_Result *myGSO = [rawData objectAtIndex:indexPath.row];
    nameLabel.text = myGSO.Market_Name;
    

    cell.textLabel.textColor = [UIColor whiteColor];


    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor grayColor]];
    [cell setSelectedBackgroundView:bgColorView];
    [bgColorView release]; 
    
    NSString *isChecked = (NSString*)[delegate.marketList objectForKey:[NSString stringWithFormat:@"%i", myGSO.Market_ID]];
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

    mySwitch.tag = myGSO.Market_ID;
    [mySwitch addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
    
    
    
    cell.accessoryView = mySwitch;

    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowgradient.png"]];
    cell.backgroundView = tempImageView;
    [tempImageView release];
    return cell;
    
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
    
    [delegate.marketList setValue:isOnString forKey:[NSString stringWithFormat:@"%i",marketID]];
    [self gumballSave];
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (IBAction)btnMoreInfo_Touch:(id)sender {
}
- (IBAction)slTileSize_Touch:(id)sender 
{
    int x = roundf(slTileSize.value);
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSUserDefaults standardUserDefaults] setInteger:x forKey:@"TileSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    delegate.tileSize = x;
    NSLog(@"%i", x);
    
    
}
@end
