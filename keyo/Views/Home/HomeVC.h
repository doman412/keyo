//
//  HomeVC.h
//  keyo
//
//  Created by Derek Arner on 12/26/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

#import "Hub.h"
#import "Song.h"
#import "QueuedSong.h"

@class Reachability;

@interface HomeVC : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *myHubButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (strong, nonatomic) Hub *myHub;
@property (strong, nonatomic) Reachability *reach;


// toolbar
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;


// alerts
@property (strong, nonatomic) UIAlertView *passcodeAlert;


+(AVPlayer*)myPlayer;
+(AVPlayer *)myPlayerWithURL:(NSURL*)url;
+(AVPlayer*)newPlayer;
+(AVPlayer *)newPlayerWithURL:(NSURL*)url;

- (IBAction)onRefreshSites:(id)sender;
- (IBAction)onOptions:(id)sender;
- (IBAction)onMyHub:(id)sender;

- (void)evalHub;

// filter properties
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterBarY;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterBar;
// methods for the filter
- (IBAction)onFilterButtonPressed:(id)sender;
- (void)hideFilterBar;
- (void)showFilterBar;
- (IBAction)onFilterSelect:(id)sender;


@end
