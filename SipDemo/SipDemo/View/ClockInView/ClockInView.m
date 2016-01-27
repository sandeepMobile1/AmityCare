//
//  ClockInView.m
//  Amity-Care
//
//  Created by Vijay Kumar on 28/07/14.
//
//

#import "ClockInView.h"

@implementation ClockInView
@synthesize isPaused;
@synthesize swClockin;
@synthesize lblTimer;
@synthesize lblClockIn,lblClockOut;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arr;
        
        if (IS_DEVICE_IPAD) {
          
            arr = [[NSBundle mainBundle] loadNibNamed:@"ClockInView" owner:self options:nil];
            self = [arr objectAtIndex:0];
        }
        else
        {
            arr = [[NSBundle mainBundle] loadNibNamed:@"ClockInView_iphone" owner:self options:nil];
            self = [arr objectAtIndex:0];
        }
        
        isPaused = NO;
        
        [self layoutClockInSubview];
        
        second =hrs=mins = 0;
        
//        [self startTimer];
    }
    
    return self;
}

-(void)startTimer
{
    if(![clockInTimer isValid]){
        clockInTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:clockInTimer forMode:NSRunLoopCommonModes];
    }
    [clockInTimer fire];
}

-(void)stopTimer{
//    if([clockInTimer isValid]){
        self.isPaused = YES;
//        [clockInTimer invalidate];
//    }
}

-(void)stopTimer1
{
    lblTimer.text = @"";

    [clockInTimer invalidate];
    clockInTimer = nil;
    
    second = 0;
    hrs = 0;
    mins = 0;
    days = 0;
    week = 0;
    
}

-(void)layoutClockInSubview
{
    [swClockin setOn:NO animated:YES];
    lblClockOut.font = [UIFont fontWithName:appfontName size:17.0];
    lblClockIn.font = [UIFont fontWithName:appfontName size:17.0];
    lblTimer.font = [UIFont fontWithName:appfontName size:13.0];
    
}

-(void)userClockedOut
{
    [swClockin setOn:NO animated:YES];
    [lblTimer setHidden:YES];
//    if([clockInTimer isValid]){
//        [clockInTimer invalidate];
//        clockInTimer =nil;
//    }
}

-(void)userClockedIn:(BOOL)clockedIn
{
    if(!clockedIn){
        
        self.isPaused = YES;
        [swClockin setOn:NO animated:YES];
//        [clockInTimer invalidate];
//        clockInTimer = nil;
        
    }
    else{
        
        self.isPaused = NO;
        [swClockin setOn:YES animated:YES];
        
    }
}

-(void)updateTimer
{
    if(self.isPaused == NO) {
        second++;
        if (second>=60) {
            second=0;
            mins++;
        }
        if(mins>=60){
            mins = 0;
            hrs ++;
        }
        if(hrs>=24){
            hrs = 0;
            hrs ++;
        }
        if(days>=7){
            days=0;
            week++;
        }
        
        if(week==1){
            if (days>0) {
                lblTimer.text = [NSString stringWithFormat:@"%d Week %d Days",week,days];
            }
        }
        else if(week>1){
            lblTimer.text = [NSString stringWithFormat:@"%d Weeks %d Days",week,days];
        }
        else if (days>0){
            lblTimer.text = [NSString stringWithFormat:@"%d Days %d Hours %d Minutes",days,hrs,mins];
        }
        else if (hrs==1){
            lblTimer.text = [NSString stringWithFormat:@"%d Hour %d Minutes %d Seconds",hrs,mins,second];
        }
        else if (hrs>1){
            lblTimer.text = [NSString stringWithFormat:@"%d Hours %d Minutes %d Seconds",hrs,mins,second];
        }
        else if (mins==1){
            lblTimer.text = [NSString stringWithFormat:@"%d Minute %d Seconds",mins,second];
        }
        else if (mins>1){
            lblTimer.text = [NSString stringWithFormat:@"%d Minute %d Seconds",mins,second];
        }
        else if (second>0){
            lblTimer.text = [NSString stringWithFormat:@"%d Seconds",second];
        }
        
//        NSLog(@"Lbl Text %@",lblTimer.text);
    }
}

-(NSString*)week{
    return week>1?@"Weeks":@"Week";
}

-(NSString*)days
{
    return days>1?@"Days":@"Day";
}

-(NSString*)hours{
    return hrs>1?@"Hours":@"Hour";
}

-(NSString*)minutes{
    return hrs>1?@"Minutes":@"Minute";
}

-(NSString*)seconds{
    return hrs>1?@"Seconds":@"Second";
}

/*-(void)dealloc
{
    NSLog(@"@@@@@@@>>>>>>>>> CLOCL IN VIEW DEALLOC ---------->>>>>>>>>>");
    clockInTimer =nil;
    lblClockIn = nil;
    lblClockOut = nil;
    lblTimer = nil;
    swClockin = nil;
    
    [super dealloc];

}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
