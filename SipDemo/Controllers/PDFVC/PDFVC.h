//
//  PDFVC.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 29/09/14.
//
//

#import <UIKit/UIKit.h>

@interface PDFVC : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) NSString *fileName;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

-(IBAction)btnBackAction:(id)sender;


@end
