//
//  PlaylistMediaPickerVC.m
//  Juke
//
//  Created by Derek Arner on 6/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "PlaylistMediaPickerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlaylistMediaPickerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation PlaylistMediaPickerVC

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
    
    MPMediaQuery *mpq = [MPMediaQuery playlistsQuery];
    [mpq addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    self.data = [NSMutableArray arrayWithArray:[mpq collections]];
    
    //    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
    
    // get cell views
    UILabel *title = (id)[cell viewWithTag:1];
    UILabel *total = (id)[cell viewWithTag:2];
    
    // fill in cell data
    title.text = [item valueForProperty:MPMediaPlaylistPropertyName];
    total.text = [NSString stringWithFormat:@"%lu items",(unsigned long)item.count];
    
    
    // select if already picked
    if([self.songs objectForKey:pid]){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    
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
