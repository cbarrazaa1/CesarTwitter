//
//  TweetCell.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetCell ()
// outlets
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI {
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.handle];
    self.dateLabel.text = self.tweet.creationDate;
    self.textContentLabel.text = self.tweet.text;
    self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
    // set images according to state
    if(self.tweet.retweeted == YES)
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.favorited == YES)
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    // load profile picture
    [self.profilePicture setImageWithURL:self.tweet.user.profileImageURL];
}

- (void)setTweet:(Tweet*)tweet {
    _tweet = tweet;
    [self updateUI];
}

- (IBAction)retweetClick:(id)sender {
    // animate the click
    [UIView animateWithDuration:0.1 animations:^{
        self.retweetButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.retweetButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    if(!self.tweet.retweeted)
    {
        // update local values
        self.tweet.retweeted = YES;
        self.tweet.retweetCount++;
        
        // process the network call
        [[APIManager shared] retweet:self.tweet
                             completion:^(Tweet* tweet, NSError* error)
                             {
                                 // if we had an error, revert local changes
                                if(error != nil)
                                {
                                    self.tweet.retweeted = NO;
                                    self.tweet.retweetCount--;
                                    [self updateUI];
                                    NSLog(@"Error at 'retweet::completion': %@", error.localizedDescription);
                                }
                             }
         ];
    }
    else
    {
        // update local values
        self.tweet.retweeted = NO;
        self.tweet.retweetCount--;
        
        // process the network call
        [[APIManager shared] unretweet:self.tweet
                             completion:^(Tweet* tweet, NSError* error)
                             {
                                 // if we had an error, revert local changes
                                 if(error != nil)
                                 {
                                     self.tweet.retweeted = YES;
                                     self.tweet.retweetCount++;
                                     [self updateUI];
                                     NSLog(@"Error at 'unretweet::completion': %@", error.localizedDescription);
                                 }
                             }
         ];
    }
    
    // update button images
    [self updateUI];
}

- (IBAction)favoriteClick:(id)sender {
    // animate the click
    [UIView animateWithDuration:0.1 animations:^{
        self.favoriteButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.favoriteButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    if(!self.tweet.favorited)
    {
        // update local values
        self.tweet.favorited = YES;
        self.tweet.favoriteCount++;
        
        // process the network call
        [[APIManager shared] favoriteTweet:self.tweet
                             completion:^(Tweet* tweet, NSError* error)
                             {
                                 // if we had an error, then revert our local changes
                                 if(error != nil)
                                 {
                                     self.tweet.favorited = NO;
                                     self.tweet.favoriteCount--;
                                     [self updateUI];
                                     NSLog(@"Error at 'favoriteTweet::completion': %@", error.localizedDescription);
                                 }
                             }
         ];
    }
    else
    {
        // update local values
        self.tweet.favorited = NO;
        self.tweet.favoriteCount--;
        
        // process the network call
        [[APIManager shared] unfavoriteTweet:self.tweet
                             completion:^(Tweet* tweet, NSError* error)
                             {
                                 // if we had an error, then revert our local changes
                                 if(error != nil)
                                 {
                                     self.tweet.favorited = YES;
                                     self.tweet.favoriteCount++;
                                     [self updateUI];
                                     NSLog(@"Error at 'unfavoriteTweet::completion': %@", error.localizedDescription);
                                 }
                             }
         ];
    }
    
    // update the button images
    [self updateUI];
}

@end
