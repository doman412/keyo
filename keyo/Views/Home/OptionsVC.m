//
//  OptionsVC.m
//  keyo
//
//  Created by User on 3/11/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "OptionsVC.h"

@interface OptionsVC (){
    BOOL spotifyLoggedIn;
}

@end

@implementation OptionsVC

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
    
    // test if spotify is logged in
    id plistRep = [[NSUserDefaults standardUserDefaults] valueForKey:@"SpotifySession"];
    SPTSession *session = [[SPTSession alloc] initWithPropertyListRepresentation:plistRep];
    
    if (session.credential.length > 0) {
        NSLog(@"launch with session");
        spotifyLoggedIn = YES;
    } else {
        NSLog(@"launch without session");
        spotifyLoggedIn = NO;
    }
    
    
    
    self.data = [[NSMutableArray alloc] init];
    
    id a = @{@"data":
                 @[
                     @{@"title": @"About",
                       @"view": @"AboutUs"}
                   ]
             };
    
    id b = @{@"header": @"Spotify",
             @"data":
                 @[
                     @{@"title": @"Login"}
                   ]
             };
    
    [self.data addObject:a];
//    [self.data addObject:b];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uitableview delegates

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.data objectAtIndex:section] objectForKey:@"header"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.data objectAtIndex:section] objectForKey:@"data"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // retrieving cell object
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    NSArray *arr = [dict objectForKey:@"data"];
    // cell object
    id obj = [arr objectAtIndex:indexPath.row];
    
    
    // cell components
    UILabel *tag1 = (id)[cell viewWithTag:1];
    
    
    // cell config
    
    [tag1 setText:obj[@"title"]];
    
    //  if cell is spotify login
//    if(indexPath.section==2 && indexPath.row==1){
//        if(spotifyLoggedIn){
//           [tag1 setText:@"Logout"];
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // retrieving cell object
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    NSArray *arr = [dict objectForKey:@"data"];
    // cell object
    id obj = [arr objectAtIndex:indexPath.row];
    
    if(obj[@"view"]){
        [self performSegueWithIdentifier:obj[@"view"] sender:self];
    }
}

@end
