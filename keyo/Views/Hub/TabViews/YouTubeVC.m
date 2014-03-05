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

@interface YouTubeVC (){
    BOOL findSongUrl;
}

@end

@implementation YouTubeVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    UIImage *im = [[UIImage imageNamed:@"spotify-logo-vertical-black-rgb_32"] tintedImageWithColor:[Theme backgroundBlue]];
//    UIImage *sel = [[UIImage imageNamed:@"spotify-logo-vertical-black-rgb_32"] tintedImageWithColor:[Theme fontWhite]];
//    
//    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:im selectedImage:sel];
    
//    tbi.image = [tbi.image imageWithColor:[Theme backgroundBlue]];
    
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
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Theme lightBlue];
    //    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    
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
    
    
    [Waiting show:self];
    
    
    
    PFQuery *q = [PFQuery queryWithClassName:@"Song"];
    [q whereKey:@"pid" equalTo:videoId];
    [q whereKey:@"type" equalTo:@"yt"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if(objects.count>0){
                NSLog(@"found song for yt id: %@",videoId);
                findSongUrl = NO;
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
                    } else {
                        NSLog(@"error counting queued songs: %@",error);
                        [Waiting hide];
                    }
                }];
                
            } else {
                NSLog(@"failed to find song for yt id: %@",videoId);
                
                PFObject *song = [PFObject objectWithClassName:@"Song"];
                song[@"owner"] = [PFUser currentUser];
                song[@"title"] = title;
                song[@"artist"] = artist;
                song[@"type"] = @"yt";
                song[@"pid"] = videoId;
                
                
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
                        findSongUrl = YES;
                        
                        
                    } else {
                        NSLog(@"error saving youtube song: %@", error);
                        [Waiting hide];
                    }
                }];
            }
        } else {
            [Waiting hide];
            NSLog(@"error trying to find song: %@",videoId);
        }
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){ // yes
        PFObject *song = self.selectedSong;
        PFObject *queuedSong = [PFObject objectWithClassName:@"QueuedSong"];
        self.queuedSongToAdd = queuedSong;
        queuedSong[@"song"] = song;
        queuedSong[@"hub"] = self.hub;
        queuedSong[@"addedBy"] = [PFUser currentUser];
        queuedSong[@"points"] = @1;
        queuedSong[@"up"] = @1;
        queuedSong[@"down"] = @0;
        queuedSong[@"active"] = @YES;
        
//        [queuedSong saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if(!succeeded){
//                NSLog(@"failed to save queued song: %@", error);
//            }
//        }];
        if(findSongUrl){
            self.webView.delegate = self;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.ssyoutube.com/watch?v=%@",song[@"pid"]]]]];
        } else {
            [self.queuedSongToAdd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!succeeded){
                    NSLog(@"failed to save queued song");
                }
                [Waiting hide];
            }];
        }
        
    }
}

#pragma mark - search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search for: %@", searchBar.text);
    
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
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

#pragma mark - web view delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"web view did finish load");
    JSContext *ctx = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"console"][@"log"] = ^(JSValue *msg) {
        NSString *str = [NSString stringWithFormat:@"%@",msg];
        NSLog(@"**JS** : %@", msg);
        if([str containsString:@"http"]){
            NSLog(@"found url: %@",str);
            self.selectedSong[@"url"] = str;
            self.queuedSongToAdd[@"song"] = self.selectedSong;
            [self.queuedSongToAdd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!succeeded){
                    NSLog(@"failed to save queued song");
                }
                [Waiting hide];
            }];
        }
        
    };
    // $("a[title='video format: 360p']").attr('href');
    [ctx evaluateScript:@"console.log($(\"a[title='video format: 360p']\").attr('href'))"];
    //    [ctx evaluateScript:@"YoutubeVideo('_ovdm2yX4MA', function(video){ \
    //     console.log(video.title); \
    //     var webm = video.getSource(\"video/webm\", \"medium\"); \
    //     console.log(\"WebM: \" + webm.url); \
    //     var mp4 = video.getSource(\"video/mp4\", \"medium\"); \
    //     console.log(\"MP4: \" + mp4.url); \
    //     $(\"<video controls='controls'/>\").attr(\"src\", webm.url).appendTo(\"body\"); \
    //     })"];
    
    /*
     YoutubeVideo('_ovdm2yX4MA', function(video){
     console.log(video.title);
     var webm = video.getSource("video/webm", "medium");
     console.log("WebM: " + webm.url);
     var mp4 = video.getSource("video/mp4", "medium");
     console.log("MP4: " + mp4.url);
     
     $("<video controls='controls'/>").attr("src", webm.url).appendTo("body");
     });
     */
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
