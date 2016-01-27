//
//  FormListVC.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "Form.h"
#import "GetFormDetailInvocation.h"
#import "UploadAudioInvocation.h"
#import "UploadDocInvocation.h"
#import "UploadSignatureInvocation.h"

@class AVAudioRecorder;
@class AVAudioSession;
@class AVAudioPlayer;

@interface FormListVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UploadDocInvocationDelegate,UploadSignatureInvocationDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIWebViewDelegate,GetFormDetailInvocationDelegate,UploadAudioInvocationDelegate>
{
    float yCoordinate;
    float yLocalCoordinate;
    
    BOOL isImageUpload;// upload single image or entire data
    
    UIScrollView *localScrollView;
    
    
    IBOutlet UIButton *customEmployeeBtn;
    IBOutlet UIButton *customManagerBtn;
    IBOutlet UIButton *customTLBtn;
    IBOutlet UIButton *customFamlityBtn;
    // IBOutlet UIButton *customTrainingBtn;
    IBOutlet UIButton *customBSBtn;
    IBOutlet UIButton *radioEmployeeBtn;
    IBOutlet UIButton *radioManagerBtn;
    IBOutlet UIButton *radioTLBtn;
    IBOutlet UIButton *radioFamilyBtn;
    IBOutlet UIButton *radioBSBtn;
    //IBOutlet UIButton *radioTrainingBtn;
    IBOutlet UITextField* tfTaskDate;
    
    UIDatePicker *datePicker;
    UIToolbar* toolbar;
    
    UILongPressGestureRecognizer *longPress;
    
    AVAudioRecorder * soundRecorder;
    AVAudioPlayer *audioPlayer;
    
    NSTimer *audioProgressTimer;
    
    
    BOOL checkMandatory;
    
    IBOutlet UIButton *outputAudioButton;
    IBOutlet UISlider *outputAudioSlider;
    
    IBOutlet UIImageView *largeImgView;
    
}
@property (strong, nonatomic)UIImagePickerController *imagePickerController;
@property (strong, nonatomic)UIView *imagePickerView;
@property (strong, nonatomic)IBOutlet UIView *permissionView;
@property (strong, nonatomic)IBOutlet UIView *drawingView;
@property (strong, nonatomic)IBOutlet UIView *lowerView;
@property (strong, nonatomic)IBOutlet UIView *signatureView;
@property (strong, nonatomic)IBOutlet UIView *outputAudioView;

@property (strong, nonatomic)IBOutlet UIView *zoomView;
@property (strong, nonatomic)IBOutlet UIWebView *largeWebView;

@property (strong, nonatomic) Form *formData;
@property(nonatomic,strong)NSString *recorderFilePath;
@property(nonatomic,assign)BOOL checkMendatory;

@property (strong, nonatomic) NSString *formNameStr;

@property (strong, nonatomic) NSMutableArray *formElementArr;
@property (strong, nonatomic) NSMutableArray *submitDataArr;

@property (strong, nonatomic) NSMutableArray *fileBtnArr;

@property (retain, nonatomic) NSMutableArray *radioBtnDic;
@property (retain, nonatomic) NSMutableDictionary *submitDataDic;
@property (nonatomic, strong) UIPopoverController* popover;
@property (nonatomic,retain) SmoothLineView * canvas;

@property(nonatomic,strong) NSString *serverDate;

@property (retain, nonatomic) UIButton *selectedBtn;

@property (retain, nonatomic) UIImage *capturedImg;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) NSString *formOutputVideoStr;
@property (retain, nonatomic) NSString *formOutputAudioStr;
@property (retain, nonatomic) NSString *formOutputImageStr;
@property (retain, nonatomic) NSString *formTypeStr;
@property (retain, nonatomic) NSString *noOfPages;

@property (assign, nonatomic) int pageIndex;
@property (assign, nonatomic) long selectedIndex;

@property (retain, nonatomic) NSMutableArray *formsArr;
@property (retain, nonatomic) NSMutableArray *totalFormArr;
@property (strong, nonatomic) NSRegularExpression *uuidRegex;

-(BOOL)checkFromBeaconRange;

- (IBAction)employeeBtnPressed:(id)sender;
- (IBAction)managerBtnPressed:(id)sender;
- (IBAction)teamLeaderBtnPressed:(id)sender;
//- (IBAction)trainingBtnPressed:(id)sender;
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)bSBtnPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnSignatureSubmitAction:(id)sender;
-(IBAction)btnSignatureClearAction:(id)sender;
-(IBAction)btnCloseSignatureAction:(id)sender;
-(IBAction)btnOutputAudioBtnAction:(UIButton*)sender;
-(IBAction)btnAudioSliderMoveAction:(UISlider*)sender;
-(IBAction)btnCloseLargeImgViewAction:(id)sender;

@end
