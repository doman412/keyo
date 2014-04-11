//
//  SpotifyVC.m
//  keyo
//
//  Created by User on 3/3/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "SpotifyVC.h"
#import "Theme.h"
#import "DejalActivityView.h"
#import "UIImage+Size.h"


@interface SpotifyVC ()

@end

@implementation SpotifyVC

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSLog(@"spotify nav controller: %@", self.navigationController);
//    NSLog(@"spotify parent nav controller: %@", self.parentViewController.navigationController);
    
    // theme the view
    self.tableView.backgroundColor = [Theme wellWhite];
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
    static NSString *CellIdentifier = @"SpotifyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *title = (id)[cell viewWithTag:1];
    UILabel *artist = (id)[cell viewWithTag:2];
    UIProgressView *popularity = (id)[cell viewWithTag:3];
    
    
    NSDictionary *item = [self.data objectAtIndex:indexPath.row];
    
    NSArray *artists = nil;
    NSDictionary *artistObj = nil;
    
    NSDictionary *album = nil;
    
    NSNumber *pop = [item objectForKey:@"popularity"];
    [popularity setProgress:[pop floatValue] animated:NO];
    if([pop floatValue]==0){
        [popularity setProgress:0.01 animated:NO];
        [popularity setProgressTintColor:[UIColor redColor]];
    } else if([pop floatValue]<=0.33){
        [popularity setProgressTintColor:[UIColor redColor]];
    } else if([pop floatValue]<=0.66){
        [popularity setProgressTintColor:[UIColor yellowColor]];
    } else {
        [popularity setProgressTintColor:[UIColor greenColor]];
    }
    
    switch(self.searchBar.selectedScopeButtonIndex){
        case 0: // title
            
            artists = [item objectForKey:@"artists"];
            artistObj = [artists objectAtIndex:0];
            
            album = [item objectForKey:@"album"];
            
            title.text = [item objectForKey:@"name"];
            artist.text = [NSString stringWithFormat:@"%@ (%@)", [artistObj objectForKey:@"name"], [album objectForKey:@"name"]];
            
            break;
        case 1: // Artist
            
            title.text = [item objectForKey:@"name"];
            artist.text = @"";
            
            break;
        case 2: // Album
            
            artists = [item objectForKey:@"artists"];
            artistObj = [artists objectAtIndex:0];
            
            title.text = [item objectForKey:@"name"];
            artist.text = [NSString stringWithFormat:@"  by: %@", [artistObj objectForKey:@"name"]];
            
            break;
    }
    
    
    
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Theme lightBlue];
    //    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    switch(self.searchBar.selectedScopeButtonIndex){
        case 0: { // title
            NSLog(@"did select a track");
            id spotSong = [self.data objectAtIndex:indexPath.row];
            

        
            PFQuery *findSong = [PFQuery queryWithClassName:@"Song"];
            findSong.limit = 1;
            [findSong whereKey:@"url" equalTo:[spotSong objectForKey:@"href"]];
            [findSong findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    if(objects.count>0){ // found the song
                        PFObject *song = [objects objectAtIndex:0];
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
                            }
                        }];
                    } else { // could not find the song, create it then create a queuedsong for it
                        NSArray *artists = [spotSong objectForKey:@"artists"];
                        NSDictionary *artistObj = [artists objectAtIndex:0];
                        
                        
                        PFObject *song = [PFObject objectWithClassName:@"Song"];
                        song[@"owner"] = [PFUser currentUser];
                        song[@"type"] = @"spotify";
                        song[@"title"] = [spotSong objectForKey:@"name"];
                        song[@"artist"] = [artistObj objectForKey:@"name"];
                        song[@"url"] = [spotSong objectForKey:@"href"];
                        song[@"pId"] =  [[[spotSong objectForKey:@"href"] componentsSeparatedByString:@":"] objectAtIndex:2];
                        
                        [song saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                                                message:@"Are you sure you want to add this song to the queue?"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"No"
                                                                      otherButtonTitles:@"Yes", nil];
                                
                                [alert show];
                                self.selectedSong = song;
                            } else {
                                NSLog(@"failed to save new song");
                            }
                        }];
                    }
                }
            }];
            
            
            
            
            
            
            
            
            
            
            
            
            break;
        } case 1: { // Artist
            NSLog(@"did select an artist");
            
            vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyArtistVC"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        } case 2: { // Album
            NSLog(@"did select an album");
            break;
        }
    }
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    
    PFQuery *q = [PFQuery queryWithClassName:@"QueuedSong"];
    [q whereKey:@"song" equalTo:[self.data objectAtIndex:indexPath.row]];
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
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Submission"
                                                                message:@"Are you sure you want to add this song to the queue?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                
                [alert show];
            }
        }
    }];
}
*/
#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){ // yes
        
        PFObject *song = self.selectedSong;
        PFObject *queuedSong = [PFObject objectWithClassName:@"QueuedSong"];
        
        queuedSong[@"song"] = song;
        queuedSong[@"hub"] = self.hub;
        queuedSong[@"addedBy"] = [PFUser currentUser];
        queuedSong[@"points"] = @1;
        queuedSong[@"active"] = @YES;
        
        [queuedSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!succeeded){
                NSLog(@"failed to save queued song");
            }
        }];
        
        //        obj[@"queue"] = self.hub[@"queue"];
        //        obj[@"addedToQueueBy"] = [PFUser currentUser];
        //        obj[@"dateAddedToQueue"] = [NSDate date];
        //        obj[@"points"] = @1;
        
        //        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //            if(succeeded){
        //                [self loadSongs];
        //            }
        //        }];
    }
}

