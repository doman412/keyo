//
//  AppDelegate.m
//  keyo
//
//  Created by Derek Arner on 12/22/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Spotify/Spotify.h>
#import "Theme.h"
// parse classes
#import "Hub.H"
#import "Song.h"
#import "QueuedSong.h"


static NSString * const kClientId = @"spotify-ios-sdk-beta";
static NSString * const kCallbackURL = @"spotify-ios-sdk-beta://callback";

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Hub registerSubclass];
    [Song registerSubclass];
    [QueuedSong registerSubclass];
    
    // keyo app
    [Parse setApplicationId:@"uIDUQhDpQqt52mUCBXjAVT6dbKY7LKGFydqxsKb1" clientKey:@"3AKo2kclh3TApYViG6MKcljISRlAueXRpZAZe4z1"];
    
    // juke app
//    [Parse setApplicationId:@"GU8DuOP6RzlnFFNBNOVnB5qrf6HCqxpJXSbDyN3W" clientKey:@"UPgsMzQYf73zz5TVTmHJjvI7WWSrzgrGqP4H7cn3"];
    
    
    
    [Theme initTheme];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // spotify stuff
    /*
	SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
		// This is the callback that'll be triggered when auth is completed (or fails).
        
		if (error != nil) {
			NSLog(@"*** Auth error: %@", error);
			return;
		}
        
		[[NSUserDefaults standardUserDefaults] setValue:[session propertyListRepresentation]
												 forKey:kSessionUserDefaultsKey];
//		[self enableAudioPlaybackWithSession:session];
	};
    
	
//	 STEP 2: Handle the callback from the authentication service. -[SPAuth -canHandleURL:withDeclaredRedirectURL:]
//	 helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
//     
//	 Make the token swap endpoint URL matches your auth service URL.
	 
    
	if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
		[[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
//											tokenSwapServiceEndpointAtURL:[NSURL URLWithString:@"http://usa.ikennd.ac:1234/swap"]
											tokenSwapServiceEndpointAtURL:[NSURL URLWithString:@"http://keyo.parseapp.com/swap"]
																 callback:authCallback];
		return YES;
	}
    */
    
    // test stuff
    NSLog(@"open url: %@\nfrom: %@\nannotation: %@",url,sourceApplication,annotation);
    
	return NO;
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"application handle events for background url session: %@",identifier);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"application did enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"application will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"application did become active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"application will terminate");
}

@end
