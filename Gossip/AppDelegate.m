//
//  AppDelegate.m
//  Gossip
//
//  Created by Yosnier on 17/02/15.
//  Copyright (c) 2015 YOS. All rights reserved.
//

#import "AppDelegate.h"
#import "YOSService.h"
#import "YOSCredential.h"
#import "YOSServicesTableViewController.h"
#import "YOSEventsTableViewController.h"
#import "AGTCoreDataStack.h"
#import "YOSPhotoContainer.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];
    
    [self createDummyData];
    
   // [self showData];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[YOSCredential entityName]];
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSCredentialAttributes.name
                                                          ascending:NO]];
    NSError *error;
    NSInteger numCredentials =[[self.stack.context executeFetchRequest:req
                                                                 error:&error] count];
    
    
    if ( numCredentials > 0 ) {
        [self loadEvents];
        
    } else {
        [self loadServices];
    }
    
       [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void) createDummyData {
    
    [self.stack zapAllData];
    
    YOSPhotoContainer  *photoGit = [YOSPhotoContainer  insertInManagedObjectContext:self.stack.context];
    
    photoGit.image = [UIImage imageNamed:@"octocat.png"];

    YOSService *gitHub = [YOSService serviceWithName:@"GitHub"
                                              detail:@"the nerd's facebook"
                                               photo: photoGit
                                             context:self.stack.context];
    
    
    YOSPhotoContainer  *photoGoogle = [YOSPhotoContainer  insertInManagedObjectContext:self.stack.context];
    photoGoogle.image = [UIImage imageNamed:@"googleDrive.png"];
    
    YOSService *google =  [YOSService serviceWithName:@"Google Drive"
                                               detail:@"Data store in the cloud 1"
                                                photo:photoGoogle
                                              context:self.stack.context];
    
    YOSPhotoContainer  *photoDropbox = [YOSPhotoContainer  insertInManagedObjectContext:self.stack.context];
     photoDropbox.image = [UIImage imageNamed:@"dropbox.png"];
    YOSService *dropbox  =  [YOSService serviceWithName:@"Dropbox"
                                                 detail:@"Data store in the cloud 2"
                                                  photo: photoDropbox
                                                context:self.stack.context];
    
    
}



-(void) showData {
    
    //Count Services
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[YOSService entityName]];
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSServiceAttributes.name
                                                          ascending:YES ]];
    NSError *err = nil;
    NSArray *services = [self.stack.context executeFetchRequest:req
                                                          error:&err];
    NSInteger numServices = [services count];
    
    // Count Credentials
    req = [NSFetchRequest fetchRequestWithEntityName:[YOSCredential entityName]];
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSCredentialAttributes.name
                                                          ascending:YES ]];
    
    NSArray *credentials = [self.stack.context executeFetchRequest:req
                                                             error:&err];
    NSInteger numCredentials = [credentials count];
    
    //Count events
    req = [NSFetchRequest fetchRequestWithEntityName:[YOSEvent entityName]];
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSEventAttributes.name
                                                          ascending:YES ]];
    
    NSArray *events = [self.stack.context executeFetchRequest:req
                                                        error:&err];
    NSInteger numEvents = [events count];
    
    
    printf("=========================================\n");
    printf("Number of services:        %lu\n", (unsigned long)numServices);
    printf("Number of credentials:        %lu\n", (unsigned long)numCredentials);
    printf("Number of events:            %lu\n", (unsigned long)numEvents);
    printf("========================================\n\n\n");
    
    
    NSLog(@"Services: %@",[services description]);
    NSLog(@"Services: %@",[events description]);
    
    [self performSelector:@selector(showData)
               withObject:nil
               afterDelay:5];
    
}



-(void) loadServices {
    
    
    NSFetchRequest *reqServices = [NSFetchRequest fetchRequestWithEntityName:[YOSService entityName]];
    
    reqServices.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSServiceAttributes.name
                                                                  ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:YOSServiceAttributes.detail
                                                                  ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:YOSServiceRelationships.photo
                                                                  ascending:NO]
                                    ];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:reqServices
                                                                          managedObjectContext:self.stack.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
    YOSServicesTableViewController *servicesTVC = [[YOSServicesTableViewController alloc] initWithFetchedResultsController:frc
                                                                                                                     style:UITableViewStylePlain];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:servicesTVC];
    
    self.window.rootViewController = navVC;
}


-(void) loadEvents {
    
    NSFetchRequest *reqEvents = [NSFetchRequest fetchRequestWithEntityName:[YOSEvent entityName]];
    reqEvents.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:YOSEventAttributes.typeEvent
                                                              ascending:YES],
                                  [NSSortDescriptor sortDescriptorWithKey:YOSEventAttributes.name
                                                                ascending:YES],
                                  [NSSortDescriptor sortDescriptorWithKey:YOSEventAttributes.detail
                                                                ascending:YES],
                                  [NSSortDescriptor sortDescriptorWithKey:YOSEventAttributes.url
                                                                ascending:YES],
                                  [NSSortDescriptor sortDescriptorWithKey:YOSEventRelationships.user
                                                                ascending:YES],
                                  [NSSortDescriptor sortDescriptorWithKey:YOSEventRelationships.service
                                                                ascending:YES]
                                  ];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:reqEvents
                                                                          managedObjectContext:self.stack.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
    YOSEventsTableViewController *eventsTVC = [[YOSEventsTableViewController alloc] initWithFetchedResultsController:frc
                                                                                                               style:UITableViewStylePlain];
    
    self.window.rootViewController = eventsTVC;
}


@end
