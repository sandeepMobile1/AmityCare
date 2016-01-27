//
//  AddNewTaskVC.h
//  Amity-Care
//
//  Created by Vijay Kumar on 18/04/14.
//  Copyright (c) 2014 OctalInfoSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@class TagSelectionVC;
@class UserSelectionVC;

@protocol TaskDelegate <NSObject>

@optional
-(void)taskStatusDidChanged:(BOOL)status;

@end

@interface AddNewTaskVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField* tfTaskTitle;
    IBOutlet UITextField* tfTaskDate;
    IBOutlet UITextField* tfTaskAssoTags;
    IBOutlet UITextField* tfTaskAssoUsers;
    IBOutlet UITextView*  tvTaskDesc;
    IBOutlet UISwitch *switchRepeatOpt;
    IBOutlet UIButton* btnSubmitTask;
    IBOutlet UILabel* lblRepeatOpt;
    
    NSMutableArray *arrTagsD,*arrSelUsersD;
    
    IBOutlet UIButton *btnAssociatedTag;
    IBOutlet UIButton *btnAssociateUsers;

    //user selection view
    
    IBOutlet UIScrollView *scrollView;
    UIDatePicker *datePicker;
    UIToolbar* toolbar;
    
    IBOutlet UIButton *btnSelf;
    IBOutlet UIButton *btnOneHour;
    IBOutlet UIButton *btnFifteenMin;


}
@property(nonatomic,strong) TagSelectionVC *tagS;
@property(nonatomic,strong) UserSelectionVC *usvc;

@property(nonatomic,assign) BOOL isEditTask;
@property(nonatomic,strong) Task *taskDetails;
@property(nonatomic,strong) NSString *selectedDate;
@property(nonatomic,strong) NSString *selectedTag;
@property(nonatomic,strong) NSString *selectedTagId;
@property(nonatomic,strong) NSString *serverDate;
@property(nonatomic,strong) NSString *repeatStr;

@property(nonatomic,unsafe_unretained)id<TaskDelegate>delegate;

-(IBAction)submitTaskAction:(id)sender;
-(IBAction)btnSelfPressed:(id)sender;
-(IBAction)btnBackAction:(id)sender;
-(IBAction)btnOneHourAction:(id)sender;
-(IBAction)btnFifteenMinAction:(id)sender;

@end
