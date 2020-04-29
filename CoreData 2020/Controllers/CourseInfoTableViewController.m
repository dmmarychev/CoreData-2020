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

@interface CourseInfoTableViewController ()

@property (weak, nonatomic) UITextField *courseNameField;
@property (weak, nonatomic) UITextField *subjectField;
@property (weak, nonatomic) UITextField *industryField;
@property (weak, nonatomic) UITextField *teacherFullNameField;

@end

@implementation CourseInfoTableViewController

- (void)viewDidLoad {

    [super viewDidLoad];
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
        
            return [self.course.students count] + 1;
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
            
            cell.leftLabel.text = @"Teacher";
            self.teacherFullNameField = cell.rightTextField;
            
            self.course == nil ? cell.rightTextField.placeholder = @"Enter teacher full name" : 0;
            self.course != nil ? cell.rightTextField.text = self.course.teacherFullName : 0;
        }
    } else if (indexPath.section == 1) {
        
        if (!self.course ||
            (self.course && [self.course.students count] == 0) ||
            ([self.course.students count] > 0 && indexPath.row == [self.course.students count])) {
            
            return [tableView dequeueReusableCellWithIdentifier:@"selectStudentsCell"];
            
        } else {
            
            NSArray<Student *> *students = [NSArray arrayWithArray:[self.course.students allObjects]];
            
            Student *currentStudent = [students objectAtIndex:indexPath.row];
            
            UITableViewCell *studentCell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
            studentCell.textLabel.text =
            [NSString stringWithFormat:@"%@ %@", currentStudent.firstName, currentStudent.lastName];
            studentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return studentCell;
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? NO : YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell.reuseIdentifier isEqualToString:@"studentCell"]) {
        
        NSArray<Student *> *students = [NSArray arrayWithArray:[self.course.students allObjects]];
        
        Student *currentStudent = [students objectAtIndex:indexPath.row];
        
        StudentInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInfoTableViewController"];
        vc.student = currentStudent;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Actions

- (IBAction)saveCourseInfoAction:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    Course *course = self.course == nil ? [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                                                        inManagedObjectContext:context] : self.course;
    
    course.name = self.courseNameField.text;
    course.subject = self.subjectField.text;
    course.industry = self.industryField.text;
    course.teacherFullName = self.teacherFullNameField.text;
    
    [[CoreDataManager sharedManager] saveContext];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"selectStudentsSegue"]) {
        
        CourseStudentsTableViewController *vc = segue.destinationViewController;
        vc.course = self.course;
        vc.sourceController = self;
    }
}

@end
