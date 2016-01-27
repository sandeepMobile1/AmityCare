//
//  TagsInvocation
//  Amity-Care
//

//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AssignTagInvocation;

@protocol AssignTagInvocationDelegate

-(void)assignTagInvocationDidFinish:(AssignTagInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface AssignTagInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *users;


@end
