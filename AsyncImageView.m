#import "AsyncImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@implementation AsyncImageView
@synthesize fill;
@synthesize delegate;
@synthesize tileID;
@synthesize useGlass;
@synthesize personName;
@synthesize flipModeOn;
@synthesize imageView;
//@synthesize lblMain;
@synthesize useRotation;
@synthesize isTouchable;
@synthesize backSideView;
@synthesize isAd;
@synthesize hits;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;

CGRect oldRect;

int oldx;
int oldy;
int oldWidth;
int oldHeight;

-(void)maximize:(int)xOffSet
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad == YES)
    {
        [self setFrame:CGRectMake(0, 0 + xOffSet, 768, 1024)];
    }
    else
    {
        [self setFrame:CGRectMake(0, 0 +xOffSet, 320, 480)];            
    }
}
-(void)minimize:(CGRect)oldRect
{   
    [self setFrame:oldRect];
}


- (id)initWithFrame:(CGRect)aRect{
	[super initWithFrame:aRect];
    oldx = aRect.origin.x;
    oldy = aRect.origin.y;
    oldWidth = aRect.size.width;
    oldHeight =aRect.size.height;
    flipModeOn = NO;
    useRotation = NO;
    isTouchable = YES;
	
	activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	activityIndicator.frame=CGRectMake(((aRect.size.width)-20)/2, ((aRect.size.width)-20)/2, 20.0, 20.0);
	activityIndicator.hidesWhenStopped=YES;
	
	[activityIndicator startAnimating];
	[self addSubview:activityIndicator];
    
    
    
    UIImage *testImg;
    testImg = [UIImage imageNamed:@"goldstar.png"];
    
    star1 = [[UIImageView alloc] initWithImage:testImg];
    star1.frame = CGRectMake(0,self.frame.size.height-24,24,24);
    [self addSubview:star1];
    [star1 setHidden:YES ];
    
    star2 = [[UIImageView alloc] initWithImage:testImg];
    star2.frame = CGRectMake(24,self.frame.size.height-24,24,24);
    [self addSubview:star2];
    [star2 setHidden:YES ];    
 
    
    star3 = [[UIImageView alloc] initWithImage:testImg];
    star3.frame = CGRectMake(48,self.frame.size.height-24,24,24);
    [self addSubview:star3];
    [star3 setHidden:YES ];

    
    star4 = [[UIImageView alloc] initWithImage:testImg];
    star4.frame = CGRectMake(72,self.frame.size.height-24,24,24);
    [self addSubview:star4];
    [star4 setHidden:YES ];
    
    
	return self;
	
}


- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [personName release];
    //[lblMain release];
    [backSideView release];

    [super dealloc];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)loadImageFromURL:(NSURL*)url 
{
    AppDelegate *delegateX = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* imageNameCopy = [[url absoluteString] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString*    finalString = [[
                                 [imageNameCopy stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    
   NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:finalString];
    
    UIImage* cachedImage = [delegateX.imageCache objectForKey:imagePath];
    
    if(cachedImage == nil)
    {
        NSError *error;
        error = nil;
        UIImage *img;
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:finalString];
        //see if the image exists in the documents dir
        img = [UIImage imageWithContentsOfFile:imagePath];
        if(img != nil)
        {
            imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]autorelease];
            imageView.image=img;
            
            if(useGlass == YES)
            {
                AppDelegate *delegateX = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegateX addGradientImage:imageView];
            }
            
            [self addSubview:imageView];
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    
                    imageView.userInteractionEnabled  = YES;
                    [imageView setAlpha:0.0];
                    int x = arc4random() % 9;
                    switch (x)
                    {
                        case 1:
                            [imageView setFrame:CGRectMake(self.frame.size.width  * -2, 0, 0, 0)];
                            break;
                        case 2:
                            [imageView setFrame:CGRectMake(0,self.frame.size.height  * -2, 0, 0)];
                            break;      
                        case 3:
                            [imageView setFrame:CGRectMake(self.frame.size.width  * -2, self.frame.size.height  * -2, 0, 0)];
                            break;                            
                        case 4:
                            [imageView setFrame:CGRectMake(0,0, 0, 0)];
                            break;  
                        case 5:
                            [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                            break;                                  
                        case 6:
                            [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                            break;
                        case 7:
                            [imageView setFrame:CGRectMake(0,self.frame.size.height  * 4, 0, 0)];
                            break;                                  
                        case 8:
                            [imageView setFrame:CGRectMake(self.frame.size.width  * 4,self.frame.size.height * 4, 0, 0)];
                            break;                                                                  
                            
                        default:
                            break;
                    }
                    
                    
                    [UIView animateWithDuration:2.0 
                                          delay:0
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^
                     {
                         if(useRotation == YES)
                         {
                             [self runSpinAnimationOnView:imageView duration:1.75 rotations:0.9 repeat:0.9 ];
                         }
                         [imageView setAlpha:1.0];
                         [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                     }

                    completion:^(BOOL finished) 
                    {
                        if(hits > 25)
                        {
                            [star1 setHidden:NO];
                            [self bringSubviewToFront:star1];
//                            [star1 bringSubviewToFront];
                            
                        }
                        if(hits > 50)
                        {
                            [star2 setHidden:NO]; 
                            [self bringSubviewToFront:star2];
                        }
                        if(hits > 75)
                        {
                            [star3 setHidden:NO];
                            [self bringSubviewToFront:star3];                         
                            
                        }     
                        if(hits > 100)
                        {
                            [star4 setHidden:NO];
                            [self bringSubviewToFront:star4];                         
                            
                        }                        
                     }
                     ];

                    [activityIndicator stopAnimating];
                });
            });
            
            
            
        }
        else
        {
        if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
        if (data!=nil) { [data release]; }
	
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
        //TODO error handling, what if connection is nil?
        }
    }
    else
    {
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]autorelease];
        imageView.image=cachedImage;
        
        if(useGlass == YES)
        {
            AppDelegate *delegateX = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegateX addGradientImage:imageView];
        }
        
        [self addSubview:imageView];
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                
                imageView.userInteractionEnabled  = YES;
                [imageView setAlpha:0.0];
                int x = arc4random() % 9;
                switch (x)
                {
                    case 1:
                        [imageView setFrame:CGRectMake(self.frame.size.width  * -2, 0, 0, 0)];
                        break;
                    case 2:
                        [imageView setFrame:CGRectMake(0,self.frame.size.height  * -2, 0, 0)];
                        break;      
                    case 3:
                        [imageView setFrame:CGRectMake(self.frame.size.width  * -2, self.frame.size.height  * -2, 0, 0)];
                        break;                            
                    case 4:
                        [imageView setFrame:CGRectMake(0,0, 0, 0)];
                        break;  
                    case 5:
                        [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                        break;                                  
                    case 6:
                        [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                        break;
                    case 7:
                        [imageView setFrame:CGRectMake(0,self.frame.size.height  * 4, 0, 0)];
                        break;                                  
                    case 8:
                        [imageView setFrame:CGRectMake(self.frame.size.width  * 4,self.frame.size.height * 4, 0, 0)];
                        break;                                                                  
                        
                    default:
                        break;
                }
                
                
                [UIView animateWithDuration:2.0 
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^
                 {
                     if(useRotation == YES)
                     {
                         [self runSpinAnimationOnView:imageView duration:1.9 rotations:0.9 repeat:0.9 ];
                     }                     
                     [imageView setAlpha:1.0];
                     [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                 }
                                 completion:nil];
                [activityIndicator stopAnimating];
            });
        });
        
        
        //[activityIndicator stopAnimating];
   
    }
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	    NSString *theURL = [NSString stringWithFormat:@"%@", [[[theConnection currentRequest] URL] absoluteURL]];
    NSString*    finalString = [[
                                 [theURL stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
	[connection release];
	connection=nil;
	if ([[self subviews] count]>0) 
    {
		[[[self subviews] objectAtIndex:0] removeFromSuperview];
	}
	
    imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]autorelease];
	imageView.image=[UIImage imageWithData:data];
            NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:finalString];
                        [data writeToFile:imagePath atomically:YES];
    
    if(useGlass == YES)
    {
        AppDelegate *delegateX = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegateX addGradientImage:imageView];
    }

	[self addSubview:imageView];

    
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
                dispatch_async(queue, ^{
                    dispatch_sync(dispatch_get_main_queue(), ^{

        
                        imageView.userInteractionEnabled  = YES;
                        [imageView setAlpha:0.0];
                        int x = arc4random() % 9;
                        switch (x)
                        {
                            case 1:
                                [imageView setFrame:CGRectMake(self.frame.size.width  * -2, 0, 0, 0)];
                                break;
                            case 2:
                                [imageView setFrame:CGRectMake(0,self.frame.size.height  * -2, 0, 0)];
                                break;      
                            case 3:
                                [imageView setFrame:CGRectMake(self.frame.size.width  * -2, self.frame.size.height  * -2, 0, 0)];
                                break;                            
                            case 4:
                                [imageView setFrame:CGRectMake(0,0, 0, 0)];
                                break;  
                            case 5:
                                [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                                break;                                  
                            case 6:
                                [imageView setFrame:CGRectMake(self.frame.size.width  * 4,0, 0, 0)];
                                break;
                            case 7:
                                [imageView setFrame:CGRectMake(0,self.frame.size.height  * 4, 0, 0)];
                                break;                                  
                            case 8:
                                [imageView setFrame:CGRectMake(self.frame.size.width  * 4,self.frame.size.height * 4, 0, 0)];
                                break;                                                                  
                                
                            default:
                                break;
                        }


                        [UIView animateWithDuration:2.0 
                                              delay:0
                                            options:UIViewAnimationOptionAllowUserInteraction
                                         animations:^
                                        {
                                            if(useRotation == YES)
                                            {
                                                [self runSpinAnimationOnView:imageView duration:1.9 rotations:0.9 repeat:0.9 ];
                                            }                                            
                                            [imageView setAlpha:1.0];
                                            [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                                        }
                                         completion:nil];
                        [activityIndicator stopAnimating];
                    });
                });
    
    
    //[activityIndicator stopAnimating];
    AppDelegate *delegateX = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    

 
    
    [delegateX.imageCache  setValue:imageView.image forKey:finalString];  
    
    
	//imageView.frame = self.bounds;
	//imageView.frame=CGRectMake(0, 0, 100, 100);
	
	//[imageView setNeedsLayout];
	//[self setNeedsLayout];
	
	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
	[activityIndicator stopAnimating];
    
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}




-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event    
{
    if(isTouchable == YES)
    {
        //NSLog(@"%i SWIPE", tileID);
    }
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{

}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isTouchable == YES)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        if(flipModeOn == NO)
        {
            flipModeOn = YES;
        }
        else
        { 
            flipModeOn = NO;
        }
       // NSLog(@"Touch Ended");
        [delegate touchedOK:self];
    }
}



