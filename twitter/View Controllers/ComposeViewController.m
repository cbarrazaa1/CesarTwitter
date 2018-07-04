//
//  ComposeViewController.m
//  twitter
//
//  Created by César Francisco Barraza on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface ComposeViewController ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView* profilePicture;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* handleLabel;
@property (weak, nonatomic) IBOutlet UITextView* composeTextfield;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // show keyboard
    [self.composeTextfield becomeFirstResponder];
    
    // set round image
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.size.width / 2);
    
    // load UI with data
    [self.profilePicture setImageWithURL:self.url];
    self.nameLabel.text = self.name;
    self.handleLabel.text = self.handle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tweetClick:(id)sender {
    [[APIManager shared] composeTweetWith:self.composeTextfield.text
                         completion:^(Tweet* tweet, NSError* error)
                         {
                             if(error == nil)
                             {
                                 // let the timeline VC handle the tweet post
                                 [self.delegate didTweet:tweet];
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                             else
                             {
                                 NSLog(@"Error at 'tweetClick::completion': %@", error.localizedDescription);
                             }
                         }
     ];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
