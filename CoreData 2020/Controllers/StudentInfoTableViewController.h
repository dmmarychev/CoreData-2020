//
//  StudentInfoTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/27/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Student;

@interface StudentInfoTableViewController : UITableViewController

@property (strong, nonatomic) Student *student;

@end

NS_ASSUME_NONNULL_END
