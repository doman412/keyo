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
#import "Theme.h"
#import "Reachability.h"


@interface PlayerVC ()

@end

@implementation PlayerVC

const NSInteger Native = 0;
const NSInteger YouTube = 1;
const NSInteger Spotify = 2;

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
        // Turn on remote control event delivery
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        // Set itself as the first responder
        [self becomeFirstResponder];
    }
    
//    if(self.player.currentPlaybackRate==0.0){
//        [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
//    } else {
//        MPMediaItem *item = self.player.nowPlayingItem;
//        self.songTitleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
//        self.artistTitleLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
//    }
//    
//    if(self.player.nowPlayingItem){
//        MPMediaItem *item = self.player.nowPlayingItem;
//        self.songTitleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
//        self.artistTitleLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
//    }
    [self setNowPlaying];
    
    self.title = self.hub[@"title"];
    
    self.userLabel.text = @"";
    
    
    self.trashConfirm = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this hub?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [self.barTimer invalidate];
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.barTimer fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlaybackStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onYoutubePlaybackStateChanged:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

//    [self.ytPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    self.reach = [Reachability reachabilityForLocalWiFi];
    
    // theme this view
    self.tableView.backgroundColor = [Theme wellWhite];
    self.nowPlayingView.backgroundColor = [Theme wellWhite];
    self.playPauseButton.tintColor = [Theme lightBlue];
    self.skipButton.tintColor = [Theme lightBlue];
    self.songTitleLabel.textColor = [Theme fontBlack];
    self.artistTitleLabel.textColor = [Theme fontBlack];
    self.progressBar.progressTintColor = [Theme lightBlue];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSongsAndNext:NO];
    
    if(self.reach.currentReachabilityStatus != ReachableViaWiFi){
        NSLog(@"need to be on wifi!!");
        [[[UIAlertView alloc] initWithTitle:@"Need WiFi" message:@"In order to stream the music, you must be connected to WiFi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    [self.barTimer invalidate];
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.barTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.barTimer invalidate];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [self onPlayToggle:nil];
                break;
            
            case UIEventSubtypeRemoteControlPlay:
                [self onPlayToggle:nil];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self onPlayToggle:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"prev track");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self onSkip:nil];
                break;
                
            default:
                break;
        }
    }
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

-(void)setNowPlaying
{
    if(self.nowPlayingObject){
//        NSLog(@"now playing object: %@", self.nowPlayingObject[@"song"]);
        PFObject *song = self.nowPlayingObject[@"song"];
        self.songTitleLabel.text = song[@"title"];
        self.artistTitleLabel.text = song[@"artist"];
        
        
        if([song[@"type"] isEqualToString:@"yt"]){
            self.playerType = YouTube;
        }
        // temp thing due to incorrect setting of web app
        self.playerType = YouTube;
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        //                    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imagedNamed:@"AlbumArt"]];
        NSString *title = song[@"title"];
        NSString *artist = song[@"artist"];
        if(title)
            [songInfo setObject:song[@"title"] forKey:MPMediaItemPropertyTitle];
        if(artist)
            [songInfo setObject:song[@"artist"] forKey:MPMediaItemPropertyArtist];
        //                    [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //                    [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    } else {
        self.songTitleLabel.text = @"";
        self.artistTitleLabel.text = @"";
    }
    
    if(self.playerType==YouTube){
//        NSLog(@"player type: youtube");
        if(self.ytPlayer.rate==0.0){ // not playing
//            NSLog(@"player type: youtube; not playing");
            [self.playPauseButton setImage:[UIImage imageNamed:@"play-75"] forState:UIControlStateNormal];
        }
    }

}

