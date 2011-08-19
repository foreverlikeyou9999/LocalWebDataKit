//
//  LWDKSyncSession.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKSyncSession.h"

@interface LWDKSyncSession (Private)
- (void)cancelCurrentDownload;
- (void)downloadFile:(NSString *)fileURL;

- (void)downloadManifest;
@end

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
        
        [self downloadManifest];
    }
    return self;
}

- (void)dealloc
{
    [self cancelCurrentDownload];
    [dataPath release];
    [remoteManifestURL release];
    
    [super dealloc];
}

- (void)cancelSyncSession
{
    [self cancelCurrentDownload];
}

#pragma mark -
#pragma mark Private
- (void)cancelCurrentDownload
{
    [download cancel];
    [download release];
    download = nil;
    
    [downloadURL release];
    downloadURL = nil;
}

- (void)downloadFile:(NSString *)fileURL
{
    [self cancelCurrentDownload];
    
    downloadURL = [fileURL copy];
    download = [[ELDownload downloadWithURL:fileURL delegate:self] retain];
}

- (void)downloadManifest
{
    [self downloadFile:[remoteManifestURL absoluteString]];
}

#pragma mark -
#pragma mark Callbacks
- (void)download:(ELDownload *)theDownload downloadedData:(NSData *)data
{
    NSLog(@"%@", [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:0 errorDescription:0]);
}

- (void)downloadFailed:(ELDownload *)theDownload
{
    [delegate syncSessionFailedToDownloadFile:downloadURL];
    
    [self cancelSyncSession];
}

@end
