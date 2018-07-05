//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/4/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@end

@implementation TweetDetailsViewController

- (void)updateUI {
    // set basic controls
    [self.profilePicture setImageWithURL:self.tweet.user.profileImageURL];
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = self.tweet.user.handle;
    self.contentLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.creationDateWithTime;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
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
    
    // change retweet and favorite labels according to quantity
    if(self.tweet.retweetCount == 1)
    {
        [self.retweetLabel setText:@"RETWEET"];
    }
    else if(self.tweet.retweetCount == 0)
    {
        [self.retweetCountLabel setText:@""];
        [self.retweetLabel setText:@""];
    }
    else
    {
        [self.retweetLabel setText:@"RETWEETS"];
    }
    
    if (self.tweet.favoriteCount == 1)
    {
        [self.favoriteLabel setText:@"LIKE"];
    }
    else if(self.tweet.favoriteCount == 0)
    {
        [self.favoriteCountLabel setText:@""];
        [self.favoriteLabel setText:@""];
    }
    else
    {
        [self.favoriteLabel setText:@"LIKES"];
    }
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set round image
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.width / 2);
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* navigationController = [segue destinationViewController];
    ComposeViewController* viewController = (ComposeViewController*)navigationController.topViewController;
    
    // pass the timeline delegate
    viewController.delegate = self.timelineDelegate;
    viewController.isCompose = NO;
    viewController.name = self.tweet.user.name;
    viewController.handle = self.tweet.user.handle;
    viewController.url = self.tweet.user.profileImageURL;
    viewController.replyingTo = self.tweet;
}

- (IBAction)retweetClick:(id)sender {
    // animate the click
    [UIView animateWithDuration:0.1 animations:^{
        // make it big
        self.retweetButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.retweetCountLabel.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            // make it back to normal
            self.retweetButton.transform = CGAffineTransformIdentity;
            self.retweetCountLabel.transform = CGAffineTransformIdentity;
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
                             else
                             {
                                 // trigger the cell's delegate
                                 [self.delegate didModifyTweet:self.tweet];
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
                                else
                                {
                                    // trigger the cell's delegate
                                    [self.delegate didModifyTweet:self.tweet];
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
        self.favoriteCountLabel.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            // back to normal
            self.favoriteButton.transform = CGAffineTransformIdentity;
            self.favoriteCountLabel.transform = CGAffineTransformIdentity;
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
                                    else
                                    {
                                        // trigger the cell's delegate
                                        [self.delegate didModifyTweet:self.tweet];
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
                                      else
                                      {
                                          // trigger the cell's delegate
                                          [self.delegate didModifyTweet:self.tweet];
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
