//
//  BackpackZoomViewController.m
//  SipDemo
//
//  Created by Om Prakash on 15/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import "BackpackZoomViewController.h"
#import "UIImageView+WebCache.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface BackpackZoomViewController ()

@end

@implementation BackpackZoomViewController


@synthesize scrollview,imageview;
@synthesize docType;

@synthesize imageURL;
@synthesize videoURL;
@synthesize documentURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadImage
{
    NSLog(@"%@",self.imageURL);
    
    self.imageview.center = self.scrollview.center;
    
    [self.imageview setBackgroundColor:[UIColor redColor]];
    
    //[self.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    if(DEVICE_OS_VERSION_7_0)
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:89/255.0 green:127/255.0 blue:234/255.0 alpha:1.0];
    else
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:89/255.0 green:127/255.0 blue:234/255.0 alpha:1.0];
    
    self.title = @"Document";
    
    
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:TITLE_FONT_NAME size:24.0], NSFontAttributeName,
                               [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    
    self.navigationController.navigationBar.titleTextAttributes = titleAttr;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame =CGRectMake(5, 0, 24, 24);
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 50, 30)];
    [temp addSubview:backBtn];
    temp.backgroundColor = TEXT_COLOR_GREEN;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlayingVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneButtonClick:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackAction:(id)sender
{
    [self.view removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(docType == documentTypeImage){
        
        [self loadDocumentViewWithImage];
        
    }
    else if(docType == documentTypeVideo){
        
        [self playVideoDocument];
        
    }
    else if (docType == documentTypeFiles){
        
        [self loadDocumentInGoogleDocs];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)dealloc
 {
 NSLog(@"=====%@==dealloc",[self class]);
 documentWebView = nil;
 self.scrollview = nil;
 imageview = nil;
 mpPlayer = nil;
 
 [super dealloc];
 }*/

#pragma mark- Video Document
-(void)doneButtonClick:(NSNotification*)notification{
    
    [mpPlayer stop];
    
}
-(void)didFinishPlayingVideo
{
    [mpPlayer stop];
    
    if (IS_DEVICE_IPAD) {
        
        //   [sharedAppDelegate.window setRootViewController:sharedAppDelegate.splitView];
        
    }
    else
    {
        [sharedAppDelegate.window setRootViewController:sharedAppDelegate.container];
        
    }
    
}

-(void)backBtnPressed:(id)sender
{
    if(docType == documentTypeVideo)
    {
        [self didFinishPlayingVideo];
    }
    else{
        if (IS_DEVICE_IPAD) {
            
            //  [sharedAppDelegate.window setRootViewController:sharedAppDelegate.splitView];
            
        }
        else
        {
            [sharedAppDelegate.window setRootViewController:sharedAppDelegate.container];
            
        }    }
}

-(void)showMediaPlayerAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [mpPlayer.view setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)hideMediaPlayerAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [mpPlayer.view setAlpha:0.0];
    [UIView commitAnimations];
    [mpPlayer.view removeFromSuperview];
}


-(void)playVideoDocument
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Please wait..." width:200];
    
    if(mpPlayer!=nil){
        [mpPlayer.view removeFromSuperview];
        mpPlayer = nil;
    }
    
    
    mpPlayer  = [[MPMoviePlayerController alloc ] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.videoURL]]];
    
    UIImage *singleFrameImage = [mpPlayer thumbnailImageAtTime:0
                                                    timeOption:MPMovieTimeOptionExact];
    
    UIImageView *imgThumbnailMedia = [[UIImageView alloc] initWithImage:singleFrameImage];
    [imgThumbnailMedia setFrame:CGRectMake(0, 64, 418, 350)];
    mpPlayer.view.frame = imgThumbnailMedia.frame;
    mpPlayer.view.center = scrollview.center;
    mpPlayer.scalingMode = MPMovieScalingModeAspectFit;
    mpPlayer.view.backgroundColor = [UIColor whiteColor];
    mpPlayer.controlStyle =MPMovieControlStyleDefault;
    [mpPlayer.view setAlpha:0.0f];
    
    [scrollview addSubview:mpPlayer.view];
    
    [DSBezelActivityView removeView];
    
    [self showMediaPlayerAnimation];
    
    [mpPlayer play];
}

