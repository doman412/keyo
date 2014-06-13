//
//  YouTubeVC.m
//  keyo
//
//  Created by User on 2/23/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "YouTubeVC.h"

#import "AFNetworking.h"
#import "Theme.h"
#import "UIImage+Color.h"
#import "DejalActivityView.h"

#import "Hub.h"
#import "Song.h"
#import "QueuedSong.h"

@interface YouTubeVC ()

@end

@implementation YouTubeVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // theme the vc
    self.tableView.backgroundColor = [Theme wellWhite];
    self.searchBar.backgroundColor = [Theme backgroundBlue];
    self.searchBar.barTintColor = [Theme backgroundBlue];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.parentViewController.navigationItem.title = self.navigationItem.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"YTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *label = (id)[cell viewWithTag:1];
//    label.text =
    id item = [self.data objectAtIndex:indexPath.row];
    id snippet = [item objectForKey:@"snippet"];
    
    NSString *title = [snippet objectForKey:@"title"];
    
    label.text = title;
    
    NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
    NSDictionary *defaultImg = [thumbnails objectForKey:@"high"];
    NSString *imgURL = [defaultImg objectForKey:@"url"];
    
    UIImageView *image = (id)[cell viewWithTag:2];
    
    if([self.images objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
        image.image = [self.images objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    } else {
        image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
        [self.images setObject:image.image forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [Theme lightBlue];
//    //    bgColorView.layer.cornerRadius = 7;
//    bgColorView.layer.masksToBounds = YES;
//    [cell setSelectedBackgroundView:bgColorView];
    
    // theme the cell
    cell.selectedBackgroundView.backgroundColor = [Theme lightBlue];
    cell.backgroundColor = [Theme wellWhite];
    label.textColor = [Theme fontBlack];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.data objectAtIndex:indexPath.row];
    id snippet = [item objectForKey:@"snippet"];
    
    NSString *title = [snippet objectForKey:@"title"];
    NSString *artist = [snippet objectForKey:@"channelTitle"];
    NSDictionary *ID = [item objectForKey:@"id"];
    NSString *videoId = [ID objectForKey:@"videoId"];
    NSString *description = [snippet objectForKey:@"description"];
    
    NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
    NSDictionary *defaultImg = [thumbnails objectForKey:@"high"];
    NSString *imgURL = [defaultImg objectForKey:@"url"];
    
    
    
    
    
    PFQuery *q = [PFQuery queryWithClassName:@"Song"];
    [q whereKey:@"pId" equalTo:videoId];
    [q whereKey:@"type" equalTo:@"yt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if(objects.count>0){
                NSLog(@"found song for yt id: %@",videoId);
                Song *song = [objects objectAtIndex:0];
                
                PFQuery *q = [PFQuery queryWithClassName:@"QueuedSong"];
                [q whereKey:@"hub" equalTo:self.hub];
                [q whereKey:@"song" equalTo:song];
                [q whereKey:@"active" equalTo:@YES];
                
                [q countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if(!error){
                        if(number>0) { // song exists in the queue
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                            message:@"That song is already in the queue."
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles: nil];
                            [alert show];
                            self.selectedSong = nil;
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                                            message:@"Are you sure you want to add this song to the queue?"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"No"
                                                                  otherButtonTitles:@"Yes", nil];
                            
                            [alert show];
                            self.selectedSong = song;
                        }
                    } else {
                        NSLog(@"error counting queued songs: %@",error);
                    }
                }];
                
            } else {
                NSLog(@"failed to find song for yt id: %@",videoId);
                
                Song *song = [Song object];
                song.owner = [PFUser currentUser];
                song.title = title;
                song.artist = artist;
                song.type = @"yt";
                song.pId = videoId;
                song.thumbnail = imgURL;
                song.description = description;
                
                
                [song saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        NSLog(@"saved yt song: %@", videoId);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                                        message:@"Are you sure you want to add this song to the queue?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"No"
                                                              otherButtonTitles:@"Yes", nil];
                        
                        [alert show];
                        self.selectedSong = song;
//                        findSongUrl = YES;
                        
                        
                    } else {
                        NSLog(@"error saving youtube song: %@", error);
                    }
                }];
            }
        } else {
            NSLog(@"error trying to find song: %@",videoId);
        }
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){ // yes
        Song *song = self.selectedSong;
        QueuedSong *queuedSong = [QueuedSong object];
        self.queuedSongToAdd = queuedSong;
        queuedSong.song = song;
        queuedSong.hub = self.hub;
        queuedSong.addedBy = [PFUser currentUser];
        queuedSong.ups = @[[PFUser currentUser].objectId];
        queuedSong.downs = @[];
        queuedSong.active = YES;
        
        [self.queuedSongToAdd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!succeeded){
                NSLog(@"failed to save queued song");
            }
        }];
        
    }
}

#pragma mark - search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    for (UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            NSLog(@"this is button type");
            
            [(UIButton *)subView setTintColor:[Theme fontBlack]];
//            [(UIButton *)subView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search for: %@", searchBar.text);
    [self hideSearchBar];
    [DejalBezelActivityView activityViewForView:self.navigationController.view withLabel:@"Searching..."];
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
    // url: https://www.googleapis.com/youtube/v3/search
    // key: AIzaSyDGSgm6heFh6Wz7K2Kum6N5P4qm4G4eTcw
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"snippet" forKey:@"part"];
    [params setObject:searchBar.text forKey:@"q"];
    [params setObject:@"video" forKey:@"type"];
    [params setObject:@"20" forKey:@"maxResults"];
//    [params setObject:@"true" forKey:@"videoSyndicated"];
    [params setObject:@"AIzaSyDBrE7H_f_7VGa13LLCefYA2uoocG2j0Qg" forKey:@"key"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.googleapis.com/youtube/v3/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", [responseObject objectForKey:@"items"]);
        
        NSArray *arr = (id)[responseObject objectForKey:@"items"];
        
        self.images = [[NSMutableDictionary alloc] init];
        self.data = [NSMutableArray arrayWithArray:arr];
        [self.tableView reloadData];
        
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    searchBar.showsCancelButton = NO;
//    [searchBar resignFirstResponder];
    [self hideSearchBar];
}

- (IBAction)onSearch:(id)sender
{
    if(self.searchBar.hidden){
        [self showSearchBar];
    } else {
        [self hideSearchBar];
    }
}

- (void)hideSearchBar
{
    
    
    if(self.searchBar.hidden==NO){
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y-44, self.tableView.frame.size.width, self.tableView.frame.size.height+44);
        
        [self.searchBar resignFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.frame = newFrameSize;
            self.searchBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.searchBar.hidden = YES;
        }];
    }
    
}

- (void)showSearchBar
{
    
    if(self.searchBar.hidden==YES){
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y+44, self.tableView.frame.size.width, self.tableView.frame.size.height-44);
        
        self.searchBar.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.frame = newFrameSize;
            self.searchBar.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.searchBar becomeFirstResponder];
        }];
    }
    
    
}









@end
