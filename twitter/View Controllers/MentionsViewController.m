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

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Tweet*>* tweets;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // get mentions
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
