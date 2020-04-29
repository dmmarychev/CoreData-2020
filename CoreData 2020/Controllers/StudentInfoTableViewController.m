//
//  StudentInfoTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/27/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "StudentInfoTableViewController.h"
#import "Student+CoreDataClass.h"
#import "StudentInfoTableViewCell.h"
#import "CoreDataManager.h"

@interface StudentInfoTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITextField *firstNameField;
@property (weak, nonatomic) UITextField *lastNameField;
@property (weak, nonatomic) UITextField *emailField;

@end


@implementation StudentInfoTableViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"Student info";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentInfoCell"];
    
    if (!cell) {
        cell = [[StudentInfoTableViewCell alloc] init];
    }
    
    if (indexPath.row == 0) {
        
        cell.leftLabel.text = @"First name";
        self.firstNameField = cell.rightTextField;
        
        self.student == nil ? cell.rightTextField.placeholder = @"Enter first name" : 0;
        self.student != nil ? cell.rightTextField.text = self.student.firstName : 0;
        
    } else if (indexPath.row == 1) {
        
        cell.leftLabel.text = @"Last name";
        self.lastNameField = cell.rightTextField;
        
        self.student == nil ? cell.rightTextField.placeholder = @"Enter last name" : 0;
        self.student != nil ? cell.rightTextField.text = self.student.lastName : 0;
        
    } else if (indexPath.row == 2) {
        
        cell.leftLabel.text = @"Email";
        self.emailField = cell.rightTextField;
        
        self.student == nil ? cell.rightTextField.placeholder = @"Enter email" : 0;
        self.student != nil ? cell.rightTextField.text = self.student.email : 0;
    }
    
    return cell;
}


#pragma mark - Actions

- (IBAction)saveStudentInfoAction:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
    
    Student *student = self.student == nil ? [NSEntityDescription insertNewObjectForEntityForName:@"Student"
                                                                           inManagedObjectContext:context] : self.student;

    student.firstName = self.firstNameField.text;
    student.lastName = self.lastNameField.text;
    student.email = self.emailField.text;
    
    [[CoreDataManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

@end