- (void)loadSongsAndNext:(BOOL)next
{
    NSLog(@"load songs for player");
//    self.queue = [PFQuery queryWithClassName:@"QueuedSong"];
//    
//    //    [self.songQuery whereKey:@"hub" equalTo:self.hub];
//    //    [self.songQuery whereKey:@"queue" equalTo:self.hub[@"queue"]];
//    [self.queue whereKey:@"hub" equalTo:self.hub];
//    [self.queue whereKey:@"active" equalTo:@YES];
//    [self.queue orderByDescending:@"points"];
//    [self.queue addAscendingOrder:@"createdAt"];
//    [self.queue includeKey:@"song"];
    
    if(self.reach.currentReachabilityStatus != ReachableViaWiFi){
        NSLog(@"need to be on wifi!!");
        [[[UIAlertView alloc] initWithTitle:@"Need WiFi" message:@"In order to stream the music, you must be connected to WiFi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    
    [PFCloud callFunctionInBackground:@"getPlaylist" withParameters:@{@"hubId":self.hub.objectId} block:^(NSArray *objects, NSError *error) {
        if(!error){
            
            self.data = [NSMutableArray arrayWithArray:objects];
            if(self.data.count > 0){
                self.nowPlayingObject = [objects firstObject];
                // remove the first object becuause its now playing
                [self.data removeObjectAtIndex:0];
            }
            
            
            [self.tableView reloadData];
            [self setNowPlaying];
            if(next){
                
                if(self.nowPlayingObject){
                    PFObject *first = self.nowPlayingObject;
                    PFObject *song = first[@"song"];
                    
                    
                    if(self.playerType == YouTube){ // song is from YouTube so change to playerType: YouTube
                        
                        // the following if block should be temporary to fix cloud code issue
//                        NSLog(@"youtube song: %@", song);
                        NSString *ID = nil;
                        if(song[@"pId"]){
                            ID = song[@"pId"];
                        } else {
                            NSLog(@"need to use youtubeId");
                            ID = song[@"youtubeId"];
                        }
                        [PFCloud callFunctionInBackground:@"ytUrl" withParameters:@{@"id":ID} block:^(id object, NSError *error) {
                            if(!error){
//                                NSLog(@"ytUrl: %@",object);
                                NSString *urlFromParse = [object objectForKey:@"url"];
                                urlFromParse = [urlFromParse substringToIndex:[urlFromParse length]-1];
//                                NSString *fixedUrl = [urlFromParse stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                                NSLog(@"next song is from YouTube: %@", song[@"pId"]);
//                                NSLog(@"url from parse : %@", urlFromParse);
//                                NSLog(@"fixed url after: %@", fixedUrl);
                                
                                NSURL *url = nil;
                                //                             if([urls objectForKey:@"hd720"]){
                                //                                 url = [NSURL URLWithString:urls[@"hd720"]];
                                //                             } else {
                                //                                 url = [NSURL URLWithString:urls[@"medium"]];
                                //                             }
                                url = [NSURL URLWithString:urlFromParse];
                                
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
                                [self.playPauseButton setImage:[UIImage imageNamed:@"pause-75"] forState:UIControlStateNormal];
                                [self.ytPlayer play];
                            } else {
                                NSLog(@"failed to get url from parse: %@", error);
                            }
                        }];
                        
                    } else if(self.playerType == Spotify){ // song is from Spotify so change to playerType: Spotify
                        
                        
                        
                        NSLog(@"next song is from Spotify: %@", song[@"url"]);
                        //                        NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeID:song[@"pid"] ];
                        //                        NSURL *url = [NSURL URLWithString:[videos objectForKey:@"medium"]];
//                        NSURL *url = [NSURL URLWithString:song[@"url"]];
//                        
//                        //                        NSLog(@"youtube videos: %@", videos);
//                        NSLog(@"youtube url: %@", url);
//                        //                        [self.ytPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
//                        self.ytPlayer = [HomeVC newPlayerWithURL:url];
//                        
//                        [self.barTimer invalidate];
//                        self.barTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
//                        [self.barTimer fire];
//                        
//                        if(self.player.currentPlaybackRate==1.0){
//                            NSLog(@"pause song on youtube");
//                            [self.player pause];
//                        }
//                        
//                        [self.ytPlayer play];
                        
                    } else if(self.playerType == Native){
                        
                        
                        
                        NSString *pid = [song objectForKey:@"pId"];
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
                    
                    // remove the old one?
                    /*
                    [self.data removeObject:first];
                    
                    
                    
                    
                    first[@"active"] = @NO;
                    [first saveInBackground];
                    */
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

- (IBAction)onSkip:(id)sender
{
    if(self.nowPlayingObject){
        NSLog(@"on skip, player type: %i",self.playerType);
        if(self.playerType == YouTube){
            [PFCloud callFunctionInBackground:@"removeSong"
                               withParameters:@{@"queuedSongId": self.nowPlayingObject.objectId}
                                        block:^(id object, NSError *error) {
                                            if(!error){
                                                [self loadSongsAndNext:YES];
                                            } else {
                                                NSLog(@"failed to remove song: %@", self.nowPlayingObject.objectId);
                                            }
                                        }];
        }
    }
    
}

- (IBAction)onPlayToggle:(id)sender {
    NSLog(@"on play toggle: %i",self.playerType);
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
        
    } else if(self.playerType == Spotify){
        NSLog(@"toggle spotify");
        
        
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
        o[@"pId"] = [NSString stringWithFormat:@"%@", [i valueForProperty:MPMediaItemPropertyPersistentID]];
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





# pragma mark - table view delegate methods

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
    points.text = [NSString stringWithFormat:@"%li", (long)[queuedSong[@"score"] integerValue]];
    
    // theme the cell
    cell.backgroundColor = [Theme wellWhite];
    points.textColor = [Theme fontBlack];
    title.textColor = [Theme fontBlack];
    artist.textColor = [Theme fontBlack];
    
    return cell;
}


- (void)onPlaybackStateChanged:(NSNotification*)noti
{
    if(self.playerType == Native){
        int state = [[noti.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"] intValue];
        if(state == MPMusicPlaybackStateStopped){
            NSLog(@"playback stopped");
//            [self loadSongsAndNext:YES];
            [self onSkip:nil];
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
//        [self loadSongsAndNext:YES];
//    }

    [self onSkip:nil];
    
}

- (void)onNowPlayingItemChanged:(NSNotification*)noti
{

    if(self.playerType == Native){
        NSLog(@"Native now playing item changed: %@",noti);
    } /*else if(self.playerType == YouTube){
        NSLog(@"YouTube now playing item changed: %@",noti);
    }*/
}

- (void)onTimer:(NSTimer*)timer
{
    if(self.playerType == Native){
        MPMediaItem *item = self.player.nowPlayingItem;
        
        NSNumber *dur = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        
        [self.progressBar setProgress:(self.player.currentPlaybackTime/[dur doubleValue]) animated:YES];
    } else if(self.playerType == Spotify){
        NSLog(@"onTimer for spotify");
//        MPMediaItem *item = self.player.nowPlayingItem;
//        
//        NSNumber *dur = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
//        
//        [self.progressBar setProgress:(self.player.currentPlaybackTime/[dur doubleValue]) animated:YES];
    } else if(self.playerType == YouTube){
        AVPlayerItem *item = self.ytPlayer.currentItem;
        
        CMTime dur = item.duration;
        
        [self.progressBar setProgress:(CMTimeGetSeconds(self.ytPlayer.currentTime)/CMTimeGetSeconds(dur)) animated:YES];
    }
    
    
}










@end
