//
//  MyNavController.m
//  Plato
//
//  Created by Johnathan Rossitter on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyNavController.h"

@implementation MyNavController


- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 1.00];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
		UIViewController *viewController = [super popViewControllerAnimated:NO];
		[UIView commitAnimations];
		return viewController;
}
@end
