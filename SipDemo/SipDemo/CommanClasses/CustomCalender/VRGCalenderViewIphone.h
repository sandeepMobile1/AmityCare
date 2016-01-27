//
//  VRGCalenderViewIphone.h
//  Amity-Care
//
//  Created by Shweta Sharma on 27/10/14.
//
//

#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

#define kVRGCalendarViewTopBarHeight 60
#define kVRGCalendarViewWidthIphone 275

#define kVRGCalendarViewDayWidthIphone 37
#define kVRGCalendarViewDayHeightIphone 37

@protocol VRGCalenderViewIphoneDelegate;

@interface VRGCalenderViewIphone : UIView{
    
    __weak id <VRGCalenderViewIphoneDelegate> delegate;
    NSDate *currentMonth;
    
    UILabel *labelCurrentMonth;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedColors;
    
    int month;
    int year;
}

@property (nonatomic, weak) id <VRGCalenderViewIphoneDelegate> delegate;
@property (nonatomic, retain) NSDate *currentMonth;
@property (nonatomic, retain) UILabel *labelCurrentMonth;
@property (nonatomic, retain) UIImageView *animationView_A;
@property (nonatomic, retain) UIImageView *animationView_B;
@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain) NSArray *markedColors;
@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;

-(void)selectDate:(NSInteger)date;
-(void)reset;

-(void)markDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;

@end

@protocol VRGCalenderViewIphoneDelegate <NSObject>
-(void)calendarViewIphone:(VRGCalenderViewIphone *)calendarView switchedToMonth:(NSInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated;
-(void)calendarViewIphone:(VRGCalenderViewIphone *)calendarView dateSelected:(NSDate *)date;
@end
