//
//  ContentViewData.m
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentViewData.h"

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
    }
    
    return self;
}

- (void)dealloc
{
    [image release];
    [text release];
    
    [super dealloc];
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
