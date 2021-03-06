//
//  NoteCommentViewController.m
//  ARIS
//
//  Created by Brian Thiel on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCommentViewController.h"
#import "NotebookViewController.h"
#import "NoteEditorViewController.h"
#import "NoteDetailsViewController.h"
#import "AppServices.h"
#import "NoteCommentCell.h"
#import "ARISAppDelegate.h"
#import "AudioRecorderViewController.h"
#import "UIImage+Scale.h"
#import "AsyncMediaPlayerButton.h"


@implementation NoteCommentViewController
@synthesize parentNote,commentNote,textBox,rating,commentTable,addAudioButton,addPhotoButton,addMediaFromAlbumButton,myIndexPath,commentValid,addTextButton,videoIconUsed,photoIconUsed,audioIconUsed,currNoteHasAudio,currNoteHasPhoto,currNoteHasVideo,inputView,hideKeyboardButton,addCommentButton,delegate,movieViews;
@synthesize asyncMediaDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        movieViews = [[NSMutableArray alloc]initWithCapacity:5];
        asyncMediaDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        self.title = NSLocalizedString(@"NoteCommentViewTitleKey", @"");
        self.hidesBottomBarWhenPushed = YES;
        commentValid = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewFromModel) name:@"NewNoteListReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(movieFinishedCallback:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:nil];
    }
    return self;
}

-(void)refreshViewFromModel
{
    [self addUploadsToComments];    
    [self.commentTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Note *tnote = [[AppModel sharedAppModel] noteForNoteId:self.parentNote.noteId playerListYesGameListNo:NO];
    if(!tnote) tnote = [[AppModel sharedAppModel] noteForNoteId:self.parentNote.noteId playerListYesGameListNo:YES];
    if(!tnote)
        NSLog(@"this shouldn't happen");
    self.parentNote = tnote;
    
    hideKeyboardButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SaveCommentKey", @"") style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    //self.navigationItem.rightBarButtonItem = hideKeyboardButton;
    
    addCommentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showKeyboard)];
    self.navigationItem.rightBarButtonItem = addCommentButton;
    
    myIndexPath = [[NSIndexPath alloc] init];
    [self.navigationItem.backBarButtonItem setAction:@selector(perform:)];
    // Do any additional setup after loading the view from its nib.
}

-(void) perform:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.videoIconUsed = NO;
    self.photoIconUsed = NO;
    self.audioIconUsed = NO;
    if(self.textBox.frame.origin.y == 0)
        [self.textBox becomeFirstResponder];
    [self refreshViewFromModel];    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshViewFromModel];
}

-(void)addUploadsToComments
{
    Note *    note = [[AppModel sharedAppModel] noteForNoteId: self.parentNote.noteId playerListYesGameListNo:YES];
    if(!note) note = [[AppModel sharedAppModel] noteForNoteId: self.parentNote.noteId playerListYesGameListNo:NO];
    if(!note) NSLog(@"this shouldn't happen");
    
    self.parentNote = note;
    for(int i = 0; i < [self.parentNote.comments count]; i++)
    {
        Note *currNote = [self.parentNote.comments objectAtIndex:i];
        for(int x = [currNote.contents count]-1; x >= 0; x--)
        {
            if(![[[currNote.contents objectAtIndex:x] getUploadState] isEqualToString:@"uploadStateDONE"])
                [currNote.contents removeObjectAtIndex:x];
        }
        
        NSMutableDictionary *uploads = [AppModel sharedAppModel].uploadManager.uploadContentsForNotes;
        NSArray *uploadContentForNote = [[uploads objectForKey:[NSNumber numberWithInt:currNote.noteId]] allValues];
        [currNote.contents addObjectsFromArray:uploadContentForNote];
        NSLog(@"NoteEditorVC: Added %d upload content(s) to note",[uploadContentForNote count]);
    }
    
    if([AppModel sharedAppModel].isGameNoteList)
        [[AppModel sharedAppModel].gameNoteList setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
    else
        [[AppModel sharedAppModel].playerNoteList setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
}

-(void)addPhotoButtonTouchAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        CameraViewController *cameraVC = [[CameraViewController alloc] initWithNibName:@"Camera" bundle:nil];
        cameraVC.parentDelegate = self;
        cameraVC.showVid = YES;
        
        cameraVC.noteId = self.commentNote.noteId;
        cameraVC.backView = self;
        
        [self.navigationController pushViewController:cameraVC animated:YES];
    }
}

