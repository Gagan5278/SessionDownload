//
//  FileDownloadSupport.h
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloadSupport : NSObject
@property (nonatomic, strong)NSString *fileNameString;
@property (nonatomic, strong) NSString *downloadURLString;
@property (nonatomic, strong) NSURLSessionDownloadTask *fileDownloadtask;
@property (nonatomic, strong) NSMutableData *taskResumeData;
@property (nonatomic, strong) NSURL *downloadedPath;
@property double downloadProgress;
@property BOOL isDownloading;
@property BOOL isDownloadCOmpleted;
@property unsigned long taskIdentifier;
-(id)initWithFileName:(NSString*)fileName andDownloadResourcePath :(NSString*)resourceURL;
@end
