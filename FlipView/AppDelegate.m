//
//  AppDelegate.m
//  FlipView
//
//  Created by johnathan rossitter on 6/30/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize imageCache;
@synthesize facebook;
@synthesize tabBarController;
@synthesize navHome;
@synthesize marketList;
@synthesize tileSize;



-(void)launchURL:(NSString *)URL
{
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];  
}

//init
- (id)init
{
    NSLog(@"App Init");
    self = [super init];
    if (self) 
    {
        imageCache = [[NSMutableDictionary alloc] init];
        marketList = [[NSMutableDictionary  alloc] init];
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"TileSize"] == 0)
        {
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TileSize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            tileSize = 2;
        }
        else
        {
            tileSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"TileSize"];
        }

    }
    return self;
}

- (void)dealloc
{
    [imageCache release];
    [_window release];
    //[_viewController release];
    [facebook release];
        [marketList release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        NSLog(@"App Finished Launching");
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
//    } else {
//        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
//    }
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];

    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    facebook = [[Facebook alloc] initWithAppId:@"146076692192037" andDelegate:self];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MarketList"] == nil)
    {
//        [marketList setValue:@"YES" forKey:@"0"];
//        [[NSUserDefaults standardUserDefaults] setObject:marketList forKey:@"MarketList"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        marketList = [[NSUserDefaults standardUserDefaults] objectForKey:@"MarketList"];
    }
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






- (void)clearImageCache:(NSString*)ImageName;
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSError *error = nil;
    NSString*    finalString = [[
                                 [ImageName stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
    BOOL removeSuccess = [fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@/%@",imagePath,finalString] error:&error];
    if (!removeSuccess) 
    {
        // Error handling
        
    }
}

//a function to clear the entire image cache
- (void)clearImageCache
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:imagePath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [imagePath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) 
            {
                // Error handling
                
            }
        }
    } else {
        // Error handling
    }
}

//a simple image caling tool
- (UIImage *)scaleMe:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//a higher level call that will get an image view based on a call to getImage -- if Glass= YES it will auto add a gradient layer
-(UIImageView*) getImageView:(NSString*)imageName size:(CGSize)Size glass:(BOOL)Glass isWebBased:(BOOL)IsWebBased
{
    UIImage *myImage = [self getImage:imageName size:Size isWebBased:IsWebBased];
    UIImageView *myImageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
    if(Glass == YES)
    {
        [self addGradientImage:myImageView];
    }
    return myImageView;
    
}

//main call to get an image from the image cache
-(UIImage*) getImage:(NSString*)imageName size:(CGSize)Size isWebBased:(BOOL)IsWebBased
{
    NSString* imageNameCopy = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString*    finalString = [[
                                 [imageNameCopy stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    UIImage* cachedImage = [imageCache objectForKey:finalString];
    
    if(cachedImage == nil)
    {
        NSError *error;
        error = nil;
        UIImage *img;
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:finalString];
        //see if the image exists in the documents dir
        img = [UIImage imageWithContentsOfFile:imagePath];
        if(img != nil)
        {
            
        }
        else
        {
            
            if(IsWebBased == YES)
            {
                //load it from online
                NSURL *url = [NSURL URLWithString:imageNameCopy];
                
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                
                if(error != nil)
                {
                    //load a local error or file not found image
                    img = [UIImage imageNamed:@"na.gif"];       
                }
                else
                {
                    //init the image with the data
                    img = [[UIImage alloc] initWithData:data];
                    //save it to cache
                    [data writeToFile:imagePath atomically:YES];
                }
            }
            else
            {
                img = [UIImage imageNamed:imageNameCopy]; 
            }
        }
        
        UIImage *copyImg;
        if(Size.width == 0 && Size.height == 0)
        {
            copyImg = img;
        }
        else 
        {
            copyImg = [self scaleMe: img toSize:Size];
        }
        [imageCache  setValue:copyImg forKey:finalString];  
        cachedImage = [imageCache objectForKey:finalString];        
    }
    
    return cachedImage;
}


-(void) addGradientImage:(UIImageView *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 6.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.2f],
                            [NSNumber numberWithFloat:0.3f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    
    
    
    
//    shineLayer.opacity = 20.0;
    [shineLayer setOpacity:0.5f];
    [layer addSublayer:shineLayer];
}
-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}

-(bool)loginFacebook
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                nil];
        [facebook authorize:permissions];
        [permissions release];
        return YES;
    }
    else 
    {
        return NO;
    }
}

-(NSString*)getMarkets
{
    NSString *retVal =@"";

    for (NSString* key in marketList)
    {
        id *value = [marketList objectForKey:key];
        if([(NSString*)value isEqualToString: @"YES"])
        {
            NSString *temp;
            temp = [retVal stringByAppendingString:[NSString stringWithFormat:@"%@,",key]]; 
            
            retVal = temp;
        }
        
        
    }
    
    return  retVal;
}

@end
