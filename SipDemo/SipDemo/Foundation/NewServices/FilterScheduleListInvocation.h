//
//  FilterScheduleListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class FilterScheduleListInvocation;

@protocol FilterScheduleListInvocationDelegate

-(void)FilterScheduleListInvocationDidFinish:(FilterScheduleListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface FilterScheduleListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
