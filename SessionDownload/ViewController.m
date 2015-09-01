//
//  ViewController.m
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate>
{
    NSURLSessionDownloadTask *downloadTask;
    double totalProgress;
}
@property(nonatomic,strong)NSURLSession *downloadSession;
@end

@implementation ViewController

- (void)viewDidLoad {
     NSString *downloadPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"downloadPath is: %@",downloadPath);
    [super viewDidLoad];
    totalProgress=0.0;
    NSURLSessionConfiguration *configurationSession =[ NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myBackgroundSession"];
    self.downloadSession =[ NSURLSession sessionWithConfiguration: configurationSession delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [self.downloadProgressBar setProgress:0.0 animated:YES];
}

#pragma -mark DownloadSession Delegate
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *downloadPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileDestinationURL =[NSURL fileURLWithPath:[downloadPath stringByAppendingPathComponent:@"file.pdf"]];
    NSError *error =nil;
    if([[NSFileManager defaultManager]fileExistsAtPath:[fileDestinationURL path]])
    {
        [[NSFileManager defaultManager] replaceItemAtURL:fileDestinationURL withItemAtURL:fileDestinationURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        [self showFileFromPath:fileDestinationURL];
    }
    else{
        if( [[NSFileManager defaultManager]moveItemAtURL:location toURL:fileDestinationURL error:&error])
        {
            [self showFileFromPath:fileDestinationURL];
        }
        else{
            NSLog(@"error in moving file: %@",error.localizedDescription);
        }
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    totalProgress=totalProgress+ (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    [self.downloadProgressBar setProgress:totalProgress animated:YES];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PDFDownloader" message:@"Download is resumed successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    downloadTask=nil;
    [self.downloadProgressBar setProgress:0.0 animated:YES];
    totalProgress=0.0;
    if(error)
    {
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        alertView=nil;
    }
}

-(void)showFileFromPath : (NSURL*)filePath
{
    if([[NSFileManager defaultManager]fileExistsAtPath:[filePath path]])
    {
        UIDocumentInteractionController *documentController =[UIDocumentInteractionController interactionControllerWithURL:filePath];
        documentController.delegate=self;
        [documentController presentPreviewAnimated:YES];
    }
}

#pragma -mark DocumentInteractionCotroller Delegate
-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DownloadButtonPressed:(id)sender {
    
    [self.downloadProgressBar setProgress:0.0 animated:YES];
    totalProgress=0.0;
    NSURL *url =[NSURL URLWithString:@"http://www.nbb.be/DOC/BA/PDF7MB/2010/201000200051_1.PDF"];
    downloadTask =[self.downloadSession downloadTaskWithURL:url];
    [downloadTask resume];
}

- (IBAction)ActionButtonPressed:(id)sender {
    if(downloadTask)
    {
        switch ([sender tag]) {
            case 10:
                [downloadTask suspend];
                break;
            case 20:
                [downloadTask resume];
                break;
            case 30:
                [downloadTask cancel];
                break;
            default:
                break;
        }
    }
}
@end
