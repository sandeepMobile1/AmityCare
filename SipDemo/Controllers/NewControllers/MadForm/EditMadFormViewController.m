//
//  EditMadFormViewController.m
//  Amity-Care
//
//  Created by Shweta Sharma on 07/04/15.
//
//

#import "EditMadFormViewController.h"
#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "ACAlertView.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "AlertMessage.h"
#import "DSActivityView.h"

@interface EditMadFormViewController ()

@end

@implementation EditMadFormViewController

@synthesize webView,fileName,canvas,pdfPath,pdfUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_DEVICE_IPAD) {
        
        if (sharedAppDelegate.isPortrait) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
        else
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    else
    {
        if (!IS_IPHONE_5) {
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-IPHONE_FIVE_FACTOR)];
            
            
        }
    }
    
    if (IS_DEVICE_IPAD) {
        
        [self.webView setFrame:CGRectMake(0, 0, 1600, 4850)];
        
        [scrollView setContentSize:CGSizeMake(1600, 4850)];
    }
    else
    {
        [self.webView setFrame:CGRectMake(0, 0, 1200, 4000)];
        
        [scrollView setContentSize:CGSizeMake(1200, 4000)];
    }
    
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    
    pdfUrl = [[NSBundle mainBundle] pathForResource:@"MAR_Forms" ofType:@"pdf"];
    NSLog(@"%@",pdfUrl);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pdfUrl]];
    
    [self.webView loadRequest:request];
    
    self.canvas =[[SmoothLineView alloc] initWithFrame:self.webView.frame];
    [self.webView addSubview:self.canvas];
    
    [self.canvas setBackgroundColor:[UIColor clearColor]];
    
    [btnEditPdf setTag:0];
    
    
    
}
-(void)pdfToNSdata
{
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:pdfUrl];
    
    NSLog(@"%lu",(unsigned long)data.length);
}
-(NSString*)saveasPDF{
    
    NSString *string=[NSString stringWithFormat:@"%@.pdf",@"1"];
    // NSData *pdfData = [NSData dataWithContentsOfFile:pdfUrl];
    
    NSData *pdfData=nil;
    //pdfData=[self pdfDataWithTableView];
    //pdfData=[self savePDFFromWebView:self.webView];
    
    
    [pdfData writeToFile:[self getDBPathPDf:string] atomically:YES];
    
    NSLog(@"%lu",(unsigned long)pdfData.length);
    
    NSLog(@"%@",[self getDBPathPDf:string]);
    
    return [self getDBPathPDf:string];
}

-(NSString *) getDBPathPDf:(NSString *)PdfName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:PdfName];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (IS_DEVICE_IPAD) {
        
        // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    }
}
-(IBAction)btnCrossAction:(id)sender
{
    if (IS_DEVICE_IPAD) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
        
    }
    else
    {
        [self.view removeFromSuperview];
    }
}
-(IBAction)btnEditAction:(id)sender
{
    if ([btnEditPdf isSelected]) {
        
        [btnEditPdf setSelected:NO];
        
        sharedAppDelegate.strCheckDrawLine=@"NO";
        
        [scrollView setScrollEnabled:YES];
        
        /*  NSString *path=@"";;
         path=[self saveasPDF];
         
         NSLog(@"%@",path);
         
         self.webView.delegate=nil;
         
         
         [scrollView setFrame:CGRectMake(0, 49, 768, 921)];
         
         // [self.webView setFrame:CGRectMake(0, 0, 1600, 4850)];
         
         // [scrollView setContentSize:CGSizeMake(1600, 4850)];
         
         self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
         self.webView.scalesPageToFit = YES;
         self.webView.autoresizesSubviews = YES;
         
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
         self.webView.delegate=self;
         [self.webView loadRequest:request];
         
         [self.canvas removeFromSuperview];*/
        
    }
    else
    {
        
        [btnEditPdf setSelected:YES];
        sharedAppDelegate.strCheckDrawLine=@"YES";
        
        [self.canvas setUserInteractionEnabled:TRUE];
        
        [scrollView setScrollEnabled:NO];
        
        /* self.canvas =[[SmoothLineView alloc] initWithFrame:self.webView.frame];
         [self.webView addSubview:self.canvas];
         
         [self.canvas setBackgroundColor:[UIColor clearColor]];*/
        
    }
}
-(IBAction)btnZoomAction:(id)sender
{
    /* if ([btnZoom isSelected]) {
     
     [btnZoom setSelected:NO];
     
     [self.webView setFrame:CGRectMake(0, 0, 768, 1024)];
     
     [scrollView setContentSize:CGSizeMake(768, 1024)];
     
     
     
     }
     else
     {
     [btnZoom setSelected:YES];
     
     
     [self.webView setFrame:CGRectMake(0, 0, 1600, 4850)];
     
     [scrollView setContentSize:CGSizeMake(1600, 4850)];
     }*/
    
}
-(IBAction)btnDoneAction:(id)sender
{
    
    if([ConfigManager isInternetAvailable])
    {
        [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
        
        NSData *pdfData = [self pdfDataWithTableView];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:sharedAppDelegate.userObj.userId forKey:@"user_id"];
        
        [dict setObject:@"attachment" forKey:@"attachment_key"];
        [dict setObject:@"uploadMarePdf" forKey:@"request_path"];
        
        
        [dict setObject:@"test.pdf" forKey:@"filename"];
        [dict setObject:@"pdf" forKey:@"content_type"];
        
        
        [[AmityCareServices sharedService] UploadMadFormInvocation:dict signature:pdfData delegate:self];
    }
}

