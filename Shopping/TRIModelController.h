//
//  TRIModelController.h
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 Trifork GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRIDataViewController;

@interface TRIModelController : NSObject <UIPageViewControllerDataSource>

- (TRIDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TRIDataViewController *)viewController;

@end
