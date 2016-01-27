//
//  UpdateScheduleInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UpdateScheduleInvocation;

@protocol UpdateScheduleInvocationDelegate

-(void)UpdateScheduleInvocationDidFinish:(UpdateScheduleInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UpdateScheduleInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
