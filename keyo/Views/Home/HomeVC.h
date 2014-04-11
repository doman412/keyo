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

@class Reachability;

@interface HomeVC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *myHubButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (strong, nonatomic) PFObject *myHub;
@property (strong, nonatomic) Reachability *reach;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottom;




+(AVPlayer*)myPlayer;
+(AVPlayer *)myPlayerWithURL:(NSURL*)url;
+(AVPlayer*)newPlayer;
+(AVPlayer *)newPlayerWithURL:(NSURL*)url;

- (IBAction)onAddSite:(id)sender;
- (IBAction)onRefreshSites:(id)sender;
- (IBAction)onOptions:(id)sender;
- (IBAction)onMyHub:(id)sender;

- (void)evalHub;

// filter properties
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterBarY;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterBar;
// methods for the filter
- (IBAction)onFilterButtonPressed:(id)sender;
- (void)hideFilterBar;
- (void)showFilterBar;
- (IBAction)onFilterSelect:(id)sender;


@end
