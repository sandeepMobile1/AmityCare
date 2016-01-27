//
//  DelelteAllNotificationInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 21/08/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteAllNotificationInvocation;

@protocol DeleteAllNotificationInvocationDelegate

-(void)deleteAllInvocationDidFinish:(DeleteAllNotificationInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteAllNotificationInvocation : SAServiceAsyncInvocation

@property(nonatomic, strong) NSString *userId;

@end
