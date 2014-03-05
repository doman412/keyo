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

@interface HomeVC : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *myHubButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (strong, nonatomic) PFObject *myHub;

+(AVPlayer*)myPlayer;
+(AVPlayer *)myPlayerWithURL:(NSURL*)url;
+(AVPlayer*)newPlayer;
+(AVPlayer *)newPlayerWithURL:(NSURL*)url;

- (IBAction)onAddSite:(id)sender;
- (IBAction)onRefreshSites:(id)sender;
- (IBAction)onOptions:(id)sender;
- (IBAction)onMyHub:(id)sender;

- (void)evalHub;

@end
