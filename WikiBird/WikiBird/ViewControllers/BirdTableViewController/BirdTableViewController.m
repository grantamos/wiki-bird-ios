//
//  BirdTableViewController.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "BirdTableViewController.h"
#import "Bird.h"

#define CELL_IDENTIFIER @"BirdCell"

@implementation BirdTableViewController

- (void)viewDidLoad
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self performFetch];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bird"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"commonName" ascending:YES]];
    
    return fetchRequest;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bird *bird = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = bird.commonName;
    
    //cell.imageView setImage:[UIImage imageWithData:];
}

@end
