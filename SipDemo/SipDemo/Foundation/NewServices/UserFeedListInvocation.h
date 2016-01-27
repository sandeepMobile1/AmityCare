//
//  UserFeedListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UserFeedListInvocation;

@protocol UserFeedListInvocationDelegate

-(void)UserFeedListInvocationDidFinish:(UserFeedListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface UserFeedListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *roleId;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString* lastIndex;
@property(nonatomic, strong) NSString *timeLine;

@end
