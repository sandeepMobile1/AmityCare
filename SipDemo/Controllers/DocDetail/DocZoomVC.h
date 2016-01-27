//
//  DocZoomVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 30/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger,loadDocWithType) {
    
    documentTypeImage,
    documentTypeVideo,
    documentTypeFiles,
    documentTypeClockIn,
};

@interface DocZoomVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    MPMoviePlayerController *mpPlayer;
    IBOutlet UIScrollView *scrollview;
    UIWebView* documentWebView;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;

}
//image URL
@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) NSString* imageURL;
@property (assign, nonatomic) NSInteger pdfPageCount;
@property (assign, nonatomic) NSInteger currentPage;

//Video URL
@property(nonatomic,strong) NSString* videoURL;

//Document
@property(nonatomic,strong) NSString* documentURL;


@property(nonatomic,assign) loadDocWithType docType;

-(IBAction)btnBackAction:(id)sender;
-(IBAction) nextPage: (id) sender;
-(IBAction) prevPage: (id) sender;

@end
