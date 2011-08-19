//
//  ELDownload.h
//  EventBoard
//
//  Created by Donald Hays on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELDownload : NSObject
{
    NSMutableData *receivedData;
    NSURLConnection *connection;
    id delegate;
}

+ (ELDownload *)downloadWithURL:(NSString *)url delegate:(id)delegate;
- (id)initWithURL:(NSString *)url delegate:(id)delegate;

- (void)cancel;
@end

@protocol ELDownloadDelegate

- (void)download:(ELDownload *)theDownload downloadedData:(NSData *)data;
- (void)downloadFailed:(ELDownload *)theDownload;

@end
