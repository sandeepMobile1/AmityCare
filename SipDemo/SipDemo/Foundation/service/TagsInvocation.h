//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagsInvocation;

@protocol TagsInvocationDelegate

-(void)tagsInvocationDidFinish:(TagsInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface TagsInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