-(void)addAudioButtonTouchAction
{
    BOOL audioHWAvailable = [[AVAudioSession sharedInstance] inputIsAvailable];
    if(audioHWAvailable){
        AudioRecorderViewController *audioVC = [[AudioRecorderViewController alloc] initWithNibName:@"AudioRecorderViewController" bundle:nil];
        audioVC.parentDelegate = self;
        audioVC.noteId = self.commentNote.noteId;
        audioVC.backView = self;
        
        [self.navigationController pushViewController:audioVC animated:YES];
    }    
}

-(void)addTextButtonTouchAction
{
}

-(void)addMediaFromAlbumButtonTouchAction
{
    CameraViewController *cameraVC = [[CameraViewController alloc] initWithNibName:@"Camera" bundle:nil];
    //cameraVC.delegate = self.delegate;
    cameraVC.parentDelegate = self;
    
    cameraVC.showVid = NO;
    cameraVC.noteId = self.commentNote.noteId;
    cameraVC.backView = self;
    
    [self.navigationController pushViewController:cameraVC animated:YES];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parentNote.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *tempCell = (NoteCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tempCell && ![tempCell respondsToSelector:@selector(mediaIcon2)])
    {
        tempCell = nil;
    }
    NoteCommentCell *cell = (NoteCommentCell *)tempCell;
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"NoteCommentCell" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (NoteCommentCell *)temporaryController.view;
        // Release the temporary UIViewController.
    }
    self.photoIconUsed = NO;
    self.videoIconUsed = NO;
    self.audioIconUsed = NO;
    
    Note *currComment = [self.parentNote.comments objectAtIndex:(indexPath.row)];
    cell.note = currComment;
    [cell initCell];
    [cell checkForRetry];
    cell.userInteractionEnabled = YES;
    cell.titleLabel.contentInset = UIEdgeInsetsMake(0.0f,4.0f,0.0f,4.0f);
    cell.titleLabel.text = currComment.title;
    if(![currComment.displayname isEqualToString:@""])
        cell.userLabel.text = currComment.displayname;
    else
        cell.userLabel.text = currComment.username;
    CGFloat textHeight = [self calculateTextHeight:[currComment title]] +35;
    if (textHeight < 30) textHeight = 30;
    [cell.userLabel setFrame:CGRectMake(cell.userLabel.frame.origin.x, textHeight+5, cell.userLabel.frame.size.width, cell.userLabel.frame.size.height)];
    
    for(int x = 0; x < [currComment.contents count]; x++)
    {
        if ([[(NoteContent *)[[currComment contents] objectAtIndex:x] getType] isEqualToString:kNoteContentTypePhoto])
        {
            AsyncMediaImageView *aImageView = [[AsyncMediaImageView alloc]initWithFrame:CGRectMake(10, textHeight, 300, 300) andMedia:[[[currComment contents] objectAtIndex:x] getMedia]];
            [cell.userLabel setFrame:CGRectMake(cell.userLabel.frame.origin.x, cell.frame.origin.y+(textHeight+300)+5, cell.userLabel.frame.size.width, cell.userLabel.frame.size.height)];
            
            [cell addSubview:aImageView];
        }
        else if([[(NoteContent *)[[currComment contents] objectAtIndex:x] getType] isEqualToString:kNoteContentTypeVideo] || [[(NoteContent *)[[currComment contents] objectAtIndex:x] getType] isEqualToString:kNoteContentTypeAudio])
        {
            NoteContent *content = (NoteContent *)[[currComment contents] objectAtIndex:x];
            AsyncMediaPlayerButton *mediaButton = [asyncMediaDict objectForKey:content.getMedia.url];
            
            if(!mediaButton)
            {
                CGRect frame = CGRectMake(10, textHeight, 300, 450);
                mediaButton = [[AsyncMediaPlayerButton alloc]
                               initWithFrame:frame
                               media:content.getMedia
                               presentingController:[RootViewController sharedRootViewController] preloadNow:NO];
                [asyncMediaDict setObject:mediaButton forKey:content.getMedia.url];
            }
            [cell.userLabel setFrame:CGRectMake(cell.userLabel.frame.origin.x, cell.frame.origin.y+(textHeight+300)+5, cell.userLabel.frame.size.width, cell.userLabel.frame.size.height)];

            [cell addSubview:mediaButton];
        }
    }
    
    if(![AppModel sharedAppModel].currentGame.allowNoteLikes)
    {
        cell.likesButton.enabled = NO;
        cell.likeLabel.hidden = YES;
        cell.likesButton.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Color the backgrounds
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:233.0/255.0
                                               green:233.0/255.0
                                                blue:233.0/255.0
                                               alpha:1.0];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:200.0/255.0
                                               green:200.0/255.0
                                                blue:200.0/255.0
                                               alpha:1.0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (int) calculateTextHeight:(NSString *)text
{
	CGSize calcSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(235-8, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
	return calcSize.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = (Note *)[self.parentNote.comments objectAtIndex:(indexPath.row)];
    CGFloat textHeight = [self calculateTextHeight:[note title]] +35;
    if (textHeight < 30)textHeight = 30;
    BOOL hasImage = NO;
    for(int i = 0; i < [[note contents] count];i++)
    {
        if([[(NoteContent *)[[note contents]objectAtIndex:i]getType] isEqualToString:kNoteContentTypePhoto] ||
           [[(NoteContent *)[[note contents]objectAtIndex:i]getType] isEqualToString:kNoteContentTypeVideo] ||
           [[(NoteContent *)[[note contents]objectAtIndex:i]getType] isEqualToString:kNoteContentTypeAudio])
        {
            hasImage = YES;
        }
    }
    [note setHasImage:hasImage];

    if(hasImage) textHeight+=300;
    textHeight += 21+5; // User Label
    return textHeight;
}

#pragma mark Text view methods
-(void)showKeyboard
{
    self.navigationItem.rightBarButtonItem = hideKeyboardButton;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.5];
    [self.textBox setFrame:CGRectMake(0, 0, 320, 210)];
    [self.inputView setFrame:CGRectMake(0, 150, 320, 52)];
    [UIView commitAnimations];
    [self.textBox becomeFirstResponder];
    self.textBox.text = @"";
    commentNote = [[Note alloc]init];
    
    self.commentNote.noteId = [[AppServices sharedAppServices]addCommentToNoteWithId:self.parentNote.noteId andTitle:@""];
    if(self.commentNote.noteId == 0){
        self.navigationItem.rightBarButtonItem = addCommentButton;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:.5];
        [self.textBox setFrame:CGRectMake(0, -215, 320, 215)];
        [self.inputView setFrame:CGRectMake(0, 416, 320, 52)];
        [UIView commitAnimations];
        
        [self.textBox resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NoteCommentViewCreateFailedKey", @"") message:NSLocalizedString(@"NoteCommentViewCreateFailedMessageKey", @"") delegate:self.delegate cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles: nil];
        [alert show];
    }
    
    [self.parentNote.comments insertObject:self.commentNote atIndex:0];
    if([AppModel sharedAppModel].isGameNoteList)
        [[AppModel sharedAppModel].gameNoteList   setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
    else
        [[AppModel sharedAppModel].playerNoteList setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
    self.addAudioButton.userInteractionEnabled = YES;
    self.addAudioButton.alpha = 1;
    self.addPhotoButton.userInteractionEnabled = YES;
    self.addPhotoButton.alpha = 1;
    self.addMediaFromAlbumButton.userInteractionEnabled = YES;
    self.addMediaFromAlbumButton.alpha = 1;
}

-(void)hideKeyboard
{    
    if([textBox.text length] == 0 || [textBox.text isEqualToString:@"Write Comment..."])
    {
        UIAlertView *alert;
        
        alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"ErrorKey", @"")
                                           message: NSLocalizedString(@"PleaseAddCommentKey", @"")
                                          delegate: self cancelButtonTitle: NSLocalizedString(@"OkKey", @"") otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = addCommentButton;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:.5];
        [self.textBox setFrame:CGRectMake(0, -215, 320, 215)];
        [self.inputView setFrame:CGRectMake(0, 416, 320, 52)];
        [UIView commitAnimations];
        
        [self.textBox resignFirstResponder];
        commentNote.title = self.textBox.text;
        commentNote.parentNoteId = parentNote.noteId;
        commentNote.creatorId = [AppModel sharedAppModel].playerId;
        commentNote.username = [AppModel sharedAppModel].userName;
        
        [[AppServices sharedAppServices]updateCommentWithId:self.commentNote.noteId andTitle:self.textBox.text andRefresh:YES];
        
        if([parentNote.comments count] > 0 && [[parentNote.comments objectAtIndex:0] noteId] == commentNote.noteId)
        {
            [[parentNote.comments objectAtIndex:0] setTitle:self.textBox.text];
            [[parentNote.comments objectAtIndex:0] setParentNoteId:parentNote.noteId];
            [[parentNote.comments objectAtIndex:0] setCreatorId:[AppModel sharedAppModel].playerId];
            [[parentNote.comments objectAtIndex:0] setUsername:[AppModel sharedAppModel].userName];
        }
        else
            [parentNote.comments insertObject:commentNote atIndex:0];

        [self.delegate setNote:parentNote];
        
        if([AppModel sharedAppModel].isGameNoteList)
            [[AppModel sharedAppModel].gameNoteList   setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
        else
            [[AppModel sharedAppModel].playerNoteList setObject:self.parentNote forKey:[NSNumber numberWithInt:self.parentNote.noteId]];
        
        self.commentValid = YES;
        [movieViews removeAllObjects];
        
        [self refreshViewFromModel];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Write Comment..."]) textView.text = @"";    
}

- (void)textViewDidChange:(UITextView *)textView
{
    /*   NoteCommentCell *cell = (NoteCommentCell *)[self.commentTable cellForRowAtIndexPath:self.myIndexPath];
     cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self calculateTextHeight:textView.text]+35);
     NSArray *indexArr = [[NSArray alloc] initWithObjects:self.myIndexPath, nil];*/
    //[self.commentTable reloadRowsAtIndexPaths:indexArr withRowAnimation:nil];
}

-(void)addedPhoto
{    
    self.commentValid = YES;
    self.currNoteHasPhoto = YES;
    self.addPhotoButton.userInteractionEnabled = NO;
    self.addMediaFromAlbumButton.userInteractionEnabled = NO;
    self.addAudioButton.userInteractionEnabled = NO;
    
    self.addPhotoButton.alpha = .3;
    self.addMediaFromAlbumButton.alpha = .3;
    self.addAudioButton.alpha = .3;
}

-(void)addedAudio
{    
    self.commentValid = YES;
    self.currNoteHasAudio = YES;
    self.addPhotoButton.userInteractionEnabled = NO;
    self.addMediaFromAlbumButton.userInteractionEnabled = NO;
    self.addAudioButton.userInteractionEnabled = NO;
    
    self.addPhotoButton.alpha = .3;
    self.addMediaFromAlbumButton.alpha = .3;
    self.addAudioButton.alpha = .3;
}

-(void)addedVideo
{
    self.commentValid = YES;
    self.currNoteHasVideo = YES;
    self.addPhotoButton.userInteractionEnabled = NO;
    self.addMediaFromAlbumButton.userInteractionEnabled = NO;
    self.addAudioButton.userInteractionEnabled = NO;
    
    self.addPhotoButton.alpha = .3;
    self.addMediaFromAlbumButton.alpha = .3;
    self.addAudioButton.alpha = .3;
}

-(void)addedText
{
    self.commentValid = YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.parentNote.comments objectAtIndex:(indexPath.row)] creatorId] == [AppModel sharedAppModel].playerId ||
       [self.parentNote creatorId] == [AppModel sharedAppModel].playerId)
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.parentNote.comments objectAtIndex:(indexPath.row)] creatorId] == [AppModel sharedAppModel].playerId ||
       [self.parentNote creatorId] == [AppModel sharedAppModel].playerId)
    {
        [[AppServices sharedAppServices]deleteNoteWithNoteId:[[self.parentNote.comments objectAtIndex:(indexPath.row)] noteId]];
        [self.parentNote.comments removeObjectAtIndex:(indexPath.row)];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.commentTable reloadData];
}

- (void)movieFinishedCallback:(NSNotification*) aNotification
{
	NSLog(@"ItemDetailsViewController: movieFinishedCallback");
	[self dismissMoviePlayerViewControllerAnimated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSInteger)supportedInterfaceOrientations
{
    NSInteger mask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        mask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return mask;
}

@end
