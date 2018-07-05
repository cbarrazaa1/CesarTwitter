//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by César Francisco Barraza on 7/4/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ComposeViewController.h"

@protocol TweetDetailsViewControllerDelegate
- (void)didModifyTweet:(Tweet*)tweet;
@end

@interface TweetDetailsViewController : UIViewController
// Instance Properties //
@property (strong, nonatomic) Tweet* tweet;
@property (weak, nonatomic) id<TweetDetailsViewControllerDelegate> delegate;
@property (weak, nonatomic) id<ComposeViewControllerDelegate> timelineDelegate;

// Instance Methods //
- (void)setTweet:(Tweet *)tweet;
@end