#pragma mark - search bar delegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self.data removeAllObjects];
    [self.tableView reloadData];
//    [self searchBarSearchButtonClicked:searchBar];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
//    self.searchBar.showsScopeBar = YES;
}

//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
////    self.searchBar.showsCancelButton = NO;
////    self.searchBar.showsScopeBar = NO;
////    [self.searchBar resignFirstResponder];
//    [self hideSearchBar];
//}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    self.searchBar.showsCancelButton = NO;
//    self.searchBar.showsScopeBar = NO;
//    [self.searchBar resignFirstResponder];
    [self hideSearchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search spotify for: %@", self.searchBar.text);
    [self hideSearchBar];
    [DejalBezelActivityView activityViewForView:self.view];
    
//    self.searchBar.showsCancelButton = NO;
//    self.searchBar.showsScopeBar = NO;
//    [self.searchBar resignFirstResponder];
    
    
    NSString *baseUrl = @"http://ws.spotify.com/search";
    NSString *apiVersion = @"/1";
    NSString *searchScope = nil;
    switch( searchBar.selectedScopeButtonIndex){
        case 0: // title
            searchScope = @"/track.json";
            break;
        case 1: // Artist
            searchScope = @"/artist.json";
            break;
        case 2: // Album
            searchScope = @"/album.json";
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",baseUrl,apiVersion,searchScope];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
//    [params setObject:@"snippet" forKey:@"part"];
    [params setObject:searchBar.text forKey:@"q"];
//    [params setObject:@"video" forKey:@"type"];
//    [params setObject:@"20" forKey:@"maxResults"];
//    //    [params setObject:@"true" forKey:@"videoSyndicated"];
//    [params setObject:@"AIzaSyDBrE7H_f_7VGa13LLCefYA2uoocG2j0Qg" forKey:@"key"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSArray *arr = nil;
        
        switch( searchBar.selectedScopeButtonIndex){
            case 0: // title
                arr = (id)[responseObject objectForKey:@"tracks"];
                break;
            case 1: // Artist
                arr = (id)[responseObject objectForKey:@"artists"];
                break;
            case 2: // Album
                arr = (id)[responseObject objectForKey:@"albums"];
                break;
        }
        
        self.data = [NSMutableArray arrayWithArray:arr];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0.0f, -(self.tableView.contentInset.top)) animated:YES];
        
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
    
    
    
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
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y-88, self.tableView.frame.size.width, self.tableView.frame.size.height+88);
        
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
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y+88, self.tableView.frame.size.width, self.tableView.frame.size.height-88);
        
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
