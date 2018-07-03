//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"PcLnheXx0MRfOL2iSxqyWxJv7";
static NSString * const consumerSecret = @"RoMopDnGDjTBJlrGIFaml7YWiQRHevjAcWJZKeWLr0AmoT0eOf";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       // Manually cache the tweets. If the request fails, restore from cache if possible.
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];

       NSMutableArray* tweets = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       NSArray *tweetDictionaries = nil;
       NSMutableArray* tweets = nil;
       
       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
           
           tweets = [Tweet tweetsWithArray:tweetDictionaries];
       }
       
       completion(tweets, error);
   }];
}

- (void)composeTweetWith:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString* url = @"1.1/statuses/update.json";
    NSDictionary* parameters = @{@"status": text};
    
    [self POST:url parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
       {
           Tweet* tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)responseObject];
           completion(tweet, nil);
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
       {
           completion(nil, error);
       }];
}

- (void)favoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString* url = @"1.1/favorites/create.json";
    NSDictionary* parameters = @{@"id": tweet.ID};
    
    [self POST:url parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
          {
              Tweet* tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)responseObject];
              completion(tweet, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
          {
              completion(nil, error);
          }
    ];
}

- (void)unfavoriteTweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString* url = @"1.1/favorites/destroy.json";
    NSDictionary* parameters = @{@"id": tweet.ID};
    
    [self POST:url parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
          {
              Tweet* tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)responseObject];
              completion(tweet, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
          {
              completion(nil, error);
          }
    ];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString* url = [[@"1.1/statuses/retweet/" stringByAppendingString:tweet.ID] stringByAppendingString:@".json"];
    NSDictionary* parameters = @{@"id": tweet.ID};
    
    [self POST:url parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
          {
              Tweet* tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)responseObject];
              completion(tweet, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
          {
              completion(nil, error);
          }
     ];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString* urlWithID = [[@"1.1/statuses/unretweet/" stringByAppendingString:tweet.ID] stringByAppendingString:@".json"];
    //NSString* url = @"1.1/statuses/unretweet.json";
    NSDictionary* parameters = @{@"id": tweet.ID};
    
    [self POST:urlWithID parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
          {
              Tweet* tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)responseObject];
              completion(tweet, nil);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
          {
              completion(nil, error);
          }
     ];
}
@end
