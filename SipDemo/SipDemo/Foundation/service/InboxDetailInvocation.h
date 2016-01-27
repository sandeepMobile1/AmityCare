//
//  InboxDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class InboxDetailInvocation;

@protocol InboxDetailInvocationDelegate

-(void)InboxDetailInvocationDidFinish:(InboxDetailInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface InboxDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;
@property(nonatomic,strong)NSString* mailId;

@end