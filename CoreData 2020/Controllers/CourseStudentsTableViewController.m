//
//  CourseStudentsTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/28/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "CourseStudentsTableViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Student+CoreDataClass.h"
#import "Course+CoreDataClass.h"
#import "CourseInfoTableViewController.h"

@interface CourseStudentsTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CourseStudentsTableViewController


#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    [self initializeFetchedResultsController];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Student *currentStudent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text =
    [NSString stringWithFormat:@"%@ %@", currentStudent.firstName, currentStudent.lastName];
    
    NSArray<Student *> *studentsOfCurrenCourse = [NSArray arrayWithArray:[self.course.students allObjects]];
    
    if ([studentsOfCurrenCourse containsObject:[self.fetchedResultsController objectAtIndexPath:indexPath]]) {
        
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
        
        [self.course addStudentsObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        
    } else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.course removeStudentsObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    
    [[CoreDataManager sharedManager] saveContext];
    [self.sourceController.tableView reloadData];
    
}


#pragma mark - NSFetchedResultsController

- (void)initializeFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
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
