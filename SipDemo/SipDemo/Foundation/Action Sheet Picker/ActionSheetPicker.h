//
//  ActionSheetPicker.h
//  Spent
//
//  Created by Tim Cinel on 3/01/11.
//  Copyright 2011 Thunderous Playground. All rights reserved.
//
//
//	Easily present an ActionSheet with a PickerView to select from a number of immutible options,
//	based on the drop-down replacement in mobilesafari.
//
//	Some code derived from marcio's post on Stack Overflow [ http://stackoverflow.com/questions/1262574/add-uipickerview-a-button-in-action-sheet-how ]  

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@protocol ActionSheetPickerDelegate <NSObject>

@optional
-(void) cancelBtnSelect;

@end

@interface ActionSheetPicker : NSObject <UIPickerViewDelegate,UIPickerViewDataSource> {
	
	
	NSArray *_data;
	NSInteger _selectedIndex;
	NSString *_title;
	
	UIDatePickerMode _datePickerMode;
	NSDate *_selectedDate;
	
	//id _target;
	//SEL _action;
	
	
	NSInteger _pickerPosition;
   // id <ActionSheetPickerDelegate> delegate;
}

@property (assign) id<ActionSheetPickerDelegate> delegate;

@property (nonatomic, retain) UIView *view;

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, assign) NSInteger pickerPosition;
@property (nonatomic, assign) float componentWidth;
@property (nonatomic, readonly) CGSize viewSize;

//no memory management required for convenience methods

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title withDelegate:(id)delegate_ width:(float)widthComponent;

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title width:(float)widthComponent;

+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action;

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title width:(float)widthComponent;

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

//implementation
- (void)showActionPicker;
- (void)showDataPicker;
- (void)showDatePicker;

- (void)actionPickerDone;
- (void)actionPickerCancel;

- (void)eventForDatePicker:(id)sender;

- (BOOL)isViewPortrait;

@end
