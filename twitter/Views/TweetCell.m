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
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set round image
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.width / 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (NSString*)reduceNumberWithSuffix:(int)number {
    // if none of the following conditions are true, just show the number normally
    NSString* res = [NSString stringWithFormat:@"%i", number];
    
    // if greater than 1000, add a 'k' suffix
    if(number > 1000)
    {
        // if greater than 1000000, add a 'm' suffix
        if(number > 1000000)
        {
            res = [NSString stringWithFormat:@"%iM", number / 1000000];
        }
        else
        {
            // if it's less than 10000, add a thousand separator
            if(number < 10000)
            {
                // get the hundreds portion
                int hundreds = number - ((number / 1000) * 1000);
                
                // get the most-left digit of the hundreds portion (since it's the one we will display)
                int mostLeftDigit = hundreds / 100;
                
                // get the tens portion, which will be the one we will use to check rounding
                int tens = hundreds - mostLeftDigit * 100;
                
                // if we are really close to the next hundred, then add one to the most-left digit
                if(tens > 80)
                {
                    mostLeftDigit++;
                }

                // arrange the output with the thousand separator
                res = [NSString stringWithFormat:@"%i,%iK", number / 1000, mostLeftDigit];
            }
            else
            {
                res = [NSString stringWithFormat:@"%iK", number / 1000];
            }
        }
    }
    
    return res;
}

- (void)updateUI {
    // set basic UI controls
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.handle];
    self.dateLabel.text = self.tweet.creationDate;
    self.textContentLabel.text = self.tweet.text;
    
    // set the RT and fav labels with a suffix if needed
    [self.retweetButton setTitle:[self reduceNumberWithSuffix:self.tweet.retweetCount] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:[self reduceNumberWithSuffix:self.tweet.favoriteCount] forState:UIControlStateNormal];

    // set images and label colors according to state
    if(self.tweet.retweeted == YES)
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        
        // color hex: #00d084
        [self.retweetButton setTitleColor:[UIColor colorWithRed:0/255.0 green:208/255.0 blue:132/255.0 alpha:255/255.0] forState:UIControlStateNormal];
    }
    else
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self.retweetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    if(self.tweet.favorited == YES)
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        
        // color hex: #e5214a
        [self.favoriteButton setTitleColor:[UIColor colorWithRed:229/255.0 green:33/255.0 blue:74/255.0 alpha:255/255.0] forState:UIControlStateNormal];
    }
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
        // make it big
        self.retweetButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            // make it back to normal
            self.retweetButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // provide haptic feedback
    [[[UIImpactFeedbackGenerator alloc] init] impactOccurred];
    
    // handle the actual data of the retweet
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
        // make it big
        self.favoriteButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            // back to normal
            self.favoriteButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // provide haptic feedback
    [[[UIImpactFeedbackGenerator alloc] init] impactOccurred];
    
    // handle the data for the favorite
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

- (IBAction)replyClick:(id)sender {
    // animate the click
    [UIView animateWithDuration:0.1 animations:^{
        // make it big
        self.replyButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            // back to normal
            self.replyButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // provide haptic feedback
    [[[UIImpactFeedbackGenerator alloc] init] impactOccurred];
}
@end
