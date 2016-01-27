//
//  TagAssignCalendarListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 30/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagAssignCalendarListInvocation;

@protocol TagAssignCalendarListInvocationDelegate

-(void)TagAssignCalendarListInvocationDidFinish:(TagAssignCalendarListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface TagAssignCalendarListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;

@end