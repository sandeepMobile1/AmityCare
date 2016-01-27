//
//  TagsInvocation
//  Amity-Care
//

//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagsListInvocation;

@protocol TagsListInvocationDelegate

-(void)tagsListInvocationDidFinish:(TagsListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface TagsListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
