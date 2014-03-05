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
#import "Waiting.h"
#import "NSString+ContainsAddition.h"

@interface YouTubeVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) PFObject *hub;
@property (strong, nonatomic) PFObject *queuedSongToAdd;
@property (strong, nonatomic) PFObject *selectedSong;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
