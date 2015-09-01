//
//  ViewController.h
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)DownloadButtonPressed:(id)sender;
- (IBAction)ActionButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressBar;

@end

