//
//  MentionsViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface MentionsViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Tweet*>* tweets;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // set up refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // get timeline again (for when we switch between tabs)
    [self.activityIndicator startAnimating];
    [self fetchTweets];
}

- (void)fetchTweets {
    [[APIManager shared] getMentions:^(NSArray<Tweet*>* tweets, NSError* error) {
        if(tweets)
        {
            self.tweets = (NSMutableArray<Tweet*>*)tweets;
        }
        else
        {
            
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

@end
