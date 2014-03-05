//
//  TestWebView.h
//  keyo
//
//  Created by User on 2/24/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "LBYouTube.h"

@interface TestWebView : UIViewController<LBYouTubeExtractorDelegate,UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *movieView;

- (IBAction)onPlay:(id)sender;
- (IBAction)onPause:(id)sender;


@end
