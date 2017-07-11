//
//  AnimationsTableViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/30.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "AnimationsTableViewController.h"
#import "UITableView+Scroll.h"
#import "UIViewController+NIB.h"

#import "ElasticAnimationViewController.h"
#import "ProgressAnimViewController.h"
#import "CuteViewController.h"
#import "FrameScaleViewController.h"

@interface AnimationsTableViewController ()

@end

@implementation AnimationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animation & View";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView clearEmptyCells];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"animCell"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelf)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [super dismissSelf];
}

# pragma mark - set & get

- (NSArray *)animsArray {
    return @[@"Elastic Animation View", @"Cute View", @"Progress Animation View", @"Frame Scale", @"UI - 动画5",
             @"UI - 动画6", @"UI - 动画7", @"UI - 动画8", @"UI - 动画9", @"UI - 动画10"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [self animsArray][indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    switch (indexPath.row) {
        case 0: {
            ElasticAnimationViewController *elasticVC = [[ElasticAnimationViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:elasticVC animated:YES];
        }
            break;
        case 1 : {
            CuteViewController *cuteVC = [[CuteViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:cuteVC animated:YES];
        }
            break;
        case 2 : {
            ProgressAnimViewController *progressVC = [[ProgressAnimViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:progressVC animated:YES];
        }
            break;
        case 3 : {
            FrameScaleViewController *frameVC = [[FrameScaleViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:frameVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
