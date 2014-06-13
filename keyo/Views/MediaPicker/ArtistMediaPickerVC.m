//
//  ArtistMediaPickerVC.m
//  Juke
//
//  Created by Derek Arner on 6/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "ArtistMediaPickerVC.h"
#import "AlbumMediaPickerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ArtistMediaPickerVC ()

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ArtistMediaPickerVC

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
    //    NSLog(@"songs: %@",self.songs);
    
    MPMediaQuery *mpq = [MPMediaQuery artistsQuery];
    [mpq addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    self.data = [NSMutableArray arrayWithArray:[mpq collections]];
    
    //    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - segue stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoAlbumsFromArtists"]){
        AlbumMediaPickerVC *vc = segue.destinationViewController;
        
        MPMediaItemCollection *item = [self.data objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        MPMediaPropertyPredicate *pred = [MPMediaPropertyPredicate predicateWithValue:[item.representativeItem valueForProperty:MPMediaItemPropertyArtist] forProperty:MPMediaItemPropertyAlbumArtist];
        MPMediaQuery *mpq = [MPMediaQuery albumsQuery];
        [mpq addFilterPredicate:pred];
        vc.data = [[mpq collections] mutableCopy];
        vc.title = [item.representativeItem valueForProperty:MPMediaItemPropertyArtist];
    }
}

#pragma mark - uitableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItemCollection *item = [self.data objectAtIndex:indexPath.row];
    NSString *pid = [item valueForProperty:MPMediaItemPropertyPersistentID];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
    
    // get cell views
    UILabel *artist = (id)[cell viewWithTag:1];
    UILabel *total = (id)[cell viewWithTag:2];
    
    // fill in cell data
    artist.text = [item.representativeItem valueForProperty:MPMediaItemPropertyArtist];
    total.text = [NSString stringWithFormat:@"%lu items",item.count];
    
    
    // select if already picked
    //    if([self.songs objectForKey:pid]){
    //        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //    }
    
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MPMediaItem *item = [self.data objectAtIndex:indexPath.row];
//    NSString *pid = [item valueForProperty:MPMediaItemPropertyPersistentID];
//    NSLog(@"did select: %@",pid);
//    [self.songs setObject:@"selected" forKey:pid];
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MPMediaItem *item = [self.data objectAtIndex:indexPath.row];
//    NSString *pid = [item valueForProperty:MPMediaItemPropertyPersistentID];
//
//    [self.songs removeObjectForKey:pid];
//}


#pragma mark - ui button methods

- (IBAction)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
