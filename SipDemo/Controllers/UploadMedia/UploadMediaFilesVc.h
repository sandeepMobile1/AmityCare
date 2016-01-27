//
//  UploadMediaFilesVc.h
//  Amity-Care
//
//  Created by Vijay Kumar on 07/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, AC_UPLOAD_MEDIA_TYPE) {
    uploadMeidaImageFile=1,
    uploadMeidaVideoFile,
    uploadMediaFromDropbox,
};

@class TagSelectionVC;

@interface UploadMediaFilesVc : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

{
    IBOutlet UIView *containerView;
    IBOutlet UIImageView* imgThumbnailMedia;
    IBOutlet UITextField* tfUploadTitle;
    IBOutlet UITextField* tfUploadTags;
    IBOutlet UITextView* txtVwUploadDesc;
    IBOutlet UIButton *btnMedia;
    
    NSMutableArray *arrTags;
    
    MPMoviePlayerController *mpPlayer;
    int contentType;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIToolbar *keyboardtoolbar;
    NSArray				*fieldsArray;
    IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
    int movementDistance;
    float movementDuration;

}
@property(nonatomic,strong) TagSelectionVC *tagS;

@property(nonatomic,assign) AC_UPLOAD_MEDIA_TYPE uploadMedia;

@property(nonatomic,strong) UIImage *imageFile;

@property(nonatomic,strong) NSURL *videoURL;

@property(nonatomic,strong) NSString* attachmentURL;
@property(nonatomic,strong) NSDictionary *dDropBoxContent;

-(IBAction)uploadButtonAction:(id)sender;
-(IBAction)playMediaBtnAction:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextField;
-(IBAction)btnBackAction:(id)sender;

@end