#pragma mark- Document Load Helper
-(void)loadDocumentInGoogleDocs
{
    NSLog(@"self.documentURL BEFORE =%@",self.documentURL);
    CGRect frame  = scrollview.frame;
    // frame.size.height = frame.size.height - (DEVICE_OS_VERSION_7_0?64:44);
    
    documentWebView = [[UIWebView alloc] initWithFrame:frame];
    documentWebView.delegate = self;
    documentWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
    //[documentWebView sizeToFit];
    
    documentWebView.scalesPageToFit=YES;
    [documentWebView setUserInteractionEnabled:TRUE];
    
    documentWebView.allowsInlineMediaPlayback = YES;
    documentWebView.mediaPlaybackAllowsAirPlay = YES;
    
    [self.view addSubview:documentWebView];
    
    [scrollview setHidden:true];
    
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Loading document..." width:200.0f];
    
    [documentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.documentURL]]];
    
}
#pragma mark- Image Document Helper

-(void)loadDocumentViewWithImage
{
    //CGRect rect  = CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    if (IS_DEVICE_IPAD) {
        
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5, self.view.frame.origin.y+5, 430, 430)];
        
    }
    else
    {
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5, self.view.frame.origin.y+5, 300, 300)];
        
    }
    self.imageview.center = self.scrollview.center;
    
    [self performSelector:@selector(loadImage) withObject:nil afterDelay:0.1f];
    
    self.scrollview.maximumZoomScale = 2.0f;
    self.scrollview.minimumZoomScale = 0.5f;
    self.scrollview.clipsToBounds = YES;
    self.scrollview.delegate = self;
    self.scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollview.multipleTouchEnabled=YES;
    self.scrollview.scrollEnabled=YES;
    self.scrollview.directionalLockEnabled=YES;
    self.scrollview.canCancelContentTouches=YES;
    self.scrollview.delaysContentTouches=YES;
    self.scrollview.clipsToBounds=YES;
    self.scrollview.alwaysBounceHorizontal=YES;
    self.scrollview.bounces=YES;
    self.scrollview.pagingEnabled=YES;
    self.scrollview.showsVerticalScrollIndicator=NO;
    self.scrollview.showsHorizontalScrollIndicator=NO;
    
    [self.scrollview setHidden:true];
    
    
    [self.view addSubview:self.imageview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTapped:)];
    tap.numberOfTapsRequired = 2;
    [self.scrollview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pinch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidPinch:)];
    [self.scrollview addGestureRecognizer:pinch];
}



-(void)scrollViewDidPinch:(UIPanGestureRecognizer*)recognizer
{
    /*
     CGPoint touchPoint=[pinch locationInView:self.scrollview];
     NSLog(@"imageview.frame =%@ touchPoint =%@",NSStringFromCGRect(self.imageview.frame),NSStringFromCGPoint(touchPoint));
     if ( CGRectContainsPoint(self.imageview.frame, touchPoint) ) {
     self.imageview.center = touchPoint;
     }
     */
    CGPoint translation = [recognizer translationInView:self.scrollview];
    self.imageview.center = CGPointMake(self.imageview.center.x + translation.x,
                                        self.imageview.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.scrollview];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.scrollview];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(self.scrollview.center.x + (velocity.x * slideFactor),
                                         self.scrollview.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.scrollview.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.scrollview.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.imageview.center = finalPoint;
        } completion:nil];
    }
    
    
    
}

-(void)scrollViewDidTapped:(UITapGestureRecognizer*)tap
{
    CGFloat scaleFactor =  self.scrollview.zoomScale;
    
    if(scaleFactor >1.0)
        [self.scrollview setZoomScale:1.0 animated:YES];
    else
        [self.scrollview setZoomScale:1.8 animated:YES];
    
    self.imageview.center = self.scrollview.center;
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageview;
}

#pragma mark- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DSBezelActivityView removeView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [DSBezelActivityView removeView];
    if(error){
        [ConfigManager showAlertMessage:@"Error Loading Page" Message:[error description]];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
