//
//  MyAnnotation.m
//  maps
//
//  Created by johnathan rossitter on 9/13/11.
//  Copyright 2011 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinColor;
@synthesize locationID;
@synthesize image;
@synthesize locationType;
@synthesize imgURL;

- (void)dealloc {
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
