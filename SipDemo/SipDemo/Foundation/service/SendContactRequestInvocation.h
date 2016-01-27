//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SendContactRequestInvocation;

@protocol SendContactRequestInvocationDelegate

-(void)sendContactRequestInvocationDidFinish:(SendContactRequestInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SendContactRequestInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *member_id;

@end
