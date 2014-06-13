//
//  SoundCloudVC.h
//  Juke
//
//  Created by User on 4/7/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import <DejalActivityView/DejalActivityView.h>
#import "Theme.h"

@class Hub, Song, QueuedSong;

@interface SoundCloudVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) Hub *hub;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)onSearch:(id)sender;

-(void)hideSearchBar;
-(void)showSearchBar;

@end