- (NSData *)pdfDataWithTableView
{
    CGRect pdfPageBounds = CGRectMake(0, 0, 1600, 4850);
    
    CGSize fittedSize=CGSizeMake(1600, 4850);
    
    //CGRect pdfPageBounds = CGRectMake(0, 0, self.webView.scrollView.contentSize.height, self.webView.scrollView.contentSize.height);
    
    //CGRect priorBounds = self.webView.bounds;
    // CGSize fittedSize = [self.webView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
    
    self.webView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
    
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil);
    {
        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height)
        {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            CGContextSaveGState(UIGraphicsGetCurrentContext());
            {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
                [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
            } CGContextRestoreGState(UIGraphicsGetCurrentContext());
        }
    } UIGraphicsEndPDFContext();
    
    //[scrollView setFrame:CGRectMake(0, 49, 768, 921)];
    //[self.webView setFrame:CGRectMake(0, 0, 768, 921)];
    
    return pdfData;
}
/*-(NSData*)savePDFFromWebView:(UIWebView*)webView1
 
 {
 int height, width, header, sidespace;
 
 height = webView1.scrollView.contentSize.height;
 
 width = webView1.scrollView.contentSize.width;
 
 header = 15;
 
 sidespace = 30;
 
 // set header and footer spaces
 
 UIEdgeInsets pageMargins = UIEdgeInsetsMake(header, sidespace, header, sidespace);
 
 webView1.viewPrintFormatter.contentInsets = pageMargins;
 
 UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
 
 [renderer addPrintFormatter:webView1.scrollView.viewPrintFormatter startingAtPageAtIndex:0];
 
 CGSize pageSize = CGSizeMake(width, height);
 
 CGRect printableRect = CGRectMake(pageMargins.left,
 pageMargins.top,
 pageSize.width - pageMargins.left - pageMargins.right,
 pageSize.height - pageMargins.top - pageMargins.bottom);
 
 CGRect paperRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
 
 [renderer setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
 
 [renderer setValue:[NSValue valueWithCGRect:printableRect]
 
 forKey:@"printableRect"];
 
 NSData *pdfData = [self printToPDFWithRenderer:renderer paperRect:paperRect];
 
 return pdfData;
 }
 
 -(NSData*) printToPDFWithRenderer:(UIPrintPageRenderer*)renderer  paperRect:(CGRect)paperRect
 
 {
 
 NSMutableData *pdfData = [NSMutableData data];
 
 UIGraphicsBeginPDFContextToData( pdfData, paperRect, nil );
 
 [renderer prepareForDrawingPages: NSMakeRange(0, renderer.numberOfPages)];
 
 CGRect bounds = UIGraphicsGetPDFContextBounds();
 
 NSLog(@"%d",renderer.numberOfPages);
 
 for ( int i = 0 ; i < renderer.numberOfPages ; i++ )
 {
 UIGraphicsBeginPDFPage();
 
 CGContextSaveGState(UIGraphicsGetCurrentContext());
 {
 // CGContextTranslateCTM(UIGraphicsGetCurrentContext(), scrollView.contentSize.width, scrollView.contentSize.height);
 
 NSLog(@"renderInContext %d",i);
 
 //[self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
 
 }
 
 NSLog(@"drawPageAtIndex %d",i);
 
 CGContextRestoreGState(UIGraphicsGetCurrentContext());
 
 [renderer drawPageAtIndex: i inRect: bounds];
 UIGraphicsBeginPDFPageWithInfo(bounds, nil);
 
 }
 
 UIGraphicsEndPDFContext();
 
 
 return pdfData;
 }*/
#pragma mark- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [DSBezelActivityView newActivityViewForView:sharedAppDelegate.window withLabel:@"Uploading please wait..." width:200];
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
#pragma mark orientation delegates

- (BOOL)shouldAutorotate {
    
    if (IS_DEVICE_IPAD) {
        
        return YES;
        
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    if (IS_DEVICE_IPAD) {
        
        return UIInterfaceOrientationMaskAll;
        
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            sharedAppDelegate.isPortrait=YES;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 418, 929)];
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            sharedAppDelegate.isPortrait=NO;
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 675, 670)];
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:YES];

}
-(IBAction)btnClearAction:(id)sender
{
    [self.canvas clear];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Invocation
-(void)UploadMadFormInvocationDidFinish:(UploadMadFormInvocation *)invocation withResults:(NSDictionary *)dict withError:(NSError *)error
{
    NSLog(@"UploadMadFormInvocationDidFinish =%@",dict);
    @try {
        
        if (!error) {
            
            id response = [dict valueForKey:@"response"];
            NSString* strSuccess = NULL_TO_NIL([response valueForKey:@"success"]);
            
            if([strSuccess rangeOfString:@"true"].length>0)
            {
                if (IS_DEVICE_IPAD) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
                    
                }
                else
                {
                    [self.view removeFromSuperview];
                }
                
            }
            else if([strSuccess rangeOfString:@"false"].length>0)
            {
                [ConfigManager showAlertMessage:nil Message:[response valueForKey:@"message"]];
                if (IS_DEVICE_IPAD) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName: AC_DISMISS_POPOVERVIEW_UPDATE object:nil];
                    
                }
                else
                {
                    [self.view removeFromSuperview];
                }
                
            }
            
        }
        else
        {
            [ConfigManager showAlertMessage:nil Message:@"Server is not responding.Please try again"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [DSBezelActivityView removeView];
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
