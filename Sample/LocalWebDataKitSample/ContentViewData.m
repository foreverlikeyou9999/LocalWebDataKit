//
//  ContentViewData.m
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentViewData.h"
#import "LWDKLocalWebDataSyncManager.h"

@interface ContentViewData (Private)
- (NSString *)pathToContent:(NSString *)content;
- (void)loadImage;
- (void)loadText;
@end

@implementation ContentViewData

@synthesize image;
@synthesize text;

- (id)init
{
    self = [super init];
    if (self) {
        [self loadImage];
        [self loadText];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(filesSynced:)
                                                     name:LWDKLocalWebDataSyncManagerFinishedSyncNotification
                                                   object:[LWDKLocalWebDataSyncManager sharedLocalWebDataSyncManager]];
    }
    
    return self;
}

- (void)dealloc
{
    [image release];
    [text release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LWDKLocalWebDataSyncManagerFinishedSyncNotification
                                                  object:[LWDKLocalWebDataSyncManager sharedLocalWebDataSyncManager]];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Notifications
- (void)filesSynced:(NSNotification *)notification
{
    NSArray *touchedFiles = [[notification userInfo] objectForKey:LWDKTouchedFilesKey];
    
    if([touchedFiles containsObject:@"Images/icon.png"]) {
        [self loadImage];
    }
    
    if([touchedFiles containsObject:@"text.txt"]) {
        [self loadText];
    }
}

#pragma mark -
#pragma mark Private
- (NSString *)pathToContent:(NSString *)content
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *contentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Content"];
    return [contentPath stringByAppendingPathComponent:content];
}

- (void)loadImage
{
    [self willChangeValueForKey:@"image"];
    
    [image release];
    image = nil;
    
    NSString *imagePath = [self pathToContent:@"Images/icon.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        image = [[UIImage imageWithContentsOfFile:imagePath] retain];
    }
    
    [self didChangeValueForKey:@"image"];
}

- (void)loadText
{
    [self willChangeValueForKey:@"text"];
    
    [text release];
    text = nil;
    
    NSString *textPath = [self pathToContent:@"text.txt"];
    if([[NSFileManager defaultManager] fileExistsAtPath:textPath]) {
        text = [[NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:0] copy];
    }
    
    [self didChangeValueForKey:@"text"];
}

@end
