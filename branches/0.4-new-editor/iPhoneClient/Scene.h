//
//  Scene.h
//  aris-conversation
//
//  Created by Kevin Harris on 09/11/18.
//  Copyright 2009 Studio Tectorum. All rights reserved.
//

#import <Foundation/Foundation.h>

enum soundConstants {
	kEmptySound = -1,
	kStopSound = -2
};

@interface Scene : NSObject {
	NSString	*text;
	int			characterId;
	CGRect		zoomRect;
	
	int			bgSound;
	int			fgSound;
}

@property(readonly)	NSString	*text;
@property(readonly) int			characterId;
@property(readonly) CGRect		zoomRect;
@property(readonly) int			bgSound;
@property(readonly) int			fgSound;


- (id) initWithText:(NSString *)aText andCharacter:(int)aCharacterId andZoom:(CGRect)aRect 
	  withForeSound:(int)aFgSound andBackSound:(int)aBgSound;

@end
