//
//  TweetCell.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet*)tweet {
    _tweet = tweet;
    self.nameLabel.text = tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.handle];
    self.dateLabel.text = tweet.creationDate;
    self.textContentLabel.text = tweet.text;
    self.retweetLabel.text = [tweet.retweetCount stringValue];
    self.favoriteLabel.text = [tweet.favoriteCount stringValue];
    
    // change images
    UIImage* retweetImage = nil;
    UIImage* favoriteImage = nil;
    if(tweet.retweeted)
    {
        retweetImage = [UIImage imageNamed:@"retweet-icon-green"];
    }
    else
    {
        retweetImage = [UIImage imageNamed:@"retweet-icon"];
    }
    
    if(tweet.favorited)
    {
        favoriteImage = [UIImage imageNamed:@"favor-icon-red"];
    }
    else
    {
        favoriteImage = [UIImage imageNamed:@"favor-icon"];
    }
    
    // set images
    self.retweetImage.image = retweetImage;
    self.favoriteImage.image = favoriteImage;
    
    // load profile picture
    [self.profilePicture setImageWithURL:tweet.user.profileImageURL];
}
@end
