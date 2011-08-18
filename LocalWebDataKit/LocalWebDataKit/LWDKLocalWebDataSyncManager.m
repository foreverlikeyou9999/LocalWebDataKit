//
//  LWDKLocalWebDataSyncManager.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKLocalWebDataSyncManager.h"

@interface LWDKLocalWebDataSyncManager (Private)
@property (nonatomic, copy) NSString *seedDataPath;
@property (nonatomic, copy) NSString *storedDataPath;
@property (nonatomic, copy) NSURL *remoteManifestURL;
@property (nonatomic) NSTimeInterval refreshInterval;

- (NSString *)storedManifestPath;
- (BOOL)manifestExistsAtStoredDataPath;
- (void)copySeedData;
- (void)beginSyncSession;

- (void)clearRefreshTimer;
- (void)setRefreshTimer;
@end

@implementation LWDKLocalWebDataSyncManager

+ (LWDKLocalWebDataSyncManager *)sharedLocalWebDataSyncManager
{
    static LWDKLocalWebDataSyncManager *sharedLocalWebDataSyncManagerInstance = nil;
    
    if(!sharedLocalWebDataSyncManagerInstance) {
        sharedLocalWebDataSyncManagerInstance = [[LWDKLocalWebDataSyncManager alloc] init];
    }
    
    return sharedLocalWebDataSyncManagerInstance;
}

#pragma mark -
#pragma mark Private Properties
- (NSString *)seedDataPath
{
    return seedDataPath;
}

- (void)setSeetDataPath:(NSString *)theSeedDataPath
{
    if(seedDataPath != theSeedDataPath) {
        [seedDataPath release];
        seedDataPath = [theSeedDataPath copy];
    }
}

- (NSString *)storedDataPath
{
    return storedDataPath;
}

- (void)setStoredDataPath:(NSString *)theStoredDataPath
{
    if(storedDataPath != theStoredDataPath) {
        [storedDataPath release];
        storedDataPath = [theStoredDataPath copy];
    }
}

- (NSURL *)remoteManifestURL
{
    return remoteManifestURL;
}

- (void)setRemoteManifestURL:(NSURL *)theRemoteManifestURL
{
    if(remoteManifestURL != theRemoteManifestURL) {
        [remoteManifestURL release];
        remoteManifestURL = [theRemoteManifestURL copy];
    }
}

- (NSTimeInterval)refreshInterval
{
    return refreshInterval;
}

- (void)setRefreshInterval:(NSTimeInterval)theRefreshInterval
{
    if(refreshInterval != theRefreshInterval) {
        refreshInterval = theRefreshInterval;
    }
}

#pragma mark -
#pragma mark Private API
- (NSString *)storedManifestPath
{
    return [self.storedDataPath stringByAppendingPathComponent:@"manifest.plist"];
}

- (BOOL)manifestExistsAtStoredDataPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self storedManifestPath]];
}

- (void)copySeedData
{
    
}

- (void)beginSyncSession
{
    
}

- (void)clearRefreshTimer
{
    [refreshTimer invalidate];
    refreshTimer = nil;
}

- (void)setRefreshTimer
{
    [self clearRefreshTimer];
    
    if(self.refreshInterval > 0) {
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:self.refreshInterval
                                                        target:self
                                                      selector:@selector(refreshTimerExpired:)
                                                      userInfo:nil
                                                       repeats:YES];
    }
}

#pragma mark -
#pragma mark Public API

- (void)beginSyncingWithSeedDataPath:(NSString *)theSeedDataPath
                      storedDataPath:(NSString *)theStoredDataPath
                   remoteManifestURL:(NSURL *)theRemoteManifestURL
                     refreshInterval:(NSTimeInterval)theRefreshInterval
{
    [self clearRefreshTimer];
    
    self.seedDataPath = theSeedDataPath;
    self.storedDataPath = theStoredDataPath;
    self.remoteManifestURL = theRemoteManifestURL;
    self.refreshInterval = theRefreshInterval;
    
    if(![self manifestExistsAtStoredDataPath]) {
        [self copySeedData];
    }
    
    [self beginSyncSession];
    [self setRefreshTimer];
}

- (void)stopSyncing
{
    [self clearRefreshTimer];
}

#pragma mark -
#pragma mark Callbacks
- (void)refreshTimerExpired:(NSTimer *)timer
{
    [self beginSyncSession];
}

@end
