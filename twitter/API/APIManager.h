//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

// Local User Object //
@property (strong, nonatomic) User* currentUser;

// Constructors //
+ (instancetype)shared;

// Instance Methods //
- (void)getCurrentUser;
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)getUserTimeline:(User*)user completion:(void(^)(NSArray<Tweet*>*, NSError*))completion;
- (void)getMentions:(void(^)(NSArray<Tweet*>*, NSError*))completion;
- (void)getUserWithHandle:(NSString*)handle completion:(void(^)(User*, NSError*))completion;
- (void)composeTweetWith:(NSString*)text completion:(void(^)(Tweet*, NSError*))completion;
- (void)favoriteTweet:(Tweet*)tweet completion:(void(^)(Tweet*, NSError*))completion;
- (void)unfavoriteTweet:(Tweet*)tweet completion:(void(^)(Tweet*, NSError*))completion;
- (void)retweet:(Tweet*)tweet completion:(void(^)(Tweet*, NSError*))completion;
- (void)unretweet:(Tweet*)tweet completion:(void(^)(Tweet*, NSError*))completion;
- (void)replyToTweet:(Tweet*)tweet withText:(NSString*)text completion:(void(^)(Tweet*, NSError*))completion;
@end
