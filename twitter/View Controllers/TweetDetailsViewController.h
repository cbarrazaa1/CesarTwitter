//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by César Francisco Barraza on 7/4/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailsViewController : UIViewController
// Instance Properties //
@property (strong, nonatomic) Tweet* tweet;

// Instance Methods //
- (void)setTweet:(Tweet *)tweet;
@end
