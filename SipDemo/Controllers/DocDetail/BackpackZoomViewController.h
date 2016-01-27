//
//  BackpackZoomViewController.h
//  SipDemo
//
//  Created by Om Prakash on 15/09/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger,loadDocWithType) {
    
    documentTypeImage,
    documentTypeVideo,
    documentTypeFiles,
    documentTypeClockIn,
};


@interface BackpackZoomViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    MPMoviePlayerController *mpPlayer;
    IBOutlet UIScrollView *scrollview;
    UIWebView* documentWebView;
}
//image URL
@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) NSString* imageURL;

//Video URL
@property(nonatomic,strong) NSString* videoURL;

//Document
@property(nonatomic,strong) NSString* documentURL;


@property(nonatomic,assign) loadDocWithType docType;

-(IBAction)btnBackAction:(id)sender;



@end
