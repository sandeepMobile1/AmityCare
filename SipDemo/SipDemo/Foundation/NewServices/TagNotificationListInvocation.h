//
//  TagNotificationListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 08/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagNotificationListInvocation;

@protocol TagNotificationListInvocationDelegate

-(void)TagNotificationListInvocationDidFinish:(TagNotificationListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface TagNotificationListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *tag_id;
@property(nonatomic, strong) NSString *page_index;

@end
