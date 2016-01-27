//
//  UserCompletedFormDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserCompletedFormDetailInvocation;

@protocol UserCompletedFormDetailInvocationDelegate

-(void)UserCompletedFormDetailInvocationDidFinish:(UserCompletedFormDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UserCompletedFormDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
