//
//  ClockInView.h
//  Amity-Care
//
//  Created by Vijay Kumar on 28/07/14.
//
//

#import <UIKit/UIKit.h>

@interface ClockInView : UIView
{
    
    
    NSTimer * clockInTimer;
    
    int second,hrs,mins,days,week;
    
}
@property(nonatomic,assign)BOOL isPaused;

@property(nonatomic,strong)IBOutlet UILabel* lblTimer;
@property(nonatomic,assign) IBOutlet UISwitch *swClockin;

@property(nonatomic,strong) IBOutlet UILabel* lblClockOut;
@property(nonatomic,strong) IBOutlet UILabel* lblClockIn;

-(void)userClockedIn:(BOOL)clockedIn;
-(void)startTimer;
-(void)stopTimer;
-(void)stopTimer1;
-(void)userClockedOut;
@end
