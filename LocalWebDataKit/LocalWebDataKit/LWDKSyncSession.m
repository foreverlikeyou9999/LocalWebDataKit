//
//  LWDKSyncSession.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKSyncSession.h"

@interface LWDKSyncSession (Private)
- (NSString *)temporaryDirectory;
- (NSString *)storedManifestPath;
- (void)cancelCurrentDownload;
- (void)removeTemporaryDirectory;
- (void)downloadFile:(NSString *)fileURL;

- (void)downloadManifest;
- (void)writeData:(NSData *)data toContentPath:(NSString *)path;

- (void)prepareDeltasWithSyncManifest:(LWDKManifest *)syncManifest;
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
    
    [addedFiles release];
    [modifiedFiles release];
    [removedFiles release];
    
    [super dealloc];
}

- (void)cancelSyncSession
{
    [self cancelCurrentDownload];
    [self removeTemporaryDirectory];
}

#pragma mark -
#pragma mark Private
- (NSString *)temporaryDirectory
{
    NSString *tempDirectory = NSTemporaryDirectory();
    return [tempDirectory stringByAppendingPathComponent:@"LWDKSession"];
}

- (NSString *)storedManifestPath
{
    return [dataPath stringByAppendingPathComponent:@"manifest.plist"];
}

- (void)cancelCurrentDownload
{
    [download cancel];
    [download release];
    download = nil;
    
    [downloadURL release];
    downloadURL = nil;
}

- (void)removeTemporaryDirectory
{
    NSString *temporaryDirectory = [self temporaryDirectory];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:temporaryDirectory];
    
    for(NSString *path = [enumerator nextObject]; path != nil; path = [enumerator nextObject]) {
        NSLog(@"Deleting %@", path);
        [[NSFileManager defaultManager] removeItemAtPath:path error:0];
    }
    
    NSLog(@"Deleting %@", temporaryDirectory);
    [[NSFileManager defaultManager] removeItemAtPath:temporaryDirectory error:0];
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

- (void)writeData:(NSData *)data toContentPath:(NSString *)path
{
    NSString *temporaryDirectory = [self temporaryDirectory];
    [[NSFileManager defaultManager] createDirectoryAtPath:temporaryDirectory withIntermediateDirectories:YES attributes:nil error:0];
    
    NSString *filePath = [temporaryDirectory stringByAppendingPathComponent:path];
    [data writeToFile:filePath atomically:YES];
}

- (void)prepareDeltasWithSyncManifest:(LWDKManifest *)syncManifest
{
    LWDKManifest *currentManifest = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[self storedManifestPath]]) {
        NSData *currentManifestData = [NSData dataWithContentsOfFile:[self storedManifestPath]];
        currentManifest = [LWDKManifest manifestWithPListData:currentManifestData];
    }
    
    [addedFiles release];
    [modifiedFiles release];
    [removedFiles release];
    
    addedFiles = [[syncManifest filesAddedSinceManifest:currentManifest] retain];
    modifiedFiles = [[syncManifest filesModifiedSinceManifest:currentManifest] retain];
    removedFiles = [[syncManifest filesRemovedSinceManifest:currentManifest] retain];
}

#pragma mark -
#pragma mark Callbacks
- (void)download:(ELDownload *)theDownload downloadedData:(NSData *)data
{
    if([downloadURL isEqualToString:[remoteManifestURL absoluteString]]) {
        [self writeData:data toContentPath:@"manifest.plist"];
        
        LWDKManifest *syncManifest = [LWDKManifest manifestWithPListData:data];
        [self prepareDeltasWithSyncManifest:syncManifest];
    } else {
        NSLog(@"Downloaded a data file");
    }
}

- (void)downloadFailed:(ELDownload *)theDownload
{
    [delegate syncSessionFailedToDownloadFile:downloadURL];
    
    [self cancelSyncSession];
}

@end
