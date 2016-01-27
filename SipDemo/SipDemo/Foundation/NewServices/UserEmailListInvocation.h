//
//  UserEmailListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserEmailListInvocation;

@protocol UserEmailListInvocationDelegate

-(void)UserEmailListInvocationDidFinish:(UserEmailListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UserEmailListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
