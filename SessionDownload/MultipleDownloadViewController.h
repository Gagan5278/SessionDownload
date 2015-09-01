//
//  MultipleDownloadViewController.h
//  SessionDownload
//
//  Created by Vishal Mishra, Gagan on 26/08/15.
//  Copyright (c) 2015 Vishal Mishra, Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleDownloadViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *multipleDownloadTableView;
- (IBAction)downloadAllAtOnce:(id)sender;

@end
