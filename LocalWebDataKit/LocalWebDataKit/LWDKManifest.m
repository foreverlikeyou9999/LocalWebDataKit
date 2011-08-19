//
//  LWDKManifest.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKManifest.h"
#import "LWDKManifestFile.h"

@implementation LWDKManifest
@synthesize files;

+ (LWDKManifest *)manifestWithPListData:(NSData *)data
{
    return [[[LWDKManifest alloc] initWithPListData:data] autorelease];
}

- (id)initWithPListData:(NSData *)data
{
    self = [super init];
    
    if(self) {
        NSDictionary *plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:0 errorDescription:0];
        NSArray *plistArray = [plist objectForKey:@"Files"];
        NSMutableArray *mutableFiles = [NSMutableArray array];
        
        for(NSDictionary *entry in plistArray) {
            NSString *fileName = [entry objectForKey:@"FileName"];
            NSDate *modificationDate = [entry objectForKey:@"ModifiedDate"];
            [mutableFiles addObject:[LWDKManifestFile manifestFileWithFileName:fileName modificationDate:modificationDate]];
        }
        
        files = [[NSArray arrayWithArray:mutableFiles] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [files release];
    
    [super dealloc];
}
@end
