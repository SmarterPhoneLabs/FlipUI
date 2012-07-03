//
//  BackSideView.h
//  FlipView
//
//  Created by Johnathan Rossitter on 7/2/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackSideView : UIView
{
    IBOutlet UILabel *lblName;
    IBOutlet UITextView *txtCharges;
    IBOutlet UIActivityIndicatorView *activityMain;
    IBOutlet UIImageView *imgConvict;
}



@property (retain, nonatomic) IBOutlet UIImageView *imgConvict;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityMain;
@property (retain, nonatomic) IBOutlet UITextView *txtCharges;
@property (retain, nonatomic) IBOutlet UILabel *lblName;

-(id)initWithFrame:(CGRect)frame andTag:(int)TagID;
-(void)remove;
@end

