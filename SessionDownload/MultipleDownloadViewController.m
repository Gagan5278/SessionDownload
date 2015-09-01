//
//  MultipleDownloadViewController.m
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import "MultipleDownloadViewController.h"
#import "FileDownloadSupport.h"
#define labelTagInCell 10
#define pauseButtonTagInCell 20
#define resumeButtontagInCell 30
#define progresBarTagInCell 40
#define showButtonTagInCell 50
@interface MultipleDownloadViewController ()<NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic, strong)NSURLSession *downloadSession;
@property(nonatomic, strong) NSMutableArray *arrayFileDownload;
@property(nonatomic, strong) NSString *documentDirectoryString;
@end

@implementation MultipleDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeArrayWithURL];
    self.documentDirectoryString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] copy];
    NSURLSessionConfiguration *sessionCOnfiguration =[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"gagan.vishal.mishra"];
    sessionCOnfiguration.HTTPMaximumConnectionsPerHost=self.arrayFileDownload.count;
    self.downloadSession=[ NSURLSession sessionWithConfiguration: sessionCOnfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}

-(void)initializeArrayWithURL
{
    self.arrayFileDownload=[NSMutableArray array];
    FileDownloadSupport *file1 =[[FileDownloadSupport alloc]initWithFileName:@"File1" andDownloadResourcePath:@"https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"];
    FileDownloadSupport *file2 =[[FileDownloadSupport alloc]initWithFileName:@"File2" andDownloadResourcePath:@"http://www.logoair.com/wp-content/uploads/2011/01/logo_guidelines.pdf"];
    FileDownloadSupport *file3 =[[FileDownloadSupport alloc]initWithFileName:@"File3" andDownloadResourcePath:@"https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/NetworkingOverview.pdf"];
    FileDownloadSupport *file4 =[[FileDownloadSupport alloc]initWithFileName:@"File4" andDownloadResourcePath:@"https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/AVFoundationPG.pdf"];
    FileDownloadSupport *file5 =[[FileDownloadSupport alloc]initWithFileName:@"File5" andDownloadResourcePath:@"http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"];
    FileDownloadSupport *file6 =[[FileDownloadSupport alloc]initWithFileName:@"File6" andDownloadResourcePath:@"http://www.nbb.be/DOC/BA/PDF7MB/2010/201000200051_1.PDF"];
    [self.arrayFileDownload addObject:file1];
    [self.arrayFileDownload addObject:file2];
    [self.arrayFileDownload addObject:file3];
    [self.arrayFileDownload addObject:file4];
    [self.arrayFileDownload addObject:file5];
    [self.arrayFileDownload addObject:file6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayFileDownload.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *lableName =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-85, 30)];
        lableName.tag=labelTagInCell;
        FileDownloadSupport *object =(FileDownloadSupport*) [self.arrayFileDownload objectAtIndex:indexPath.row];
        lableName.text=object.fileNameString;
        [cell addSubview:lableName];
        lableName=nil;
        UIProgressView *downloadProgress =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        downloadProgress.frame= CGRectMake(5, 50, [UIScreen mainScreen].bounds.size.width-10, downloadProgress.frame.size.height);
        downloadProgress.tag=progresBarTagInCell;
        [cell addSubview:downloadProgress];
        downloadProgress=nil;
        UIButton *showButton =[UIButton buttonWithType:UIButtonTypeCustom];
        showButton.backgroundColor= [UIColor yellowColor];
        showButton.titleLabel.text=@"Show";
        showButton.hidden=YES;
        showButton.tag=showButtonTagInCell;
        showButton.frame= CGRectMake([UIScreen mainScreen].bounds.size.width-45, 5, 35, 30);
        [showButton addTarget:self action:@selector(ShowPDFFileInDocumentInteractionController:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:showButton];
        showButton=nil;
        UIButton *resumeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        resumeButton.backgroundColor=[UIColor blueColor];
        [resumeButton addTarget:self action:@selector(ResumeOrPauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        resumeButton.userInteractionEnabled=YES;
        cell.userInteractionEnabled=YES;
        resumeButton.tag=resumeButtontagInCell;
        [resumeButton setTitle:@">>" forState:UIControlStateNormal];
        [resumeButton setTitle:@"||" forState:UIControlStateSelected];
        
        resumeButton.frame= CGRectMake([UIScreen mainScreen].bounds.size.width-70, 5, 30, 40);
        [cell addSubview:resumeButton];
        resumeButton=nil;
        UIButton *pauseButton =[UIButton buttonWithType:UIButtonTypeCustom];
        pauseButton.backgroundColor=[UIColor redColor];
        [pauseButton setTitle:@"X" forState:UIControlStateNormal];
        pauseButton.tag=pauseButtonTagInCell;
        pauseButton.frame= CGRectMake([UIScreen mainScreen].bounds.size.width-45, 5, 30, 40);
        [cell addSubview:pauseButton];
        pauseButton=nil;
    }
    return cell;
}

-(void)ResumeOrPauseButtonPressed:(id)sender
{
    if([sender isSelected])
    {
        [sender setSelected:NO];
    }
    else{
        [sender setSelected:YES];
    }
    if( [[sender superview] isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell=(UITableViewCell*) [sender superview];
        NSIndexPath *indexPath= [self.multipleDownloadTableView indexPathForCell:cell];
        FileDownloadSupport *objectFileDownload = [self.arrayFileDownload objectAtIndex:indexPath.row];
        if(!objectFileDownload.isDownloading)
        {
            if(objectFileDownload.taskIdentifier==-1)
            {
                NSURL  *urlObject =[NSURL URLWithString:objectFileDownload.downloadURLString];
                objectFileDownload.fileDownloadtask=[self.downloadSession downloadTaskWithURL:urlObject];
                objectFileDownload.taskIdentifier=objectFileDownload.fileDownloadtask.taskIdentifier;
                [objectFileDownload.fileDownloadtask resume];
            }
            else{
                [objectFileDownload.fileDownloadtask resume];
            }
        }
        else{
            [objectFileDownload.fileDownloadtask suspend];
        }
        objectFileDownload.isDownloading=!objectFileDownload.isDownloading;
    }
}

#pragma -mark DownloadSession Delegates
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if(totalBytesExpectedToWrite==NSURLSessionTransferSizeUnknown)
    {
        NSLog(@"Unknown Transfer size of data");
    }
    else{
        FileDownloadSupport *objectFileDownload =[self.arrayFileDownload objectAtIndex:[self getFileIndexForTaskIdentifier:downloadTask.taskIdentifier]];
        objectFileDownload.downloadProgress=  objectFileDownload.downloadProgress + (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            UITableViewCell *cell =[self.multipleDownloadTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getFileIndexForTaskIdentifier:downloadTask.taskIdentifier] inSection:0]];
            UIProgressView *cellProgressBar =(UIProgressView*)[cell viewWithTag : progresBarTagInCell];
            [cellProgressBar setProgress:objectFileDownload.downloadProgress animated:YES];
        }];
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *fileName=downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *filePathURL=[NSURL fileURLWithPath:[self.documentDirectoryString stringByAppendingPathComponent:fileName]];
    NSError *error=nil;
    if([[NSFileManager defaultManager]fileExistsAtPath:[filePathURL path]])
    {
        [[NSFileManager defaultManager] removeItemAtURL:filePathURL error:&error];
    }
    if( [[NSFileManager defaultManager]copyItemAtURL:location toURL:filePathURL error:&error])
    {
        FileDownloadSupport *objectFileDownload =[self.arrayFileDownload objectAtIndex:[self getFileIndexForTaskIdentifier:downloadTask.taskIdentifier]];
        objectFileDownload.downloadProgress=1.0;
        objectFileDownload.isDownloadCOmpleted=YES;
        objectFileDownload.isDownloading=NO;
        objectFileDownload.downloadedPath=[filePathURL copy];
        [self.arrayFileDownload replaceObjectAtIndex:[self getFileIndexForTaskIdentifier:downloadTask.taskIdentifier] withObject:objectFileDownload];
        UITableViewCell *cell =[self.multipleDownloadTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getFileIndexForTaskIdentifier:downloadTask.taskIdentifier] inSection:0]];
        UIButton *showButton=(UIButton*)[cell viewWithTag:showButtonTagInCell];
        showButton.hidden=NO;
        showButton.userInteractionEnabled=YES;
        showButton.tag=[[self.multipleDownloadTableView indexPathForCell:cell] row];
        UIButton *resumeButton=(UIButton*)[cell viewWithTag:resumeButtontagInCell];
        resumeButton.userInteractionEnabled=NO;
        resumeButton.hidden=YES;
        UIButton *pauseButton=(UIButton*)[cell viewWithTag:pauseButtonTagInCell];
        pauseButton.userInteractionEnabled=NO;
        pauseButton.hidden=YES;
    }else{
        NSLog(@"error is : %@",error.localizedDescription);
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


-(int)getFileIndexForTaskIdentifier:(long)identifier
{
    int indexOfFile = 0;
    for (int i=0; i<self.arrayFileDownload.count ; i++)
    {
        if(i==identifier)
        {
            indexOfFile= i;
            break;
        }
    }
    return indexOfFile;
}

- (IBAction)downloadAllAtOnce:(id)sender {
    for (int i=0; i< self.arrayFileDownload.count;i++)
    {
        FileDownloadSupport *objectFileDownload = [self.arrayFileDownload objectAtIndex:i];
        if(!objectFileDownload.isDownloading)
        {
            if(objectFileDownload.taskIdentifier==-1)
            {
                NSURL  *urlObject =[NSURL URLWithString:objectFileDownload.downloadURLString];
                objectFileDownload.fileDownloadtask=[self.downloadSession downloadTaskWithURL:urlObject];
                objectFileDownload.taskIdentifier=objectFileDownload.fileDownloadtask.taskIdentifier;
                [objectFileDownload.fileDownloadtask resume];
            }
            else{
                [objectFileDownload.fileDownloadtask resume];
            }
        }
        else{
            [objectFileDownload.fileDownloadtask suspend];
        }
        objectFileDownload.isDownloading=!objectFileDownload.isDownloading;
    }
    [self.multipleDownloadTableView reloadData];
}

-(void)ShowPDFFileInDocumentInteractionController:(id)sender
{
    FileDownloadSupport *object =[self.arrayFileDownload objectAtIndex:[sender tag]];
    if([[NSFileManager defaultManager]fileExistsAtPath:[[object downloadedPath] path]])
    {
        UIDocumentInteractionController *documentController =[UIDocumentInteractionController interactionControllerWithURL:[object downloadedPath]];
        documentController.delegate=self;
        [documentController presentPreviewAnimated:YES];
    }
}

#pragma -mark DocumentInteractionCotroller Delegate
-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

@end
