//
//  MapOptions.h
//  JailBookings
//
//  Created by johnathan rossitter on 7/11/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapOptions : UIViewController
{
    NSMutableArray *rawData;
    IBOutlet UITableView *dgMain;
}
@property (nonatomic,retain) NSMutableArray *rawData;
@property (retain, nonatomic) IBOutlet UITableView *dgMain;
@end
