//
//  TweetCell.h
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell
// Instance Properties //
@property (strong, nonatomic) Tweet* tweet;

// Instance Methods //
- (void)setTweet:(Tweet*)tweet;
@end
