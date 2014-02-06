//
//  PlayerVC.m
//  keyo
//
//  Created by User on 1/26/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "PlayerVC.h"

@interface PlayerVC ()

@end

@implementation PlayerVC

@synthesize hub,trashConfirm,trashButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    [self.player beginGeneratingPlaybackNotifications];
    
    if(self.player.currentPlaybackRate==0.0){
        [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
    } else {
        MPMediaItem *item = self.player.nowPlayingItem;
        self.songTitleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
        self.artistTitleLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
    }
    
    
    self.title = self.hub[@"title"];
    
    
    
    self.trashConfirm = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this hub?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.barTimer fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadSongsAndNext:NO];
    
    [self.barTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.barTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSongsAndNext:(BOOL)next
{
    NSLog(@"load songs for player");
    self.queue = [PFQuery queryWithClassName:@"QueuedSong"];
    
    //    [self.songQuery whereKey:@"hub" equalTo:self.hub];
    //    [self.songQuery whereKey:@"queue" equalTo:self.hub[@"queue"]];
    [self.queue whereKey:@"hub" equalTo:self.hub];
    [self.queue whereKey:@"active" equalTo:@YES];
    [self.queue orderByDescending:@"points"];
    [self.queue addAscendingOrder:@"createdAt"];
    [self.queue includeKey:@"song"];
    
    [self.queue findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.data = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            if(next){
                
                if(self.data.count > 0){
                    PFObject *first = [self.data firstObject];
                    PFObject *song = first[@"song"];
                    
                    NSNumber *blah = [song objectForKey:@"pid"];
                    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: [NSString stringWithFormat:@"%@",blah] forProperty:MPMediaItemPropertyPersistentID];
                    
                    MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] init];
                    [mediaQuery addFilterPredicate:predicate];
                    
                    [self.player setQueueWithQuery:mediaQuery];
                    [self.player play];
                    
                    [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
                    [self.barTimer fire];
                    
                    [self.data removeObject:first];
                    
                    
                    self.songTitleLabel.text = song[@"title"];
                    self.artistTitleLabel.text = song[@"artist"];
                    
                    
                    first[@"active"] = @NO;
                    [first saveInBackground];
                    
                    [self.tableView reloadData];
                }
                
            }
            
        } else {
            NSLog(@"failed to find songs for player");
        }
    }];
}

- (IBAction)onTrashHub:(id)sender {
    [self.trashConfirm show];
}

- (IBAction)onAddSongs:(id)sender {
    MPMediaPickerController *m = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    m.delegate = self;
    m.allowsPickingMultipleItems = YES;
    
    
    [self presentViewController:m animated:YES completion:nil];
}

- (IBAction)onRefresh:(id)sender {
    [self loadSongsAndNext:NO];
}

- (IBAction)onSkip:(id)sender {
    [self loadSongsAndNext:YES];
}

- (IBAction)onPlayToggle:(id)sender {
    if(self.player.currentPlaybackRate==0.0){ // not playing
        
        if(self.player.nowPlayingItem){ // have a paused item, play it
            [self.player play];
            [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
            [self.barTimer fire];
        } else { // dont have an item to play get next one and play it
            [self loadSongsAndNext:YES];
        }
    } else if(self.player.currentPlaybackRate==1.0) { // playing
        [self.barTimer invalidate];
        [self.player pause];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView==self.trashConfirm){
        if(buttonIndex==1){ // pressed yes
            NSLog(@"trash the hub");
            [self.hub deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"failed to delete hub: %@",error);
                }
            }];
            
            
        }
    }
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(MPMediaItem *i in mediaItemCollection.items){
        PFObject *o = [PFObject objectWithClassName:@"Song"];
        
        o[@"hub"] = self.hub;
        o[@"owner"] = [PFUser currentUser];
        o[@"title"] = [i valueForProperty:MPMediaItemPropertyTitle];
        o[@"artist"] = [i valueForProperty:MPMediaItemPropertyArtist];
        o[@"pid"] = [i valueForProperty:MPMediaItemPropertyPersistentID];
        o[@"url"] = [[i valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        
        
        [array addObject:o];
    }
    [PFObject saveAllInBackground:array block:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"failed to save songs after hub");
        }
    }];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"media picker: did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}







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
    static NSString *CellIdentifier = @"playerCell";
    UITableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *queuedSong = [self.data objectAtIndex:indexPath.row];
    
    PFObject *obj = queuedSong[@"song"];
    
    UILabel *points = (id)[cell viewWithTag:1];
    UILabel *title  = (id)[cell viewWithTag:2];
    UILabel *artist = (id)[cell viewWithTag:3];
    

    title.text = obj[@"title"];
    artist.text = obj[@"artist"];
    points.text = [NSString stringWithFormat:@"%li", (long)[queuedSong[@"points"] integerValue]];
    
    return cell;
}


- (void)onPlaybackStateChanged:(NSNotification*)noti
{
    int state = [[noti.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"] intValue];
    if(state == MPMusicPlaybackStateStopped){
        NSLog(@"playback stopped");
        [self loadSongsAndNext:YES];
    }
    
}
- (void)onNowPlayingItemChanged:(NSNotification*)noti
{
//    NSLog(@"now playing item changed: %@",noti);
}

- (void)onTimer:(NSTimer*)timer
{
    MPMediaItem *item = self.player.nowPlayingItem;
    
    NSNumber *dur = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSLog(@"timer: %f",(self.player.currentPlaybackTime/[dur doubleValue]));
    
    [self.progressBar setProgress:(self.player.currentPlaybackTime/[dur doubleValue]) animated:YES];
}










@end
