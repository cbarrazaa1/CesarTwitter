//
//  ProfileViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UIView *tweetsView;
@property (weak, nonatomic) IBOutlet UIView *followingView;
@property (weak, nonatomic) IBOutlet UIView *followersView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Tweet*>* tweets;

@end

@implementation ProfileViewController

- (void)updateUI {
    // set the views' border
    self.tweetsView.layer.borderWidth = 1;
    self.tweetsView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:255/255].CGColor;
    self.followersView.layer.borderWidth = 1;
    self.followersView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:255/255].CGColor;
    self.followingView.layer.borderWidth = 1;
    self.followingView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:255/255].CGColor;
    
    // set profile picture border
    self.profileImage.layer.borderWidth = 2;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // set pictures
    [self.backgroundImage setImageWithURL:self.user.backgroundImageURL];
    [self.profileImage setImageWithURL:self.user.profileImageURL];
    self.nameLabel.text = self.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.user.handle];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%i", self.user.tweetsCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%i", self.user.followingCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%i", self.user.followersCount];
}

- (void)fetchTweets {
    [[APIManager shared] getUserTimeline:[[APIManager shared] currentUser]
                         completion:^(NSArray<Tweet*>* tweets, NSError* error)
                         {
                             if (tweets)
                             {
                                 self.tweets = (NSMutableArray<Tweet*>*)tweets;
                             }
                             else
                             {
                                 NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                             }
                             
                             [self.tableView reloadData];
                            // [self.activityIndicator stopAnimating];
                            // [self.refreshControl endRefreshing];
                         }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet* tweet = self.tweets[indexPath.row];
    
    if(tweet != nil)
    {
        [cell setTweet:tweet];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
@end
