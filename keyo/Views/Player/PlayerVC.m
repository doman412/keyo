//
//  PlayerVC.m
//  keyo
//
//  Created by User on 1/26/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "PlayerVC.h"
#import "HCYoutubeParser.h"
#import "HomeVC.h"


@interface PlayerVC ()

@end

@implementation PlayerVC

const NSInteger Native = 0;
const NSInteger YouTube = 1;

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
    
    self.playerType = Native;
    
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    [self.player beginGeneratingPlaybackNotifications];
    
    self.ytPlayer = [HomeVC myPlayer];
//    NSLog(@"player layer: %@", self.ytPlayer.)
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.ytPlayer];
    [layer setPlayer:nil];
    
    
    [AVAudioSession sharedInstance];
    
    NSError *myErr;
    
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    if(self.player.currentPlaybackRate==0.0){
        [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
    } else {
        MPMediaItem *item = self.player.nowPlayingItem;
        self.songTitleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
        self.artistTitleLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
    }
    
    if(self.player.nowPlayingItem){
        MPMediaItem *item = self.player.nowPlayingItem;
        self.songTitleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
        self.artistTitleLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
    }
    
    self.title = self.hub[@"title"];
    
    
    
    self.trashConfirm = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this hub?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [self.barTimer invalidate];
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.barTimer fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onYoutubePlaybackStateChanged:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

//    [self.ytPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSongsAndNext:NO];
    
    [self.barTimer invalidate];
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.ytPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.ytPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"yt player is ready to play");
        } else if (self.ytPlayer.status == AVPlayerStatusFailed) {
            // something went wrong. player.error should contain some information
            NSLog(@"yt player has failed: %@", self.ytPlayer.error);
        }
    }
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
                    
                    if([song[@"type"] isEqualToString:@"yt"]){ // song is from YouTube so change to playerType: YouTube
                        self.playerType = YouTube;
                        
                        
                        NSLog(@"next song is from YouTube: %@", song[@"url"]);
//                        NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeID:song[@"pid"] ];
//                        NSURL *url = [NSURL URLWithString:[videos objectForKey:@"medium"]];
                        NSURL *url = [NSURL URLWithString:song[@"url"]];
                        
//                        NSLog(@"youtube videos: %@", videos);
                        NSLog(@"youtube url: %@", url);
//                        [self.ytPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
                        self.ytPlayer = [HomeVC newPlayerWithURL:url];
                        
                        [self.barTimer invalidate];
                        self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
                        [self.barTimer fire];
                        
                        if(self.player.currentPlaybackRate==1.0){
                            NSLog(@"pause song on youtube");
                            [self.player pause];
                        }
                        
                        [self.ytPlayer play];
                        
                    } else {
                        self.playerType = Native;
                        
                        
                        NSString *pid = [song objectForKey:@"pid"];
                        NSNumber *blah = [NSNumber numberWithLongLong:[pid longLongValue]];
                        NSLog(@"next song is native on device: %@\n%@", pid,blah);
                        
                        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue: [NSString stringWithFormat:@"%@",blah] forProperty:MPMediaItemPropertyPersistentID];
                        
                        MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] init];
                        [mediaQuery addFilterPredicate:predicate];
                        
                        self.player.nowPlayingItem = nil;
                        [self.player setQueueWithQuery:mediaQuery];
                        [self.player play];
                        
                        [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
                        
                        [self.barTimer invalidate];
                        self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
                        [self.barTimer fire];
                    }
                    
                    [self.data removeObject:first];
                    
                    self.songTitleLabel.text = song[@"title"];
                    self.artistTitleLabel.text = song[@"artist"];
                    
                    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
                    
//                    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imagedNamed:@"AlbumArt"]];
                    
                    [songInfo setObject:song[@"title"] forKey:MPMediaItemPropertyTitle];
                    [songInfo setObject:song[@"artist"] forKey:MPMediaItemPropertyArtist];
//                    [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
//                    [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                    
                    
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
    
    if(self.playerType == Native){
    
        if(self.player.currentPlaybackRate==0.0){ // not playing
            
            if(self.player.nowPlayingItem){ // have a paused item, play it
                [self.player play];
                [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
                
                [self.barTimer invalidate];
                self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
                [self.barTimer fire];
            } else { // dont have an item to play get next one and play it
                [self loadSongsAndNext:YES];
            }
        } else if(self.player.currentPlaybackRate==1.0) { // playing
            [self.barTimer invalidate];
            [self.player pause];
            [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
        }
        
    } else if(self.playerType == YouTube){
        NSLog(@"youtube player");
        if(self.ytPlayer.rate==0.0){ // not playing
            NSLog(@"--not playing");
            if(self.ytPlayer.currentItem){
                NSLog(@"--has current item, play it");
                [self.ytPlayer play];
                [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
                
                [self.barTimer invalidate];
                self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
                [self.barTimer fire];
            } else {
                NSLog(@"--no item, find next");
                [self loadSongsAndNext:YES];
            }
        } else if(self.ytPlayer.rate==1.0) { // is playing
            NSLog(@"--is playing, pause it");
            
            [self.barTimer invalidate];
            [self.ytPlayer pause];
            [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
        }
        
        
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
        o[@"pid"] = [NSString stringWithFormat:@"%@", [i valueForProperty:MPMediaItemPropertyPersistentID]];
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
    if(self.playerType == Native){
        int state = [[noti.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"] intValue];
        if(state == MPMusicPlaybackStateStopped){
            NSLog(@"playback stopped");
            [self loadSongsAndNext:YES];
        }
    }
//    else if(self.playerType == YouTube){
//        NSLog(@"YouTube playback state changed: %@",noti);
//        int state = [[noti.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"] intValue];
//        if(state){
//            if(state != MPMusicPlaybackStateStopped){
//                [self loadSongsAndNext:YES];
//            }
//        } else {
//            NSLog(@"youtube video over, play next");
//            [self loadSongsAndNext:YES];
//        }
//    }
}

- (void)onYoutubePlaybackStateChanged:(NSNotification*)noti
{
    NSLog(@"YouTube playback state changed: %@",noti);
//    int state = [[noti.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"] intValue];
//    if(state){
//        if(state != MPMusicPlaybackStateStopped){
//            [self loadSongsAndNext:YES];
//        }
//    } else {
//        NSLog(@"youtube video over, play next");
        [self loadSongsAndNext:YES];
//    }

}

- (void)onNowPlayingItemChanged:(NSNotification*)noti
{

    if(self.playerType == Native){
        NSLog(@"Native now playing item changed: %@",noti);
    } else if(self.playerType == YouTube){
        NSLog(@"YouTube now playing item changed: %@",noti);
    }
}

- (void)onTimer:(NSTimer*)timer
{
    if(self.playerType == Native){
        MPMediaItem *item = self.player.nowPlayingItem;
        
        NSNumber *dur = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        
        [self.progressBar setProgress:(self.player.currentPlaybackTime/[dur doubleValue]) animated:YES];
    } else if(self.playerType == YouTube){
        AVPlayerItem *item = self.ytPlayer.currentItem;
        
        CMTime dur = item.duration;
        
        [self.progressBar setProgress:(CMTimeGetSeconds(self.ytPlayer.currentTime)/CMTimeGetSeconds(dur)) animated:YES];
    }
    
    
}










@end
