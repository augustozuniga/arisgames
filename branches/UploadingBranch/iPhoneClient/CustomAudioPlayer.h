//
//  CustomAudioPlayer.h
//  ARIS
//
//  Created by Brian Thiel on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomAudioPlayer : UIView<AVAudioSessionDelegate, AVAudioPlayerDelegate>{
    UIButton *playButton;
    UILabel *timeLabel;
    AVPlayer *soundPlayer;
    id timeObserver;
    int mediaId;
}
@property(nonatomic,retain)UIButton *playButton;
@property(nonatomic,retain)UILabel *timeLabel;
@property(readwrite, retain) AVPlayer *soundPlayer;
@property(readwrite,assign)int mediaId;
- (id)initWithFrame:(CGRect)frame andMediaId:(int)mediaID;
-(void)removeObs;
-(void)playButtonTouch;
-(void)loadView;
@end
