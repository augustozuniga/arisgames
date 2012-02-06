//
//  UploadContent.m
//  ARIS
//
//  Created by Philip Dougherty on 2/3/12.
//  Copyright (c) 2012 UW Madison. All rights reserved.
//

#import "UploadContent.h"

@implementation UploadContent

@dynamic title;
@dynamic text;
@dynamic media;
@dynamic type;
@dynamic note_id;
@dynamic attemptfailed;

- (NSString *) getTitle
{
    return [self title];
}

- (NSString *) getText
{
    return [self text];
}

- (Media *) getMedia
{
    return [self media];
}

- (NSString *) getType
{
    return [self type];
}

- (int) getNoteId
{
    return [[self note_id] intValue];
}

- (int) getContentId
{
    return -1;
}

@end