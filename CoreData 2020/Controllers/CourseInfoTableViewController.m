//
//  CourseInfoTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/28/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "CourseInfoTableViewController.h"
#import "Course+CoreDataClass.h"
#import "CourseInfoTableViewCell.h"
#import "CoreDataManager.h"
#import "Student+CoreDataClass.h"
#import "CourseStudentsTableViewController.h"
#import "StudentInfoTableViewController.h"
#import "Teacher+CoreDataClass.h"
#import "CourseTeacherTableViewController.h"

@interface CourseInfoTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) UITextField *courseNameField;
@property (weak, nonatomic) UITextField *subjectField;
@property (weak, nonatomic) UITextField *industryField;
@property (weak, nonatomic) UITextField *teacherFullNameField;

@property (assign, nonatomic) BOOL isNewCourse;
@property (assign, nonatomic) BOOL isNewCourseSaved;

@end


@implementation CourseInfoTableViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    if (self.course == nil) {
        self.isNewCourse = YES;
        self.course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.context];
    }
    
    [self initializeFetchedResultsController];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self isMovingFromParentViewController]) {
        
        if (self.isNewCourse && !self.isNewCourseSaved) {
            self.isNewCourse ? [self.context deleteObject:self.course] : 0;
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
        
    } else if (section == 1) {
     
        if (!self.course || (self.course && [self.course.students count] == 0)) {
       
            return 1;
            
        } else if (self.course && [self.course.students count] > 0) {
           

            return [[self.fetchedResultsController fetchedObjects] count] + 1;
        }
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? @"Course info" : @"Subscribed students";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseInfoCell"];
    
    if (!cell) {
        cell = [[CourseInfoTableViewCell alloc] init];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.leftLabel.text = @"Name";
            self.courseNameField = cell.rightTextField;
            
            self.course == nil ? cell.rightTextField.placeholder = @"Enter course name" : 0;
            self.course != nil ? cell.rightTextField.text = self.course.name : 0;
            
        } else if (indexPath.row == 1) {
            
            cell.leftLabel.text = @"Subject";
            self.subjectField = cell.rightTextField;
            
            self.course == nil ? cell.rightTextField.placeholder = @"Enter subject" : 0;
            self.course != nil ? cell.rightTextField.text = self.course.subject : 0;
            
        } else if (indexPath.row == 2) {
            
            cell.leftLabel.text = @"Industry";
            self.industryField = cell.rightTextField;
            
            self.course == nil ? cell.rightTextField.placeholder = @"Enter industry" : 0;
            self.course != nil ? cell.rightTextField.text = self.course.industry : 0;
            
        } else if (indexPath.row == 3) {
            
            UITableViewCell *teacherCell = [tableView dequeueReusableCellWithIdentifier:@"teacherCell"];
            
            teacherCell.textLabel.text = @"Teacher";
            
            if (self.course.teacher != nil) {
                
                Teacher *currentTeacher = self.course.teacher;
                teacherCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", currentTeacher.firstName, currentTeacher.lastName];
            } else {
                teacherCell.detailTextLabel.textColor = [UIColor colorWithRed:0.f green:122.f/255.f blue:1.f alpha:1.f];
                teacherCell.detailTextLabel.text = @"Choose teacher";
            }
            
            return teacherCell;
        }
    } else if (indexPath.section == 1) {
        
        if (!self.course ||
            (self.course && [self.course.students count] == 0) ||
            ([self.course.students count] > 0 && indexPath.row == [self.course.students count])) {
            
            return [tableView dequeueReusableCellWithIdentifier:@"selectStudentsCell"];
            
        } else {
            
            Student *currentStudent = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            
            UITableViewCell *studentCell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
            
            if (!studentCell) {
                studentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"studentCell"];
            }
            
            studentCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentStudent.firstName, currentStudent.lastName];
            studentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return studentCell;
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 && indexPath.row != 3 ? NO : YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell.reuseIdentifier isEqualToString:@"studentCell"]) {
        
        StudentInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInfoTableViewController"];

        NSArray<Student *> *students = [NSArray arrayWithArray:[self.course.students allObjects]];
        Student *currentStudent = [students objectAtIndex:indexPath.row];
        vc.student = currentStudent;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if ([selectedCell.reuseIdentifier isEqualToString:@"teacherCell"]) {
        
        CourseTeacherTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseTeacherTableViewController"];
        vc.course = self.course;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Actions

- (IBAction)saveCourseInfoAction:(UIBarButtonItem *)sender {
    
    if (![self isFieldsNotEmpty]) {
        
        [self showEmptyFieldsAlert];
        
    } else {
        
        self.course.name = self.courseNameField.text;
        self.course.subject = self.subjectField.text;
        self.course.industry = self.industryField.text;
        
        [[CoreDataManager sharedManager] saveContext];
        
        self.isNewCourseSaved = YES;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if (![self isFieldsNotEmpty]) {
        
        [self showEmptyFieldsAlert];
        
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"selectStudentsSegue"]) {
        
        CourseStudentsTableViewController *vc = segue.destinationViewController;
        vc.sourceController = self;
        
        self.course.name = self.courseNameField.text;
        self.course.subject = self.subjectField.text;
        self.course.industry = self.industryField.text;
        
        vc.course = self.course;
    }
}

#pragma mark - Validation

- (BOOL)isFieldsNotEmpty {
    
    if ([self.courseNameField.text isEqualToString:@""] ||
        [self.subjectField.text isEqualToString:@""] ||
        [self.industryField.text isEqualToString:@""]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Alerts

- (void)showEmptyFieldsAlert {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"All fields is required. Fill all fields to save"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - NSFetchedResultsController

- (void)initializeFetchedResultsController {
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"courses contains %@", self.course];
    
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    
    [request setSortDescriptors:@[nameSort]];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSLog(@"%@", self.fetchedResultsController.fetchedObjects);
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end
