//
//  UserStatusListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserStatusListInvocation;

@protocol UserStatusListInvocationDelegate

-(void)UserStatusListInvocationDidFinish:(UserStatusListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UserStatusListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *roleId;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString* lastIndex;
@property(nonatomic, strong) NSString *timeLine;

@end
