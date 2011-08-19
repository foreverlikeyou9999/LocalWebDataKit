//
//  LWDKManifest.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKManifest.h"

@implementation LWDKManifest
+ (LWDKManifest *)manifestWithPListData:(NSData *)data
{
    return [[[LWDKManifest alloc] initWithPListData:data] autorelease];
}

- (id)initWithPListData:(NSData *)data
{
    self = [super init];
    
    if(self) {
        NSDictionary *plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:0 errorDescription:0];
        files = [[plist objectForKey:@"Files"] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [files release];
    
    [super dealloc];
}
@end
