//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class SendMessageInvocation;

@protocol SendMessageInvocationDelegate

-(void)sendMessageInvocationDidFinish:(SendMessageInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface SendMessageInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong)NSDictionary *msdDict;

@end
