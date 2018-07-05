//
//  Tweet.h
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
// Instance Properties //
@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) User* retweetedByUser;
@property (strong, nonatomic) NSString* creationDate;
@property (strong, nonatomic) NSString* creationDateWithTime;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;
@property (nonatomic) int retweetCount;
@property (nonatomic) int favoriteCount;

// Constructors //
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

// Static methods //
+ (NSMutableArray*)tweetsWithArray:(NSArray*)dictionaries;
@end
