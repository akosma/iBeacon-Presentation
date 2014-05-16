//
//  TRIRootViewController.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 Trifork GmbH. All rights reserved.
//

#import "TRIRootViewController.h"
#import "TRIModelController.h"
#import "TRIDataViewController.h"

@interface TRIRootViewController ()

@property (strong, nonatomic) TRIModelController *modelController;
@property (nonatomic) NSInteger currentPage;

@end



@implementation TRIRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;

    TRIDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0
                                                                                     storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.dataSource = self.modelController;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    [self.pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    
    self.currentPage = 0;
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:@"NEW_BEACONS"
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        NSInteger selected = [[notification userInfo][@"minor"] intValue];
                        // Show the corresponding data
                        UIViewController *page = [self.modelController viewControllerAtIndex:selected
                                                                                  storyboard:self.storyboard];
                        
                        if (page != nil && self.currentPage != selected)
                        {
                            self.currentPage = selected;
                            __weak UIPageViewController* pvc = self.pageViewController;
                            [pvc setViewControllers:@[page]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES completion:^(BOOL finished) {
                                               UIPageViewController* pvcs = pvc;
                                               if (!pvcs) return;
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [pvcs setViewControllers:@[page]
                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                   animated:NO completion:nil];
                                               });
                                           }];
                        }
                    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (TRIModelController *)modelController
{
    if (!_modelController)
    {
        _modelController = [[TRIModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController *currentViewController = self.pageViewController.viewControllers[self.currentPage];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end
