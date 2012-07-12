//
//  MapOptions.h
//  JailBookings
//
//  Created by johnathan rossitter on 7/11/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapOptions;

@protocol MapOptionsDelegate
-(void)touchedOK:(MapOptions *) controller;
@end

@interface MapOptions : UIView
{

}
@property (nonatomic, retain) NSObject<MapOptionsDelegate> *delegate;
@property (retain, nonatomic) IBOutlet UIButton *btnDont;
- (IBAction)btnDone_Touch:(id)sender;

@end
