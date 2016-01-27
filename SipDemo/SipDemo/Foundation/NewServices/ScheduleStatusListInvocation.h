//
//  ScheduleStatusListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ScheduleStatusListInvocation;

@protocol ScheduleStatusListInvocationDelegate

-(void)ScheduleStatusListInvocationDidFinish:(ScheduleStatusListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ScheduleStatusListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
