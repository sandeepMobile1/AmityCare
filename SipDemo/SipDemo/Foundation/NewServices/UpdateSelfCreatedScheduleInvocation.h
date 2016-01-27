//
//  UpdateSelfCreatedScheduleInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UpdateSelfCreatedScheduleInvocation;

@protocol UpdateSelfCreatedScheduleInvocationDelegate

-(void)UpdateSelfCreatedScheduleInvocationDidFinish:(UpdateSelfCreatedScheduleInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UpdateSelfCreatedScheduleInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
