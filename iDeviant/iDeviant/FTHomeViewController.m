//
//  FTHomeViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTDeviationsViewController.h"
#import "FTHomeCell.h"
#import "FTDownloader.h"
#import "FTFavorites.h"
#import "UIImageView+AFNetworking.h"
#import "NSArray+Tools.h"


@interface FTHomeViewController ()

@property (nonatomic, readonly) NSMutableArray *feedThumbs;
@property (nonatomic, readonly) NSMutableArray *feedData;

@property (nonatomic, readonly) NSTimer *thumbnailReloadTimer;

@end


@implementation FTHomeViewController


#pragma mark Data

- (void)fillData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Home" ofType:@"plist"];
    [super setData:[NSArray arrayWithContentsOfFile:path]];
    
    _feedThumbs = [NSMutableArray arrayWithCapacity:self.data.count];
    _feedData = [NSMutableArray arrayWithCapacity:self.data.count];
    int x = 0;
    for (NSDictionary *d in self.data) {
        [_feedThumbs addObject:[NSNull null]];
        [_feedData addObject:[NSNull null]];
        
        NSString *url = nil;
        if (![[d objectForKey:@"favorites"] boolValue]) {
            url = [FTDownloader urlStringForParams:[d objectForKey:@"basicQuery"] andFeedType:FTConfigFeedTypeNone];
        }
        else {
            FTConfigFeedType feedType = FTConfigFeedTypePopular;
            NSArray *arr = [FTFavorites favoritesForFeedType:feedType];
            if (arr.count == 0) {
                feedType = FTConfigFeedTypeTimeSorted;
                arr = [FTFavorites favoritesForFeedType:feedType];
            }
            if (arr.count == 0) {
                
            }
            else {
                NSDictionary *cat = [arr objectAtIndex:0];
                url = [FTDownloader urlStringForParams:@"in:photography/darkroom" andFeedType:feedType];
            }
            NSLog(@"Url for favorites: %@", url);
        }
        [FTDownloader downloadFileWithUrl:url withProgressBlock:^(CGFloat progress) {
            
        } andSuccessBlock:^(id data, NSError *error) {
            if (!error) {
                [FTMediaRSSParser parse:data withCompletionHandler:^(FTMediaRSSParserFeedInfo *info, NSArray *items, NSError *error) {
                    if (!error && items.count > 0) {
                        [_feedData replaceObjectAtIndex:x withObject:items];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:x inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                }];
            }
        }];
        x++;
    }
}

- (NSDictionary *)objectForIndexPath:(NSIndexPath *)indexPath {
    return [super.data objectAtIndex:indexPath.row];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super createTableView];
    [self createSearchBarWithSearchOptionTitles:@[FTLangGet(@"Popular"), FTLangGet(@"Newest")]];
    [self createSearchController];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"iDeviant")];
}

#pragma mark Thumbnail timer management

- (void)checkAndReloadThumbs {
    for (id feedObject in _feedData) {
        if ([feedObject isKindOfClass:[NSNull class]]) return;
    }
    [self fillData];
}

- (void)invalidateThumbnailTimer {
    if (_thumbnailReloadTimer) {
        [_thumbnailReloadTimer invalidate];
        _thumbnailReloadTimer = nil;
    }
}

- (void)setupThumbnailTimer {
    [self invalidateThumbnailTimer];
    _thumbnailReloadTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkAndReloadThumbs) userInfo:nil repeats:YES];
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupThumbnailTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidateThumbnailTimer];
}

#pragma mark Table view delegate & datasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) return 115;
    else return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (FTMediaRSSParserFeedItemThumbnail *)thumbnailForIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [_feedData objectAtIndex:indexPath.row];
    if (![arr isKindOfClass:[NSNull class]]) {
        for (FTMediaRSSParserFeedItem *item in arr) {
            if (item.thumbnails.count > 0) {
                //NSArray *revThumbs = [item.thumbnails reversedArray];
                return [item.thumbnails lastObject];
            }
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchController.searchResultsTableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else {
        static NSString *identifier = @"HomeCell";
        FTHomeCell *cell = (FTHomeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FTHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSDictionary *d = [self objectForIndexPath:indexPath];
        [cell.textLabel setText:FTLangGet([d objectForKey:@"name"])];
        [cell.detailTextLabel setText:FTLangGet([d objectForKey:@"description"]).lowercaseString];
        id imageObject = [_feedThumbs objectAtIndex:indexPath.row];
        UIImage *image = ([imageObject isKindOfClass:[NSNull class]] ? nil : imageObject);
        if (image == nil) {
            FTMediaRSSParserFeedItemThumbnail *thumb = [self thumbnailForIndexPath:indexPath];
            NSString *imageUrl = thumb.urlString;
            if (!imageUrl) {
                [cell.cellImageView setImage:[UIImage imageNamed:@"DA_default"]];
            }
            else {
                [cell.cellImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"DA_default"]];
            }
        }
        else [cell.cellImageView setImage:image];
        return cell;
    }
}

- (void)handlePresetControllerForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *d = [self.data objectAtIndex:indexPath.row];
    if ([d objectForKey:@"controller"]) {
        NSString *className = [d objectForKey:@"controller"];
        Class class = NSClassFromString(className);
        if (class) {
            FTViewController *c = (FTViewController *)[[class alloc] init];
            [c setHomeInfo:d];
            [c setTitle:FTLangGet([d objectForKey:@"name"])];
            if ([[d objectForKey:@"type"] isEqualToString:@"modal"]) {
                [c setNeedsCloseButton:YES];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
                [self presentViewController:nc animated:YES completion:^{
                    
                }];
            }
            else {
                [self.navigationController pushViewController:c animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchController.searchResultsTableView) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else {
        [self handlePresetControllerForIndexPath:indexPath];
    }
}

#pragma mark Feed config

- (FTConfigFeedType)feedType {
    return [[FTConfig sharedConfig] feedType];
}

- (void)reloadData {
    if (self.searchBar.text.length >= 3) {
        [super getDataForSearchString:self.searchBar.text];
    }
}


@end
