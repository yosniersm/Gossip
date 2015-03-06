//
//  YOSEventssTableViewController.m
//  Gossip
//
//  Created by Yosnier on 23/02/15.
//  Copyright (c) 2015 YOS. All rights reserved.
//

#import "YOSEventsTableViewController.h"
#import "YOSCredential.h"
#import "YOSService.h"
#import "YOSPhotoContainer.h"
#import "YOSJSONObjectGitHub.h"
#import "YOSAuthViewController.h"
#import "YOSEventTableViewCell.h"
#import "YOSWebViewController.h"
#import "Settings.h"

@interface YOSEventsTableViewController ()


@end

@implementation YOSEventsTableViewController


#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Events";
}


-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(userDidChange:)
               name:NEW_USER_NOTIFICATION
             object:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.events = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self registerNibs];
    
    YOSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[YOSEventTableViewCell cellId] ];
    
    NSInteger dayDiferences = [self daysBetweenDate:self.events.date
                                            andDate:[NSDate date]];
    NSDateFormatter *df = [NSDateFormatter new];
    NSString *time;
    
    if (dayDiferences > 1) {
        df.dateFormat = @"dd/MM/yy";
        time = [NSString stringWithFormat:@"on %@",[df stringFromDate:self.events.date]];
        
    } else {
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"HH:mm";
        time = [NSString stringWithFormat:@"today at %@",[df stringFromDate:self.events.date]];
    }
    
    NSString *typeEvent = self.events.typeEvent;
    NSString *userTime;
    
    if ([typeEvent isEqualToString:@"PushEvent"]) {
        
        typeEvent = [NSString stringWithFormat:@"%@",[[self.events.detail componentsSeparatedByString:@"/"] objectAtIndex:1]];
        
        userTime = [NSString stringWithFormat:@"pushed by %@ %@",self.events.user.name,time];
        
    } else {
        typeEvent = @"New repository";
        userTime = [NSString stringWithFormat:@"created by %@ at %@",self.events.user.name,time];
        
    }
    
    cell.lblTypeEvent.text = typeEvent;
    cell.lblDescriptionEvent.text = self.events.name;
    cell.lblUserDate.text = userTime;
    cell.imvPhotoService.image = self.events.service.photo.image;
    cell.imvPhotoUser.image = self.events.user.photo.image;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.events = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSNotification *notify = [NSNotification notificationWithName:NEW_EVENT_SELECTED_NOTIFICATION
                                                           object:self
                                                         userInfo:@{KEY_URL:self.events.url}];
    [NSNotificationCenter.defaultCenter postNotification:notify];
    
    YOSWebViewController *webVC = [[YOSWebViewController alloc]initWithURL:self.events.url];

    [self.navigationController pushViewController:webVC
                                         animated:YES];
    
}

#pragma mark - Util

// cell Height
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YOSEventTableViewCell height];
}


//Register the cell in the bundle
- (void) registerNibs
{
    
    // Bundle
    NSBundle *main = [NSBundle mainBundle];
    
    // Register custom cell
    UINib *eventNib = [UINib nibWithNibName:@"YOSEventTableViewCell"
                                     bundle:main];
    
    [self.tableView registerNib:eventNib
         forCellReuseIdentifier:[YOSEventTableViewCell cellId]];
    
}



- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    return [difference day];
}


#pragma mark - AuthViewControllerDelegate

-(void) authViewController: (YOSAuthViewController *) sender fetchResultController: (NSFetchedResultsController *) aFrc
{
    self.fetchedResultsController = aFrc;

}



#pragma mark - SplitViewControllerDelegate


-(void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
    
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    } else {
         self.navigationItem.leftBarButtonItem = nil;
    }
}






#pragma mark - Notification

- (void) userDidChange:(NSNotification *) aNotification
{
    NSDictionary *dict = [aNotification userInfo];
    self.fetchedResultsController = [dict objectForKey:KEY];
    
}










@end
