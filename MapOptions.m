//
//  MapOptions.m
//  JailBookings
//
//  Created by johnathan rossitter on 7/11/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MapOptions.h"

@implementation MapOptions
@synthesize btnDont;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif        
        NSArray *screens;
        if(iPad == YES)
        {
            screens  = [[NSBundle mainBundle] loadNibNamed:@"MapOptions_iPad" owner:self options:nil];
        }
        else
        {
            screens = [[NSBundle mainBundle] loadNibNamed:@"MapOptions" owner:self options:nil];        
        }
        
        [self addSubview:[screens objectAtIndex:0]];
    }
    return self;
}

- (void) awakeFromNib
{
        [super awakeFromNib];
}


- (void)dealloc {
    [btnDont release];
    [super dealloc];
}
- (IBAction)btnDone_Touch:(id)sender 
{
    [delegate touchedOK:self];
}
@end
