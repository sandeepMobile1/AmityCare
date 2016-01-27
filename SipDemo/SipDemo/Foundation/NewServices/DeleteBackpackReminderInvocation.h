//
//  DeleteBackpackReminderInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteBackpackReminderInvocation;

@protocol DeleteBackpackReminderInvocationDelegate

-(void)DeleteBackpackReminderInvocationDidFinish:(DeleteBackpackReminderInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteBackpackReminderInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
