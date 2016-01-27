//
//  SelfCreatedScheduleListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SelfCreatedScheduleListInvocation;

@protocol SelfCreatedScheduleListInvocationDelegate

-(void)SelfCreatedScheduleListInvocationDidFinish:(SelfCreatedScheduleListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface SelfCreatedScheduleListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
