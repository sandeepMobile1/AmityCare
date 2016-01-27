//
//  GetFromNameInvacation.h
//  Amity-Care
//
//  Created by Dharmbir Singh on 03/09/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetFormNameInvacation;

@protocol GetFormNameInvacationDelegate

- (void)getFormNameInvocationDidFinish:(GetFormNameInvacation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface GetFormNameInvacation : SAServiceAsyncInvocation
{
    
}

@property(nonatomic,strong) NSString *tagId;

@end
