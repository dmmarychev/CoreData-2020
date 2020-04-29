//
//  TeachersTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "TeachersTableViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Teacher+CoreDataClass.h"
#import "TeacherInfoTableViewController.h"


@interface TeachersTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation TeachersTableViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    [self initializeFetchedResultsController];
}


#pragma mark - Actions

- (IBAction)editStudentsListButtonItemPressed:(UIBarButtonItem *)sender {
    
    sender.title = [sender.title isEqualToString:@"Edit"] ? @"Done" : @"Edit";
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Teacher *currentTeacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text =
    [NSString stringWithFormat:@"%@ %@", currentTeacher.firstName, currentTeacher.lastName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TeacherInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherInfoTableViewController"];
    
    vc.teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Teacher *currentTeacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.context deleteObject:currentTeacher];
    [[CoreDataManager sharedManager] saveContext];
}


#pragma mark - NSFetchedResultsController

- (void)initializeFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    
    [request setSortDescriptors:@[lastNameSort]];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

@end
