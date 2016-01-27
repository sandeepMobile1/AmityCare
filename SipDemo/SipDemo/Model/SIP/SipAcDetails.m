//
//  SipAcDetails.m
//  Amity-Care
//
//  Created by Vijay Kumar on 27/06/14.
//
//

#import "SipAcDetails.h"

@implementation SipAcDetails
@synthesize ipAddress;
@synthesize username;
@synthesize password;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
	if (self != nil)
    {
        self.ipAddress = [decoder decodeObjectForKey:@"ipAddress"];
        self.username=[decoder decodeObjectForKey:@"username"];
        self.password=[decoder decodeObjectForKey:@"password"];
    }
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ipAddress forKey:@"ipAddress"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
}

@end
