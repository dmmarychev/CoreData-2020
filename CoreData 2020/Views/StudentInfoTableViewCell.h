//
//  StudentInfoTableViewCell.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/27/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;


@end

NS_ASSUME_NONNULL_END
