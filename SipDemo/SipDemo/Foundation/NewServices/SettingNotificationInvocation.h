//
//  SettingNotificationInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 05/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SettingNotificationInvocation;

@protocol SettingNotificationInvocationDelegate

-(void)SettingNotificationInvocationDidFinish:(SettingNotificationInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface SettingNotificationInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
