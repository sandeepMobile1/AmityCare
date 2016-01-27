//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ChatListInvocation;

@protocol ChatListInvocationDelegate

-(void)chatListInvocationDidFinish:(ChatListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface ChatListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
