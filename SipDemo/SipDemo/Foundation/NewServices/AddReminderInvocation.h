//
//  AddReminderInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddReminderInvocation;

@protocol AddReminderInvocationDelegate

-(void)AddReminderInvocationDidFinish:(AddReminderInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AddReminderInvocation :  SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
