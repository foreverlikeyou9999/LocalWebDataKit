//
//  LWDKSyncSession.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKSyncSession.h"

@implementation LWDKSyncSession

+ (LWDKSyncSession *)syncSessionWithDataPath:(NSString *)theDataPath
                           remoteManifestURL:(NSURL *)theRemoteManifestURL
                                    delegate:(id)theDelegate
{
    return [[[LWDKSyncSession alloc] initWithDataPath:theDataPath remoteManifestURL:theRemoteManifestURL delegate:theDelegate] autorelease];
}

- (id)initWithDataPath:(NSString *)theDataPath
     remoteManifestURL:(NSURL *)theRemoteManifestURL
              delegate:(id)theDelegate
{
    self = [super init];
    if(self) {
        dataPath = [theDataPath copy];
        remoteManifestURL = [theRemoteManifestURL copy];
        delegate = theDelegate;
        
        NSLog(@"The delegate is %@", delegate);
    }
    return self;
}

- (void)dealloc
{
    [dataPath release];
    [remoteManifestURL release];
    
    [super dealloc];
}

- (void)cancelSyncSession
{
    
}

@end
