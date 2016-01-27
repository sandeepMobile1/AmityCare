//
//  InboxListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class InboxListInvocation;

@protocol InboxListInvocationDelegate

-(void)InboxListInvocationDidFinish:(InboxListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface InboxListInvocation :  SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;

@end