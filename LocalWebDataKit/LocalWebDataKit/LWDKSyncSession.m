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
- (void)buildDownloadList;
- (void)downloadNextFile;
- (void)downloadedAllFiles;
- (void)commitDownloadedFiles;

- (BOOL)allExpectedFilesArePresent;
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
    
    [downloadList release];
    
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
        [[NSFileManager defaultManager] removeItemAtPath:path error:0];
    }
    
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
    NSString *filePath = [temporaryDirectory stringByAppendingPathComponent:path];
    NSString *fileDirectory = [filePath stringByDeletingLastPathComponent];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:0];
    
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
    
    //NSLog(@"%i added files, %i modified files, %i removed files", addedFiles.count, modifiedFiles.count, removedFiles.count);
}

- (void)buildDownloadList
{
    if(!downloadList) {
        downloadList = [[NSMutableArray alloc] init];
    }
    
    [downloadList removeAllObjects];
    
    for(LWDKManifestFile *file in addedFiles) {
        [downloadList addObject:file];
    }
    
    for(LWDKManifestFile *file in modifiedFiles) {
        [downloadList addObject:file];
    }
}

- (void)downloadNextFile
{
    if(downloadList.count == 0) {
        [self downloadedAllFiles];
        return;
    }
    
    LWDKManifestFile *nextFile = [downloadList objectAtIndex:0];
    
    NSString *manifestURLString = [remoteManifestURL absoluteString];
    NSString *remoteContentFolder = [manifestURLString stringByDeletingLastPathComponent];
    NSString *nextFileURL = [remoteContentFolder stringByAppendingPathComponent:nextFile.fileName];
    [self downloadFile:nextFileURL];
}

- (void)downloadedAllFiles
{
    if(![self allExpectedFilesArePresent]) {
        [self cancelSyncSession];
        [delegate syncSessionInconsistentStateFailure];
        return;
    }
    
    [self commitDownloadedFiles];
}

- (void)commitDownloadedFiles
{
    NSString *temporaryDirectory = [self temporaryDirectory];
    NSString *syncManifestPath = [temporaryDirectory stringByAppendingPathComponent:@"manifest.plist"];
    
    // Move added files
    for(LWDKManifestFile *file in addedFiles) {
        NSString *syncPath = [temporaryDirectory stringByAppendingPathComponent:file.fileName];
        NSString *storedPath = [dataPath stringByAppendingPathComponent:file.fileName];
        NSString *storedDirectory = [storedPath stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:storedDirectory withIntermediateDirectories:YES attributes:nil error:0];
        [[NSFileManager defaultManager] removeItemAtPath:storedPath error:0];
        [[NSFileManager defaultManager] moveItemAtPath:syncPath toPath:storedPath error:0];
    }
    
    // Move updated files
    for(LWDKManifestFile *file in modifiedFiles) {
        NSString *syncPath = [temporaryDirectory stringByAppendingPathComponent:file.fileName];
        NSString *storedPath = [dataPath stringByAppendingPathComponent:file.fileName];
        [[NSFileManager defaultManager] removeItemAtPath:storedPath error:0];
        [[NSFileManager defaultManager] moveItemAtPath:syncPath toPath:storedPath error:0];
    }
    
    // Move manifest
    [[NSFileManager defaultManager] moveItemAtPath:syncManifestPath toPath:[self storedManifestPath] error:0];
    
    // Delete removed files
    for(LWDKManifestFile *file in removedFiles) {
        NSString *storedPath = [dataPath stringByAppendingPathComponent:file.fileName];
        [[NSFileManager defaultManager] removeItemAtPath:storedPath error:nil];
    }
    
    [self removeTemporaryDirectory];
    
    [delegate syncSessionCommittedFiles];
}

- (BOOL)allExpectedFilesArePresent
{
    NSString *temporaryDirectory = [self temporaryDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[temporaryDirectory stringByAppendingPathComponent:@"manifest.plist"]]) {
        return NO;
    }
    
    for(LWDKManifestFile *file in addedFiles) {
        if(![[NSFileManager defaultManager] fileExistsAtPath:[temporaryDirectory stringByAppendingPathComponent:file.fileName]]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark Callbacks
- (void)download:(ELDownload *)theDownload downloadedData:(NSData *)data
{
    if([downloadURL isEqualToString:[remoteManifestURL absoluteString]]) {
        [self writeData:data toContentPath:@"manifest.plist"];
        
        LWDKManifest *syncManifest = [LWDKManifest manifestWithPListData:data];
        [self prepareDeltasWithSyncManifest:syncManifest];
        [self buildDownloadList];
        
        [self downloadNextFile];
    } else {
        LWDKManifestFile *currentFile = [downloadList objectAtIndex:0];
        [self writeData:data toContentPath:currentFile.fileName];
        
        [downloadList removeObjectAtIndex:0];
        [self downloadNextFile];
    }
}

- (void)downloadFailed:(ELDownload *)theDownload
{
    NSString *theDownloadURL = [downloadURL copy];
    
    [self cancelSyncSession];
    [delegate syncSessionFailedToDownloadFile:theDownloadURL];
    
    [theDownloadURL release];
}

@end
