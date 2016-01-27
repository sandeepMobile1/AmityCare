//
//  ScheduleFormListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ScheduleFormListInvocation;

@protocol ScheduleFormListInvocationDelegate

-(void)ScheduleFormListInvocationDidFinish:(ScheduleFormListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ScheduleFormListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
