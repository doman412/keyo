//
//  TestWebView.m
//  keyo
//
//  Created by User on 2/24/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "TestWebView.h"
#import "HCYoutubeParser.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HomeVC.h"


@interface TestWebView (){
    MPMoviePlayerController *mp;
}

@end

@implementation TestWebView

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
    
    
//    JSContext *ctx = [JSContext contextWithJSGlobalContextRef:self.webView.mainFrame.globalContext];
    self.webView.delegate = self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.youtube.com/embed/_ovdm2yX4MA?feature=oembed"]]];
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    
//    UIWebView *wv = [[UIWebView alloc] init];
//    wv.delegate = self;
//    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ssyoutube.com/watch?v=_ovdm2yX4MA"]]];
    
    
    // XCDYouTubeVideoPlayer
    /*
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [XCDYouTubeVideoPlayerViewController new];
	[self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
	
	// https://developers.google.com/youtube/2.0/developers_guide_protocol_video_feeds#Standard_feeds
	NSURL *url = [NSURL URLWithString:@"https://gdata.youtube.com/feeds/api/standardfeeds/most_popular?v=2&alt=json&time=today&max-results=1"];
	[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		id json = [NSJSONSerialization JSONObjectWithData:data ?: [NSData new] options:0 error:NULL];
//		NSString *videoIdentifier = [[[json valueForKeyPath:@"feed.entry.media$group.yt$videoid.$t"] lastObject] description];
		videoPlayerViewController.videoIdentifier = @"_ovdm2yX4MA";
//        NSLog(@"video id: %@", videoIdentifier);
	}];
    */
    
    
    // LBYouTubeExtractor
//    LBYouTubeExtractor* extractor = [[LBYouTubeExtractor alloc] initWithID:@"_ovdm2yX4MA" quality:LBYouTubeVideoQualityMedium];
//    extractor.delegate = self;
//    [extractor startExtracting];
    
    // simple url
//    NSURL *url = [NSURL URLWithString:@"http://r9---sn-aigllnls.googlevideo.com/videoplayback?mt=1393544588&gir=yes&id=fe8bdd9b6c97e0c0&sver=3&sparams=clen%2Cdur%2Cgir%2Cid%2Cip%2Cipbits%2Citag%2Clmt%2Cpcm2fr%2Csource%2Cupn%2Cexpire&source=youtube&ms=au&clen=3151492&expire=1393567909&dur=198.391&ip=2a02%3A2498%3Ae003%3A44%3A225%3A90ff%3Afea6%3A805a&key=yt5&fexp=934601%2C911429%2C945008%2C914071%2C916624%2C937417%2C937416%2C913434%2C936910%2C936913%2C902907&upn=NzFwQ1WH_Eo&mv=m&ipbits=0&itag=140&lmt=1386144661390979&pcm2fr=yes&signature=93B80A0C0E6F202C2480975457F2FD8646C4A95E.6C56AA6E76FCEB4101DBB41EF83E4FFF5F490D47&title=Avicii+-+Levels"];
//    AVPlayer *ytPlayer = [HomeVC newPlayerWithURL:url];
//    [ytPlayer play];
    
    // Gets an dictionary with each available youtube url
//    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeID:@"_ovdm2yX4MA"];
//    NSURL *url = [NSURL URLWithString:[videos objectForKey:@"medium"]];
//    NSLog(@"test view - videos: %@  url: %@",videos,url);
    
    
//    // Presents a MoviePlayerController with the youtube quality medium
//    mp = [[MPMoviePlayerController alloc] init];
//    mp.contentURL = url;
//    mp.controlStyle = MPMovieControlModeDefault;
//    [mp prepareToPlay];
//    [mp.view setFrame:self.movieView.bounds];
//    [self.movieView addSubview:mp.view];
//    
//    [mp play];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"web view did finish load");
    JSContext *ctx = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"console"][@"log"] = ^(JSValue *msg) {
        NSLog(@"**JS** : %@", msg);
    };
    // $("a[title='video format: 360p']").attr('href');
//    [ctx evaluateScript:@"console.log($(\"a[title='video format: 360p']\").attr('href'))"];
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

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"web view did start load");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web view did fail to load: %@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"lb youtube extractor success: %@", videoURL);
    AVPlayer *ytPlayer = [HomeVC newPlayerWithURL:videoURL];
    [ytPlayer play];
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"lb youtube extractor failed");
}

- (IBAction)onPlay:(id)sender {
}

- (IBAction)onPause:(id)sender {
}
@end
