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

// instance properties
@property (strong, nonatomic) Tweet* tweet;

// instance methods
- (void)setTweet:(Tweet*)tweet;
@end
