//
//  BackSideView.h
//  FlipView
//
//  Created by Johnathan Rossitter on 7/2/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@class BackSideView;

@protocol BackSideViewDelegate
-(void)touchedOK:(BackSideView *) controller;
@end

@interface BackSideView : UIView
{
    IBOutlet UILabel *lblName;
    IBOutlet UITextView *txtCharges;
    IBOutlet UIActivityIndicatorView *activityMain;
    IBOutlet UIImageView *imgConvict;
    UIViewController *parentController;
}
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors8;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors7;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors6;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors5;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors4;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors3;
@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors2;

@property (retain, nonatomic) IBOutlet UILabel *lblDescriptors;
- (IBAction)btnConvict_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnConvict;
@property (nonatomic, retain) NSObject<BackSideViewDelegate> *delegate;
@property(nonatomic, assign) UIViewController *parentController;
@property (retain, nonatomic) IBOutlet UIButton *btnTwitter;
- (IBAction)btnTwitter_Touch:(id)sender;

- (IBAction)btnFacebook_Touch:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btnFacebook;

@property (retain, nonatomic) IBOutlet UIImageView *imgConvict;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityMain;
@property (retain, nonatomic) IBOutlet UITextView *txtCharges;
@property (retain, nonatomic) IBOutlet UILabel *lblName;

@property (retain, nonatomic) IBOutlet UIImageView *imgCrimeType;
-(id)initWithFrame:(CGRect)frame andTag:(int)TagID;
-(void)remove;

@property (retain, nonatomic) IBOutlet UIScrollView *svMini;
@property (retain, nonatomic) IBOutlet UILabel *lblGender;
@property (retain, nonatomic) IBOutlet UILabel *lblDOB;
@property (retain, nonatomic) IBOutlet UILabel *lblDOO;
@property (retain, nonatomic) IBOutlet UILabel *lblMarketName;
@property (retain, nonatomic) IBOutlet UITextView *txtStory;
@property (retain, nonatomic) IBOutlet UILabel *lblBond;






@end

