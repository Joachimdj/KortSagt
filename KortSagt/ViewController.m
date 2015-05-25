//
//  ViewController.m
//  YoutubeParser
//
//  Created by Simon Andersson on 9/22/12.
//  Copyright (c) 2012 Hiddencode.me. All rights reserved.
//

#import "ViewController.h"
#import "HCYoutubeParser.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void(^DrawRectBlock)(CGRect rect);

@interface HCView : UIView {
@private
    DrawRectBlock block;
}

- (void)setDrawRectBlock:(DrawRectBlock)b;

@end

@interface UIView (DrawRect)
+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(DrawRectBlock)block;
@end

@implementation HCView

- (void)setDrawRectBlock:(DrawRectBlock)b {
    block = [b copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (block)
        block(rect);
}

@end

@implementation UIView (DrawRect)

+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(DrawRectBlock)block {
    HCView *view = [[HCView alloc] initWithFrame:frame];
    [view setDrawRectBlock:block];
    return view;
}

@end

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewController {
    NSURL *_urlToLoad;
}

- (void)playVideo {
    
    if (_urlToLoad) {
        
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:_urlToLoad];
        [self presentViewController:mp animated:YES completion:NULL];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
          
    [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    NSURL *url = [NSURL URLWithString:@"https://www.youtube.com/watch?v=Jg1ufX2ls_4"] ;
 
     
            
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                
                
                NSDictionary *qualities = videoDictionary;
                
                NSString *URLString = nil;
                if ([qualities objectForKey:@"small"] != nil) {
                    URLString = [qualities objectForKey:@"small"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                _urlToLoad = [NSURL URLWithString:URLString];
            }];
    
    [self playVideo];
}

#pragma mark - Actions


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPlayButton:nil];
    
    [super viewDidUnload];
}



@end
