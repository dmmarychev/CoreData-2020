//
//  Teacher+CoreDataProperties.m
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic courses;

@end
