//
//  GetFormListInvocation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetFormListInvocation;

@protocol GetFormListInvocationDelegate

- (void)getFormListInvocationDidFinish:(GetFormListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface GetFormListInvocation : SAServiceAsyncInvocation
{
    
}

@property(nonatomic,strong) NSString *tagId;

@end

