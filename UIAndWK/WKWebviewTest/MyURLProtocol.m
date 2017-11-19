//
//  MyURLProtocol.m
//  WKWebviewTest
//
//  Created by Zhihui Tian on 2017/11/16.
//  Copyright © 2017年 mirroon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyURLProtocol.h"

#import <UIKit/UIKit.h>

static NSString* const FilteredKey = @"FilteredKey";

@implementation MyURLProtocol

//+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
//    NSString* extension = request.URL.pathExtension;
////    if ([extension isEqualToString:@"js"] || [extension isEqualToString:@""]){
//    NSLog(@"url = %@", request.HTTPBody);
//    if ([extension isEqualToString:@"js"]){
//        if ([NSURLProtocol propertyForKey:FilteredKey inRequest:request]) {
//            return false;
//        } else {
//            NSLog(@"url = %@", request.URL.absoluteString);
//            return true;
//        }
//    }
//    return false;
//}

//+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
//    return request;
//}

//- (void)startLoading {
//    NSLog(@"startLoading");
//    NSMutableURLRequest* request = self.request.mutableCopy;
////    NSData *data = [@"console.log(11111)" dataUsingEncoding:NSUTF8StringEncoding];
////    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"text/javascript" expectedContentLength:data.length textEncodingName:nil];
////
////    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
////    [self.client URLProtocol:self didLoadData:data];
////    [self.client URLProtocolDidFinishLoading:self];
//    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:request];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
//    [task resume];
//}
//
//- (void)stopLoading {
//}

//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"NSURLCacheStorageNotAllowed");
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}

@end
