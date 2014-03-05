//
//  SpotifyVC.m
//  keyo
//
//  Created by User on 3/3/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "SpotifyVC.h"
#import "Theme.h"

@interface SpotifyVC ()

@end

@implementation SpotifyVC

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSLog(@"spotify nav controller: %@", self.navigationController);
//    NSLog(@"spotify parent nav controller: %@", self.parentViewController.navigationController);
    
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
        case 0: // title
            NSLog(@"did select a track");
            break;
        case 1: // Artist
            NSLog(@"did select an artist");
            
            vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyArtistVC"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        case 2: // Album
            NSLog(@"did select an album");
            break;
    }
}

#pragma mark - search bar delegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
//    [self.data removeAllObjects];
//    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
    self.searchBar.showsScopeBar = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search spotify for: %@", self.searchBar.text);
    
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar resignFirstResponder];
    
    
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
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
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
