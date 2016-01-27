//
//  UploadBackgroundRecordingInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 31/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadBackgroundRecordingInvocation;

@protocol UploadBackgroundRecordingInvocationDelegate

-(void)UploadBackgroundRecordingInvocationDidFinish:(UploadBackgroundRecordingInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UploadBackgroundRecordingInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
