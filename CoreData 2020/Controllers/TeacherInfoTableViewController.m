//
//  TeacherInfoTableViewController.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import "TeacherInfoTableViewController.h"
#import "Teacher+CoreDataClass.h"
#import "TeacherTableViewCell.h"
#import "CoreDataManager.h"

@interface TeacherInfoTableViewController ()

@property (weak, nonatomic) UITextField *firstNameField;
@property (weak, nonatomic) UITextField *lastNameField;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation TeacherInfoTableViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[[CoreDataManager sharedManager] persistentContainer] viewContext];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Teacher info";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherInfoCell"];
    
    if (!cell) {
        cell = [[TeacherTableViewCell alloc] init];
    }
    
    if (indexPath.row == 0) {
        
        cell.leftLabel.text = @"First name";
        self.firstNameField = cell.rightTextField;
        
        self.teacher == nil ? cell.rightTextField.placeholder = @"Enter first name" : 0;
        self.teacher != nil ? cell.rightTextField.text = self.teacher.firstName : 0;
        
    } else if (indexPath.row == 1) {
        
        cell.leftLabel.text = @"Last name";
        self.lastNameField = cell.rightTextField;
        
        self.teacher == nil ? cell.rightTextField.placeholder = @"Enter last name" : 0;
        self.teacher != nil ? cell.rightTextField.text = self.teacher.lastName : 0;
        
    }
    
    return cell;
}


#pragma mark - Actions

- (IBAction)saveStudentInfoAction:(UIBarButtonItem *)sender {
    
    Teacher *teacher = self.teacher == nil ? [NSEntityDescription insertNewObjectForEntityForName:@"Teacher"
                                                                           inManagedObjectContext:self.context] : self.teacher;
    
    teacher.firstName = self.firstNameField.text;
    teacher.lastName = self.lastNameField.text;
    
    [[CoreDataManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

@end
