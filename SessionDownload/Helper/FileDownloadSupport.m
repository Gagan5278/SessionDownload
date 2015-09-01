//
//  FileDownloadSupport.m
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import "FileDownloadSupport.h"

@implementation FileDownloadSupport
-(id)initWithFileName:(NSString*)fileName andDownloadResourcePath :(NSString*)resourceURL
{
    if(self==[super init])
    {
        self.fileNameString=fileName;
        self.downloadURLString = resourceURL;
        self.downloadProgress=0.0;
        self.isDownloadCOmpleted=NO;
        self.isDownloading=NO;
        self.taskIdentifier=-1;
        self.downloadedPath=nil;
    }
    return self;
}
@end
