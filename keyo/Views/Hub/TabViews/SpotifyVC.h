//
//  SpotifyVC.h
//  keyo
//
//  Created by User on 3/3/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <Parse/Parse.h>

@interface SpotifyVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PFObject *selectedSong;
@property (strong, nonatomic) PFObject *hub;
@property (strong,nonatomic) NSMutableArray *data;


- (IBAction)onSearch:(id)sender;

-(void)hideSearchBar;
-(void)showSearchBar;


@end
