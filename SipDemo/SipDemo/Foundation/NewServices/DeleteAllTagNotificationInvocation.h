//
//  DeleteAllTagNotificationInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteAllTagNotificationInvocation;

@protocol DeleteAllTagNotificationInvocationDelegate

-(void)DeleteAllTagNotificationInvocationDidFinish:(DeleteAllTagNotificationInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteAllTagNotificationInvocation : SAServiceAsyncInvocation

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *tagId;

@end
