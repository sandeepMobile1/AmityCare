//
//  ScheduleEmailListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ScheduleEmailListInvocation;

@protocol ScheduleEmailListInvocationDelegate

-(void)ScheduleEmailListInvocationDidFinish:(ScheduleEmailListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface ScheduleEmailListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
