//
//  TRIModelController.m
//  Shopping
//
//  Created by Adrian on 16/05/14.
//  Copyright (c) 2014 Trifork GmbH. All rights reserved.
//

#import "TRIModelController.h"

#import "TRIDataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface TRIModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation TRIModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        _pageData = @[
                      @{
                          @"title": @"MacBook Pro 13\" Retina",
                          @"text": @"Apple released the third generation of MacBook Pro in June 2012 as a 15-inch screen size only. At the same time, slightly updated versions of the previous 13- and 15-inch unibody models were announced that will sell in parallel. While dimensionally smaller than its predecessor, the similarly styled third generation model still retains a unibody form factor. Specification-wise, the most substantial differences in the next-generation MacBook Pro are the fitting of a significantly higher resolution Retina display, the elimination of the optical drive, and replacement of hard disk drives with solid-state drives. A third generation 13-inch MacBook Pro was released on October 23, 2012. As with the 15-inch, it includes a Retina display.",
                          @"image": [UIImage imageNamed:@"mbp13_retina_image"]
                          },
                      @{
                          @"title": @"Raspberry Pi Model B",
                          @"text": @"The Raspberry Pi is a credit-card-sized single-board computer developed in the UK by the Raspberry Pi Foundation with the intention of promoting the teaching of basic computer science in schools. The Raspberry Pi is manufactured in two board configurations through licensed manufacturing deals with Newark element14 (Premier Farnell), RS Components and Egoman. These companies sell the Raspberry Pi online. Egoman produces a version for distribution solely in China and Taiwan, which can be distinguished from other Pis by their red coloring and lack of FCC/CE marks. The hardware is the same across all manufacturers. The Raspberry Pi has a Broadcom BCM2835 system on a chip (SoC), which includes an ARM1176JZF-S 700 MHz processor, VideoCore IV GPU,[12] and was originally shipped with 256 megabytes of RAM, later upgraded to 512 MB. It does not include a built-in hard disk or solid-state drive, but it uses an SD card for booting and persistent storage.",
                          @"image": [UIImage imageNamed:@"RaspberryPi"]
                          },
                      @{
                          @"title": @"iPad Air",
                          @"text": @"The iPad Air is the fifth generation iPad. Unveiled during a keynote on October 22, 2013, the iPad Air features the 64-bit Apple A7 processor along with a M7 coprocessor. The iPad Air marks the first major design change for the iPad since the iPad 2; it now features a thinner design that is 7.5 millimetres thick and has a smaller screen bezel similar to the iPad mini. Apple reduced the overall volume for the iPad Air by using thinner components resulting in a 25% reduction in weight over the iPad 2. Though it still uses the same 9.7-inch Retina display as the previous iPad model, an improved front-facing camera makes using FaceTime much clearer. The new front facing camera is capable of video in 720p HD, includes face detection, and backside illumination. The rear camera received an upgrade as well; now being called the iSight camera, in addition to the same functions as the front camera it also contains a 5MP CCD, hybrid IR filter and a fixed ƒ/2.4 aperture.",
                          @"image": [UIImage imageNamed:@"ipad_air_image"]
                          }
                      ];
    }
    return self;
}

- (TRIDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TRIDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"TRIDataViewController"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(TRIDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(TRIDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(TRIDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
