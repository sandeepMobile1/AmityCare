//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteContactInvocation;

@protocol DeleteContactInvocationDelegate

-(void)deleteContactInvocationDidFinish:(DeleteContactInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface DeleteContactInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *member_id;

@end
