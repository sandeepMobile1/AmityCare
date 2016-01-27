//
//  SetProfileInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 23/04/14.
//  Copyright (c) 2014 com.octalinfosolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteNotificationInvocation;

@protocol DeleteNotificationInvocationDelegate

-(void)deleteNotificationDidFinish:(DeleteNotificationInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface DeleteNotificationInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *n_id;

@end
