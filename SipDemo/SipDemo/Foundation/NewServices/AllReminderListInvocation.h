//
//  AllReminderListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllReminderListInvocation;

@protocol AllReminderListInvocationDelegate

-(void)AllReminderListInvocationDidFinish:(AllReminderListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface AllReminderListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
