//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
// outlet definitions
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// instance properties
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
    
    // setup tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // setup refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)composeClick:(id)sender {
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* navigationController = [segue destinationViewController];
    ComposeViewController* viewController = (ComposeViewController*)navigationController.topViewController;
    
    viewController.delegate = self;
    
    // setup compose view controller info
    APIManager* apiManager = [APIManager shared];
    viewController.name = apiManager.currentUser.name;
    viewController.handle = apiManager.currentUser.handle;
    viewController.url = apiManager.currentUser.profileImageURL;
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

- (IBAction)logoutClick:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // clear login tokens
    [[APIManager shared] logout];
}
@end
