//
//  ComposeViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestChattyAppDelegate.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "Post.h"

@interface ComposeViewController : UIViewController {
  IBOutlet UILabel *parentPreview;
  IBOutlet UITextView *postContent;
  
  Post *parentPost;
  int storyId;
  UIImagePickerController *imagePickerController;
}

- (id)initWithStoryId:(int)aStoryId;
- (id)initWithStoryId:(int)aStoryId parentPost:(Post *)aPost;

- (IBAction)toggleKeyboard:(id)sender;
- (IBAction)sendPost:(id)sender;
- (void)sendPostConfirmed;
- (NSString *)urlEscape:(NSString *)string;

- (IBAction)tag:(id)sender;
- (IBAction)attachImage:(id)sender;

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSData *)shrinkImageByHalfAndJPEG:(UIImage *)picture;
@end
