//
//  AddSelfCreatedScheduleInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 16/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddSelfCreatedScheduleInvocation;

@protocol AddSelfCreatedScheduleInvocationDelegate

-(void)AddSelfCreatedScheduleInvocationDidFinish:(AddSelfCreatedScheduleInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface AddSelfCreatedScheduleInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
