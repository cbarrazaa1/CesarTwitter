//
//  ComposeViewController.h
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet*)tweet;
@end

@interface ComposeViewController : UIViewController
// Instance Properties //
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* handle;
@property (strong, nonatomic) NSURL* url;
@property (nonatomic) BOOL isCompose;
@property (strong, nonatomic) Tweet* replyingTo;
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;

@end
