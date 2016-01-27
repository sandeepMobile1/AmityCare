//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteMsgInvocation;

@protocol DeleteMsgInvocationDelegate

-(void)deleteMsgInvocationDidFinish:(DeleteMsgInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface DeleteMsgInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSDictionary* dict;

@end
