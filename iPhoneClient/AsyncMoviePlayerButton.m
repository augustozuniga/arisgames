//
//  AsyncMoviePlayerButton.m
//  ARIS
//
//  Created by David Gagnon on 2/4/12.
//  Copyright (c) 2012 University of Wisconsin. All rights reserved.
//

#import "AsyncMoviePlayerButton.h"
#import "AppModel.h"


@implementation AsyncMoviePlayerButton

@synthesize media;
@synthesize mMoviePlayer;
@synthesize presentingController;


-(id)initWithFrame:(CGRect)frame mediaId:(int)mediaId presentingController:(UIViewController*)aPresentingController{    
    NSLog(@"AsyncMoviePlayerButton: initWithFrame,mediaId,presentingController");

    if (self = [super initWithFrame:frame]) {
        NSLog(@"AsyncMoviePlayerButton: super init successful");

        self.presentingController = aPresentingController;
        
        if(!media){
            media = [[Media alloc] init];
        }
        media = [[AppModel sharedAppModel] mediaForMediaId:mediaId];
        
        //Create movie player object
        if(!mMoviePlayer){
            mMoviePlayer = [[ARISMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:media.url]];
        }
        else [mMoviePlayer initWithContentURL:[NSURL URLWithString:media.url]];
            
        mMoviePlayer.moviePlayer.shouldAutoplay = NO;
        [mMoviePlayer.moviePlayer prepareToPlay];
        
        
        [self setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventTouchUpInside];
        
        //Load the background
        if (media.image) {
            NSLog(@"AsyncMoviePlayerButton: init: thumbnail was in media.image cache");
            [self setBackgroundImage:media.image forState:UIControlStateNormal];
        }
        
        else if ([media.type isEqualToString:@"Video"]){
            NSLog(@"AsyncMoviePlayerButton: fetching thumbnail for a video ");

            NSNumber *thumbTime = [NSNumber numberWithFloat:1.0f];
            NSArray *timeArray = [NSArray arrayWithObject:thumbTime];
            [mMoviePlayer.moviePlayer requestThumbnailImagesAtTimes:timeArray timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
            [dispatcher addObserver:self selector:@selector(movieThumbDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:mMoviePlayer.moviePlayer];
        }
        
        else if ([media.type isEqualToString:@"Audio"]){
            media.image = [UIImage imageNamed:@"microphoneBackground.jpg"];
            [self setBackgroundImage:media.image forState:UIControlStateNormal];
        }
    }
    NSLog(@"AsyncMoviePlayerButton: init complete");

    return self;
}    
    

-(void)movieThumbDidFinish:(NSNotification*) aNotification
{
    NSLog(@"AsyncMoviePlayerButton: movieThumbDidFinish");
    NSDictionary *userInfo = aNotification.userInfo;
    UIImage *videoThumb = [userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    NSError *e = [userInfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    UIImage *videoThumbSized = [videoThumb scaleToSize:self.frame.size];        
    
    [self setBackgroundImage:videoThumbSized forState:UIControlStateNormal];
    media.image = videoThumbSized;        
    
    if (e) {
        NSLog(@"MPMoviePlayerThumbnail ERROR: %@",e);
    }
}

-(void)playMovie:(id)sender {
    NSLog(@"AsyncMoviePlayerButton: Pressed");

    if ([self.presentingController respondsToSelector:@selector(presentMoviePlayerViewControllerAnimated:)]){
        [self.presentingController presentMoviePlayerViewControllerAnimated:mMoviePlayer];
    }
    [mMoviePlayer.moviePlayer play];
}



@end
