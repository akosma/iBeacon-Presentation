//
//  TRIDataViewController.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 Trifork GmbH. All rights reserved.
//

#import "TRIDataViewController.h"

@interface TRIDataViewController ()

@end

@implementation TRIDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = self.dataObject[@"title"];
    self.descriptionView.text = self.dataObject[@"text"];
    self.imageView.image = self.dataObject[@"image"];
}

@end
