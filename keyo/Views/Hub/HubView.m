//
//  HubView.m
//  keyo
//
//  Created by Derek Arner on 12/27/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "HubView.h"
#import "QueueCell.h"

#import "SongListView.h"
#import "YouTubeVC.h"
#import "SpotifyVC.h"
#import "UIImage+Size.h"
#import "UIImage+Color.h"
#import "Theme.h"

@interface HubView (){
    BOOL queryIsRunning;
}

@end

@implementation HubView

@synthesize data,hub,songQuery;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /* // old way of getting queued songs
    self.songQuery = [PFQuery queryWithClassName:@"QueuedSong"];
//    [self.songQuery whereKey:@"hub" equalTo:self.hub];
//    [self.songQuery whereKey:@"queue" equalTo:self.hub[@"queue"]];
    [self.songQuery whereKey:@"hub" equalTo:self.hub];
    [self.songQuery whereKey:@"active" equalTo:@YES];
    [self.songQuery orderByDescending:@"points"];
    [self.songQuery addAscendingOrder:@"createdAt"];
    [self.songQuery includeKey:@"song"];
    */
    
    // new way to get queued songs, call function
    
    
    
    
    
    self.tableView.backgroundColor = [Theme wellWhite];
    
    self.navigationItem.title = self.hub[@"title"];
    
    self.tabBarItem.title = @"Queue";
//    self.tabBarItem.im
    
    [self.refreshControl addTarget:self action:@selector(onRefreshSongs) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [self loadSongs];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.navigationController setToolbarHidden:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoAddASong"]){
        UITabBarController *tbc = segue.destinationViewController;


        
        
        // song list view
        SongListView *slv = [tbc.viewControllers objectAtIndex:0];
        slv.hub = self.hub;
        UIImage *simage = [UIImage imageNamed:@"musical-512" andSize:CGSizeMake(32, 32)];
//        [simage tintedImageWithColor:[Theme lightBlue]];
        slv.tabBarItem.image = simage;
        slv.tabBarItem.selectedImage = simage;
        
        
        // youtube vc
        YouTubeVC *ytvc = [tbc.viewControllers objectAtIndex:1];
        ytvc.hub = self.hub;
        UIImage *ytimage = [UIImage imageNamed:@"youtube-512" andSize:CGSizeMake(32, 32)];
//        [ytimage imageWithColor:[UIColor redColor]];
        ytvc.tabBarItem.image = ytimage;
        ytvc.tabBarItem.selectedImage = ytimage;
        
        
        // spotify vc
        SpotifyVC *spotvc = [tbc.viewControllers objectAtIndex:2];
        spotvc.hub = self.hub;
        UIImage *spotimage = [UIImage imageNamed:@"spotify-logo-vertical-black-rgb" andSize:CGSizeMake(32, 41)];
//        [spotimage tintedImageWithColor:[Theme lightBlue]];
        spotvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        spotvc.tabBarItem.image = spotimage;
        spotvc.tabBarItem.selectedImage = spotimage;
        
        
        
        
        // set the visibility of these view controllers
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:tbc.viewControllers];
        // must remove in reverse order so that the indexes remain the same
        [vcs removeObjectAtIndex:3]; // remove the soundcloud vc
        [vcs removeObjectAtIndex:2]; // remove spotify vc
        [vcs removeObjectAtIndex:0]; // remove songlist view
        [tbc setViewControllers:vcs]; // set them back
    }
}

-(void)onRefreshSongs
{
    NSLog(@"onRefreshSongs");
    [self loadSongs];
}

-(void)loadSongs
{
//    if(!queryIsRunning){
//        queryIsRunning = YES;
//        [self.songQuery findObjectsInBackgroundWithTarget:self selector:@selector(onSongsLoaded:error:)];
//    }
    [PFCloud callFunctionInBackground:@"getPlaylist" withParameters:@{@"hubId":self.hub.objectId} target:self selector:@selector(onSongsLoaded:error:)];
}

-(void)onSongsLoaded:(NSArray*)objects error:(NSError *)err
{
//    NSLog(@"onSongsLoaded: %@, err: %@",objects,err);
    if(!err){
        self.data = [NSMutableArray arrayWithArray:objects];
        // remove the first object in the queue as its the now playing item
//        [self.data removeObjectAtIndex:0];
        [self.tableView reloadData];
//        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(unsigned long)objects.count];
    } else {
        NSLog(@"failed to get songs");
    }
    if(self.refreshControl.refreshing){
        [self.refreshControl endRefreshing];
    }
    queryIsRunning = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 66.0;
    }
    return 71.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *queuedSong = [self.data objectAtIndex:indexPath.row];
    PFObject *obj = queuedSong[@"song"];
    NSArray *ups = (id)queuedSong[@"ups"];
    NSArray *downs = (id)queuedSong[@"downs"];
    
    
    // now playing cell
    if(indexPath.row==0){
        UITableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:@"NowPlayingCell" forIndexPath:indexPath];
        
        ((UILabel*)[cell viewWithTag:1]).text = obj[@"title"];
        ((UILabel*)[cell viewWithTag:2]).text = obj[@"artist"];
        
        return cell;
    }
    
    
    NSString *CellIdentifier = @"QueueCell";
    QueueCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.tableView = tableView;
    cell.queuedSong = queuedSong;
//    [cell setPoints: [queuedSong[@"score"] integerValue]];
    cell.songTitle.text = obj[@"title"];
    cell.artistName.text = obj[@"artist"];
    
    
    cell.pointsLabel.text = [NSString stringWithFormat:@"%i", (ups.count-downs.count)];
    
    // theme the cell
    cell.backgroundColor = [Theme wellWhite];
    cell.selectedBackgroundView.backgroundColor = [Theme lightBlue];
    cell.songTitle.textColor = [Theme fontBlack];
    cell.artistName.textColor = [Theme fontBlack];
    cell.pointsLabel.textColor = [Theme fontBlack];
    
//    cell.downButton.imageView.image = [cell.downButton.imageView.image imageWithColor:[Theme fontBlack]];
    
//    UIImage *up = [[UIImage imageNamed:@"up-32-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    cell.upButton.imageView.image = up;
//    cell.upButton.adjustsImageWhenHighlighted = NO;
//    cell.upButton.adjustsImageWhenDisabled = NO;
//    UIImage *down = [[UIImage imageNamed:@"down-32-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    cell.downButton.imageView.image = down;
//    cell.downButton.adjustsImageWhenHighlighted = NO;
//    cell.downButton.adjustsImageWhenDisabled = NO;
    
    // check if the user voted on object
    if([ups containsObject:[PFUser currentUser].objectId]){
        // user voted up
//        NSLog(@"user voted up : %@",cell.songTitle.text);

        
        cell.upButton.tintColor = [UIColor greenColor];
        cell.downButton.tintColor = [Theme fontBlack];
        
    } else if([downs containsObject:[PFUser currentUser].objectId]){
        // user voted down
//        NSLog(@"user voted down : %@",cell.songTitle.text);
        
        cell.upButton.tintColor = [Theme fontBlack];
        cell.downButton.tintColor = [UIColor redColor];
        
    } else {
        cell.upButton.tintColor = [Theme fontBlack];
        cell.downButton.tintColor = [Theme fontBlack];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
