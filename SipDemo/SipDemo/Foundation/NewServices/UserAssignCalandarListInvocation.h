//
//  UserAssignCalandarListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserAssignCalandarListInvocation;

@protocol UserAssignCalandarListInvocationDelegate

-(void)UserAssignCalandarListInvocationDidFinish:(UserAssignCalandarListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface UserAssignCalandarListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;

@end