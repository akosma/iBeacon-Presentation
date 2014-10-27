//
//  TRIDataViewController.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 akosma. All rights reserved.
//

#import "TRIDataViewController.h"

@interface TRIDataViewController ()

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@end

@implementation TRIDataViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = self.dataObject[@"title"];
    self.descriptionView.text = self.dataObject[@"text"];
    self.imageView.image = self.dataObject[@"image"];
}

@end
