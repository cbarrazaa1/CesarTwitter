//
//  User.h
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
// instance properties
@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* handle;
@property (strong, nonatomic) NSURL* profileImageURL;

// Constuctors
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
