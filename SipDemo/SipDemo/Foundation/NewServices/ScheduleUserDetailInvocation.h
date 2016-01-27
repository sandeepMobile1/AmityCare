//
//  ScheduleUserDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 02/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ScheduleUserDetailInvocation;

@protocol ScheduleUserDetailInvocationDelegate

-(void)ScheduleUserDetailInvocationDidFinish:(ScheduleUserDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ScheduleUserDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
