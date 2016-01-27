//
//  UploadAudioInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 19/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class UploadAudioInvocation;

@protocol UploadAudioInvocationDelegate

-(void)UploadAudioInvocationDidFinish:(UploadAudioInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface UploadAudioInvocation :SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSData *mdata;

@end
