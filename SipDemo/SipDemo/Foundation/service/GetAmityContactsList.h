//
//  TagsInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetAmityContactsList;

@protocol GetAmityContactsListDelegate

-(void)getAmityContactsListDidFinish:(GetAmityContactsList*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetAmityContactsList : SAServiceAsyncInvocation
{
    
}

@property(nonatomic, strong) NSString *user_id;

@end
