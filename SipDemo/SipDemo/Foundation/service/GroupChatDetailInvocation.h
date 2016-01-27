//
//  GroupChatDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 04/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GroupChatDetailInvocation;

@protocol GroupChatDetailInvocationDelegate

-(void)GroupChatDetailInvocationDidFinish:(GroupChatDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface GroupChatDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;

@end
