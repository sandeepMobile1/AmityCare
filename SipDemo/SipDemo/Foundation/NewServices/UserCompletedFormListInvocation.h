//
//  UserCompletedFormListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserCompletedFormListInvocation;

@protocol UserCompletedFormListInvocationDelegate

-(void)UserCompletedFormListInvocationDidFinish:(UserCompletedFormListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UserCompletedFormListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
