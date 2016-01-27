//
//  EditMadFormViewController.h
//  Amity-Care
//
//  Created by Shweta Sharma on 07/04/15.
//
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "UploadMadFormInvocation.h"

@class PDFView;
@class PDFDocument;

@interface EditMadFormViewController : UIViewController  <UIWebViewDelegate,UIScrollViewDelegate,UploadMadFormInvocationDelegate>
{
    IBOutlet UIButton *btnEditPdf;
    IBOutlet UIButton *btnZoom;

    IBOutlet UIScrollView *scrollView;
    
}
@property (retain, nonatomic) NSString *fileName;
@property (retain, nonatomic) NSString *pdfUrl;
@property (retain, nonatomic) NSString *pdfPath;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,retain) SmoothLineView * canvas;
@property (nonatomic, strong) PDFDocument *document;
@property (nonatomic, strong) PDFView *pdfView;

-(IBAction)btnCrossAction:(id)sender;
-(IBAction)btnEditAction:(id)sender;
-(IBAction)btnDoneAction:(id)sender;
-(IBAction)btnClearAction:(id)sender;
-(IBAction)btnZoomAction:(id)sender;

//- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;
//- (instancetype)initWithResource:(NSString *)name NS_DESIGNATED_INITIALIZER;
//- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;
//- (void)reload;

@end
