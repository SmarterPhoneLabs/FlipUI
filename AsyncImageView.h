//
//  ASyncImage.h
//  FlipView
//
//  Created by johnathan rossitter on 6/30/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackSideView.h"

@class AsyncImageView;

@protocol TileDelegate
-(void)touchedOK:(AsyncImageView *) controller;
@end

@interface AsyncImageView : UIView {
	
	NSURLConnection* connection;
	NSMutableData* data;	
	UIActivityIndicatorView* activityIndicator;	
	Boolean fill;
	int tileID;
    BOOL useGlass;
    NSString *personName;
    BOOL flipModeOn;
    UIImageView *imageView;
    //UILabel *lblMain;
    BOOL useRotation;
    BOOL isTouchable;
    BackSideView *backSideView;
    BOOL isAd;
    int hits;
    UIImageView *star1;
    UIImageView *star2;
    UIImageView *star3;
    UIImageView *star4;
}

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@property (atomic, retain) UIImageView *star1;
@property (atomic, retain) UIImageView *star2;
@property (atomic, retain) UIImageView *star3;
@property (atomic, retain) UIImageView *star4;
@property (atomic) int hits;
@property (nonatomic) BOOL isAd;
@property (nonatomic, retain) BackSideView *backSideView;
@property (nonatomic) BOOL isTouchable;
@property (nonatomic) BOOL useRotation;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic) BOOL flipModeOn;
@property (nonatomic, retain) NSString *personName;
@property (nonatomic) int tileID;
@property (nonatomic,assign)Boolean fill;
@property (nonatomic, retain) NSObject<TileDelegate> *delegate;
@property (nonatomic) BOOL useGlass;
//@property (nonatomic, retain) UILabel *lblMain;
-(void)maximize:(int)xOffSet;
-(void)minimize:(CGRect)oldRect ;
-(void)blastOff;
-(void)blastBack;
-(void)setOpacity:(CGFloat)Opacity;

@end