-(void)blastOff
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            
            [UIView animateWithDuration:2.0 
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 [imageView setAlpha:0.0];
                 if(useRotation == YES)
                 {
                     [self runSpinAnimationOnView:imageView duration:1.75 rotations:0.9 repeat:0.9 ];
                 }
                 
                 int randomJet= arc4random() % 5;
                 BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
                 iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif                 
                 switch (randomJet)
                 {
                     case 1:
                         if(iPad == YES)
                         {
                             [imageView setFrame:CGRectMake(-300, -400, 0, 0)];
                         }
                         else
                         {
                             [imageView setFrame:CGRectMake(-300, -400, 0, 0)];
                         }
                         break;
                         
                     case 2:
                         if(iPad == YES)
                         {
                             [imageView setFrame:CGRectMake(-300, 1200, 0, 0)];
                         }
                         else
                         {
                             [imageView setFrame:CGRectMake(-300, 400, 0, 0)];
                         }
                         break; 
                         
                     case 3:
                         if(iPad == YES)
                         {
                             [imageView setFrame:CGRectMake(800, -300, 0, 0)];
                         }
                         else
                         {
                             [imageView setFrame:CGRectMake(400, -300, 0, 0)];
                         }
                         break; 
                     case 4:
                         if(iPad == YES)
                         {
                             [imageView setFrame:CGRectMake(800, 1200, 0, 0)];
                         }
                         else
                         {
                             [imageView setFrame:CGRectMake(400, 400, 0, 0)];
                         }
                         break;
                         
                         
                     default:
                         if(iPad == YES)
                         {
                             [imageView setFrame:CGRectMake(800, 2000, 0,0)];
                         }
                         else
                         {
                             [imageView setFrame:CGRectMake(800, 2000, 0,0)];
                         }                         
                         break;
                 }


             }
             
                             completion:^(BOOL completed){
                                 [self removeFromSuperview];
                                
}];
            
            
            
        });
    });

       

}
-(void)blastBack
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2.0 
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 if(useRotation == YES)
                 {
                     [self runSpinAnimationOnView:imageView duration:1.75 rotations:0.9 repeat:0.9 ];
                 }
                 [imageView setAlpha:1.0];
                 [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
             }
                             
                             completion:^(BOOL finished) 
             {
                 [self sendSubviewToBack:imageView];
                 if(hits > 25)
                 {
                     [star1 setHidden:NO];
                     [self bringSubviewToFront:star1];
                     

                     
                 }
                 if(hits > 50)
                 {
                     [star2 setHidden:NO]; 
                     [self bringSubviewToFront:star2];
                 }
                 if(hits > 75)
                 {
                     [star3 setHidden:NO];
                     [self bringSubviewToFront:star3];                         
                     
                 }     
                 if(hits > 100)
                 {
                     [star4 setHidden:NO];
                     [self bringSubviewToFront:star4];                         
                     
                 }
             }


             ];       
        });
    });
}

-(void)setOpacity:(CGFloat)Opacity
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {

                 [imageView setAlpha:Opacity];
             }
                             completion:nil];       
        });
    });
}

@end