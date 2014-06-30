//
//  BirdGroupTableViewController.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/27/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "BirdGroupTableViewController.h"
#import "BirdGroup.h"
#import "BirdTableViewController.h"

#define CELL_IDENTIFIER @"BirdGroupCell"

@implementation BirdGroupTableViewController

- (void)viewDidLoad
{
    [self setTitle:@"Bird Groups"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self performFetch];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BirdGroup"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return fetchRequest;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BirdGroup *birdGroup = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = birdGroup.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BirdTableViewController *birdVC = [BirdTableViewController new];
    
    [self.navigationController pushViewController:birdVC animated:YES];
}

@end
