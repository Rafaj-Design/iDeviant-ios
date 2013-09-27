//
//  FTDetailViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailViewController.h"
#import "FTDetailImageViewController.h"


@interface FTDetailViewController ()

@end


@implementation FTDetailViewController


#pragma mark Creating elements

- (void)createPageViewController {
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setDelegate:self];
    [_pageViewController setDataSource:self];
    
    [_pageViewController.view setFrame:self.view.bounds];
    
    [self.view setGestureRecognizers:_pageViewController.gestureRecognizers];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createPageViewController];
}

#pragma settings

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    FTDetailImageViewController *c = [[FTDetailImageViewController alloc] init];
    c.item = [_items objectAtIndex:_selectedIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:c];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
}

#pragma mark Page controller datasource & delegate methods

- (FTDetailBasicViewController *)detailControllerForIndex:(NSInteger)index {
    FTDetailImageViewController *c = [[FTDetailImageViewController alloc] init];
    [c setItem:[_items objectAtIndex:index]];
    return c;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [_items indexOfObject:[(FTDetailBasicViewController *)viewController item]];
    if(currentIndex == 0)  {
        return nil;
    }
    return [self detailControllerForIndex:(currentIndex - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [_items indexOfObject:[(FTDetailBasicViewController *)viewController item]];
    if(currentIndex == (_items.count - 1)) {
        return nil;
    }
    return [self detailControllerForIndex:(currentIndex + 1)];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = [_pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    [_pageViewController setDoubleSided:NO];
    return UIPageViewControllerSpineLocationMin;
}


@end
