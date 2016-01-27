//
//  GetRecordingDetailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 26/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetRecordingDetailInvocation;

@protocol GetRecordingDetailInvocationDelegate

-(void)GetRecordingDetailInvocationDidFinish:(GetRecordingDetailInvocation*)invocation withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface GetRecordingDetailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
