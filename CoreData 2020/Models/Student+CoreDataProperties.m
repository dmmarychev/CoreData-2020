//
//  Student+CoreDataProperties.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/27/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic courses;

@end
