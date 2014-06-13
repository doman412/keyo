//
//  PlaylistMediaPickerVC.h
//  Juke
//
//  Created by Derek Arner on 6/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistMediaPickerVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *songs;

- (IBAction)onDone:(id)sender;

@end
