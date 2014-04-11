//
//  YouTubeVC.h
//  keyo
//
//  Created by User on 2/23/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSString+ContainsAddition.h"

@interface YouTubeVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) PFObject *hub;
@property (strong, nonatomic) PFObject *queuedSongToAdd;
@property (strong, nonatomic) PFObject *selectedSong;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onSearch:(id)sender;

-(void)hideSearchBar;
-(void)showSearchBar;

@end
