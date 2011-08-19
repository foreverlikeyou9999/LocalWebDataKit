//
//  ELDownload.m
//  EventBoard
//
//  Created by Donald Hays on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ELDownload.h"

@implementation ELDownload

#pragma mark -
#pragma mark Lifecycle

+ (ELDownload *)downloadWithURL:(NSString *)url delegate:(id)delegate
{
    return [[[ELDownload alloc] initWithURL:url delegate:delegate] autorelease];
}

- (id)initWithURL:(NSString *)url delegate:(id)theDelegate
{
    self = [super init];
    if(self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
        
        delegate = theDelegate;
        
        receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (id)init
{
    return [self initWithURL:nil delegate:nil];
}

- (void)dealloc
{
    [receivedData release];
    receivedData = nil;
    
    [connection release];
    connection = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark API

- (void)cancel
{
    [connection cancel];
    [connection release];
    connection = nil;
}

#pragma mark -
#pragma mark Delegate Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [connection release];
    connection = nil;
    
    [delegate downloadFailed:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [connection release];
    connection = nil;
    
    [delegate download:self downloadedData:[NSData dataWithData:receivedData]];
}

@end
