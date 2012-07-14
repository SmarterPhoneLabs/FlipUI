//
//  Options.h
//  Bookings
//
//  Created by johnathan rossitter on 5/20/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Options : UIViewController
{
    IBOutlet UISwitch *swCaddo;
    IBOutlet UISwitch *swBossier;
    IBOutlet UIButton *btnSPL;
    IBOutlet UITableView *tblMarkets;
    NSMutableArray *rawData;

}
@property (retain, nonatomic) IBOutlet UIButton *btnMoreInfo;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityMain;
@property (nonatomic,retain) NSMutableArray *rawData;
@property (retain, nonatomic) IBOutlet UIButton *btnClearCache;
@property (retain, nonatomic) IBOutlet UISwitch *swCaddo;
@property (retain, nonatomic) IBOutlet UISwitch *swBossier;
- (IBAction)swCaddo_Changed:(id)sender;
- (IBAction)swBossier_Changed:(id)sender;
- (IBAction)btnClearCache_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tblMarkets;
- (IBAction)btnMoreInfo_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UISlider *slTileSize;
- (IBAction)slTileSize_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblImageCacheSize;

@property (retain, nonatomic) IBOutlet UIButton *btnSPL;
- (IBAction)btnSPL_Touch:(id)sender;
@end
