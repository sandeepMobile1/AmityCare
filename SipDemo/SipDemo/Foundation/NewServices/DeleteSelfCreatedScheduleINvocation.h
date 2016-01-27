//
//  DeleteSelfCreatedScheduleINvocation.h
//  Amity-Care
//
//  Created by Admin on 18/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteSelfCreatedScheduleINvocation;

@protocol DeleteSelfCreatedScheduleINvocationDelegate

-(void)DeleteSelfCreatedScheduleINvocationDidFinish:(DeleteSelfCreatedScheduleINvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeleteSelfCreatedScheduleINvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
