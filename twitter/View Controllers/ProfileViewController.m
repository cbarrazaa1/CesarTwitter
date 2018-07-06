//
//  ProfileViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface ProfileViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Tweet*>* tweets;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

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
    
    // set round image
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = (self.profileImage.frame.size.width / 2);
    
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
                             [self.activityIndicator stopAnimating];
                             [self.refreshControl endRefreshing];
                         }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // update UI
    [self updateUI];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // set up refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // update user object
    [[APIManager shared] getCurrentUser];
    self.user = [[APIManager shared] currentUser];
    
    // get timeline again (for when we switch between tabs)
    [self.activityIndicator startAnimating];
    [self fetchTweets];
    [self updateUI];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"replySegue"])
    {
        UINavigationController* navigationController = [segue destinationViewController];
        ComposeViewController* viewController = (ComposeViewController*)navigationController.topViewController;
        APIManager* apiManager = [APIManager shared];
        
        // set viewcontroller info
        viewController.name = apiManager.currentUser.name;
        viewController.handle = apiManager.currentUser.handle;
        viewController.url = apiManager.currentUser.profileImageURL;
        viewController.delegate = self;
        
        // get the cell using the sender (button). The button's superview is the contentview, and the contentview's superview is the cell.
        TweetCell* cell = (TweetCell*)[[sender superview] superview];
        viewController.isCompose = NO;
        viewController.replyingTo = cell.tweet;
    }
    else if([segue.identifier isEqualToString:@"detailsSegue"])
    {
        TweetDetailsViewController* viewController = (TweetDetailsViewController*)[segue destinationViewController];
        TweetCell* cell = (TweetCell*)sender;
        viewController.delegate = sender;
        viewController.timelineDelegate = self;
        [viewController setTweet:cell.tweet];
    }
}

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

- (void)didTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
