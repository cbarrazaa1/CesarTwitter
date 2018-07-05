//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//
#import <UIImageView+AFNetworking.h>

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Tweet.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

// Instance properties //
@property (strong, nonatomic) NSMutableArray<Tweet*>* tweets;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get the current user
    [[APIManager shared] getCurrentUser:^(User* user, NSError* error) {
        if(error == nil)
        {
            APIManager* apiManager = [APIManager shared];
            apiManager.currentUser = user;
        }
    }];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // set up refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // get timeline
    [self.activityIndicator startAnimating];
    [self fetchTweets];
}

- (void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
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
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* navigationController = [segue destinationViewController];
    ComposeViewController* viewController = (ComposeViewController*)navigationController.topViewController;
    APIManager* apiManager = [APIManager shared];

    // set viewcontroller info
    viewController.name = apiManager.currentUser.name;
    viewController.handle = apiManager.currentUser.handle;
    viewController.url = apiManager.currentUser.profileImageURL;
    
    // set delegate to update tweet later
    viewController.delegate = self;
    
    if([segue.identifier isEqualToString:@"composeSegue"])
    {
        viewController.isCompose = YES;
    }
    else if([segue.identifier isEqualToString:@"replySegue"])
    {
        // get the cell using the sender (button). The button's superview is the contentview, and the contentview's superview is the cell.
        TweetCell* cell = (TweetCell*)[[(UIButton*)sender superview] superview];
        viewController.isCompose = NO;
        viewController.replyingTo = cell.tweet;
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
    // make sure it appears at the top
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)logoutClick:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    // reset all the app so that we are the beginning again
    appDelegate.window.rootViewController = loginViewController;
    
    // clear login tokens
    [[APIManager shared] logout];
}
@end
