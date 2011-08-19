//
//  LWDKSyncSession.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELDownload.h"
#import "LWDKManifest.h"

@interface LWDKSyncSession : NSObject
{
    NSString *dataPath;
    NSURL *remoteManifestURL;
    id delegate;
    
    NSString *downloadURL;
    ELDownload *download;
    
    NSArray *addedFiles;
    NSArray *modifiedFiles;
    NSArray *removedFiles;
    
    NSMutableArray *downloadList;
}

+ (LWDKSyncSession *)syncSessionWithDataPath:(NSString *)theDataPath
                           remoteManifestURL:(NSURL *)theRemoteManifestURL
                                    delegate:(id)theDelegate;
- (id)initWithDataPath:(NSString *)theDataPath
     remoteManifestURL:(NSURL *)theRemoteManifestURL
              delegate:(id)theDelegate;

- (void)cancelSyncSession;
@end

@protocol LWDKSyncSessionDelegate
- (void)syncSessionCommittedFiles:(NSArray *)fileNames;
- (void)syncSessionInconsistentStateFailure;
- (void)syncSessionFailedToDownloadFile:(NSString *)file;
@end
