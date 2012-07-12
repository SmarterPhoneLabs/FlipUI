//
//  AppDelegate.h
//  FlipView
//
//  Created by johnathan rossitter on 6/30/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Facebook *facebook;
    NSMutableDictionary *imageCache; 
    NSMutableDictionary *marketList;
    NSMutableDictionary *crimeMapList;
    int tileSize;
}

@property (nonatomic) int tileSize;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *imageCache;

//@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) ViewController *viewController;




@property (retain, nonatomic) IBOutlet UINavigationController *navHome;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableDictionary *marketList;
@property (nonatomic, retain) NSMutableDictionary *crimeMapList;


-(NSString*)getMarkets;
-(NSString*)getMapCrimeTypes;
-(bool)loginFacebook;

-(void) launchURL:(NSString*)URL;
//actions
-(void) addGradient:(UIButton *) _button;
-(void) addGradientImage:(UIImageView *) _button;

//main call to get an image from the image cache
- (UIImage*) getImage:(NSString*)imageName size:(CGSize)Size isWebBased:(BOOL)IsWebBased;

//a higher level call that will get an image view based on a call to getImage -- if Glass= YES it will auto add a gradient layer
- (UIImageView*) getImageView:(NSString*)imageName size:(CGSize)Size glass:(BOOL)Glass isWebBased:(BOOL)IsWebBased;

//a simple image caling tool
- (UIImage *)scaleMe:(UIImage *)image toSize:(CGSize)size;

//a function to clear the entire image cache
- (void)clearImageCache;

//clear a single image from the cache
- (void)clearImageCache:(NSString*)ImageName;

@end
