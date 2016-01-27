//
//  UpdateContactNotificationInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 19/09/14.
//
//


#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UpdateContactNotificationInvocation;

@protocol UpdateContactNotificationInvocationDelegate

-(void)updateContactNotificationInvocationDidFinish:(UpdateContactNotificationInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface UpdateContactNotificationInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* contactId;
@property(nonatomic,strong)NSString* notificationStatus;

@end