//
//  CourseTeacherTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "CourseTeacherTableViewController.h"
#import "TeacherInfoTableViewController.h"
#import "Teacher+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Course+CoreDataClass.h"

@interface CourseTeacherTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CourseTeacherTableViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    [self initializeFetchedResultsController];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Teacher *currentTeacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text =
    [NSString stringWithFormat:@"%@ %@", currentTeacher.firstName, currentTeacher.lastName];
    
    if ([[self.fetchedResultsController objectAtIndexPath:indexPath] isEqual:self.course.teacher]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
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
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
        
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.course.teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [[CoreDataManager sharedManager] saveContext];
    [self.sourceController.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - NSFetchedResultsController

- (void)initializeFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[lastNameSort]];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

@end
