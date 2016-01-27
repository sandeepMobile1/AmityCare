//
//  DocZoomVC.m
//  Amity-Care
//
//  Created by Vijay Kumar on 30/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import "DocZoomVC.h"
#import "UIImageView+WebCache.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface DocZoomVC ()
@end

CGFloat pageHeight;
#define isIOSAbove4 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)

@implementation DocZoomVC

@synthesize scrollview,imageview;
@synthesize docType;

@synthesize imageURL;
@synthesize videoURL;
@synthesize documentURL;
@synthesize currentPage;
@synthesize pdfPageCount;

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
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageURL]]]];
    
    NSLog(@"%@",self.imageURL);
    
    //CGSize imgSize = img.size;
    
    //self.imageview.frame = CGRectMake(self.imageview.frame.origin.x, self.imageview.frame.origin.y, imgSize.width, imgSize.height);
    
    self.imageview.center = self.scrollview.center;
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
  //  [self.imageview setImage:img];
    
//    [self.imageview setImageWithURL:img placeholderImage:[UIImage imageNamed:@"user_default.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage=1;

    [btnNext setHidden:TRUE];
    [btnPrev setHidden:TRUE];

    
    self.navigationController.navigationBarHidden = NO;
    if(DEVICE_OS_VERSION_7_0)
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:89/255.0 green:127/255.0 blue:234/255.0 alpha:1.0];
    else
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:89/255.0 green:127/255.0 blue:234/255.0 alpha:1.0];
    
    self.title = @"Document";
    
   // NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:TITLE_FONT_NAME size:24.0],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor, nil];
    
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
    NSLog(@"image URKL -%@",[NSString stringWithFormat:@"%@%@",largePostThumbnailImageURL,self.imageURL]);
    
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
    

    NSLog(@"pdfPageCount %ld",(long)pdfPageCount);

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
    
    [btnNext setHidden:FALSE];
    [btnPrev setHidden:FALSE];
    
    [self performSelector:@selector(traverseInWebViewWithPage) withObject:nil afterDelay:0.1];

}
-(void)traverseInWebViewWithPage
{
    //Get total pages in PDF File ----------- PDF File name here ---------------
   
    NSLog(@"%@",self.documentURL);
    
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)[NSURL URLWithString:self.documentURL]);
    self.pdfPageCount = (NSInteger)CGPDFDocumentGetNumberOfPages(pdf);
    
    
    CGFloat totalPDFHeight = documentWebView.scrollView.contentSize.height;
    NSLog ( @"total pdf height: %f", totalPDFHeight);
    
    //Calculate page height of single PDF page in webView
    NSInteger horizontalPaddingBetweenPages = 10*(self.pdfPageCount+1);
    pageHeight = (totalPDFHeight-horizontalPaddingBetweenPages)/(CGFloat)self.pdfPageCount;
    NSLog ( @"pdf page height: %f", pageHeight);
    
    //scroll to specific page --------------- here your page number -----------
    NSInteger specificPageNo = 2;
    if(specificPageNo <= self.pdfPageCount)
    {
        //calculate offset point in webView
        CGPoint offsetPoint = CGPointMake(0, (10*(specificPageNo-1))+(pageHeight*(specificPageNo-1)));
        //set offset in webView
        [documentWebView.scrollView setContentOffset:offsetPoint];
    }
}
-(NSInteger)getTotalPDFPages:(NSString *)strPDFFilePath
{
    NSURL *pdfUrl = [NSURL URLWithString:strPDFFilePath];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)pdfUrl);
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    return pageCount;
}
-(IBAction) nextPage: (id) sender
{
    NSLog(@"%ld",(long)pdfPageCount);
    NSLog(@"%ld",(long)currentPage);

    if (currentPage < pdfPageCount)
    {
        float y =  pageHeight * currentPage++;
        
        if (isIOSAbove4)
        {
            [[documentWebView scrollView] setContentOffset:CGPointMake(0,y) animated:YES];
        }
        else
        {
            [documentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0.0, %f)", y]];
        }
    }
}


-(IBAction) prevPage: (id) sender
{
    if (currentPage - 1)
    {
        float y = --currentPage * pageHeight - pageHeight;
        if (isIOSAbove4)
        {
            [[documentWebView scrollView] setContentOffset:CGPointMake(0,y) animated:YES];
        }
        else
        {
            [documentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0.0, %f)", y]];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [DSBezelActivityView removeView];
    if(error){
        [ConfigManager showAlertMessage:@"Error Loading Page" Message:[error description]];
    }
}

/*
 
 -(void)loadDocumentInGoogleDocs
 {
 NSLog(@"self.documentURL BEFORE =%@",self.documentURL);
 
 //    NSString *thePath = (NSString*)[[NSString stringWithFormat:@"%@", self.strPdfUrl] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 //    NSString *theUrlString = [thePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 NSString *thePath = (NSString*)[NSString stringWithFormat:@"http://docs.google.com/viewer?url=%@", self.documentURL];
 
 //    theUrlString = [theUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    NSURL *theURL = [[NSURL alloc] initWithString:theUrlString];
 
 thePath = [thePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 NSURL *theURL = [[NSURL alloc] initWithString:thePath];
 
 NSLog(@"%@",theURL);
 
 //[[UIApplication sharedApplication] openURL:theURL];
 
 documentWebView = [[UIWebView alloc] initWithFrame:scrollview.frame];
 documentWebView.delegate = self;
 [documentWebView setPaginationMode:UIWebPaginationModeTopToBottom];
 [documentWebView setScalesPageToFit:YES];
 NSLog(@"%@",NSStringFromCGSize(documentWebView.scrollView.contentSize));
 
 [documentWebView.scrollView setZoomScale:1.0 animated:YES];
 [documentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.documentURL]]];
 
 [scrollview addSubview:documentWebView];
 
 }

 */

@end
