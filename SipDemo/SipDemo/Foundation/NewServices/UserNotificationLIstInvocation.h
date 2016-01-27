//
//  UserNotificationLIstInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserNotificationLIstInvocation;

@protocol UserNotificationLIstInvocationDelegate

-(void)UserNotificationLIstInvocationDidFinish:(UserNotificationLIstInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UserNotificationLIstInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
