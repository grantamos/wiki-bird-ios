//
//  BirdTableViewController.m
//  WikiBird
//
//  Created by Amos, Grant ext (E IT S MCC) on 6/30/14.
//  Copyright (c) 2014 Grant Amos. All rights reserved.
//

#import "BirdTableViewController.h"
#import "Bird.h"
#import "BirdImage.h"
#import "BirdTableViewCell.h"

#define CELL_IDENTIFIER @"BirdCell"

@implementation BirdTableViewController

- (void)viewDidLoad
{
    UINib *nib = [UINib nibWithNibName:@"BirdTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(BirdTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bird *bird = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.commonNameLabel.text = bird.commonName;
    
    NSSet *goodImages = [bird.images filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"image != nil"]];
    
    if ([goodImages count] == 0)
        return;
    
    NSData *imageData = ((BirdImage*)[goodImages anyObject]).image;
    
    [cell.backgroundImageView setImage:[UIImage imageWithData:imageData]];
    NSLog(@"%@", NSStringFromCGRect(cell.backgroundImageView.frame));
    NSLog(@"%@", NSStringFromCGRect(cell.bounds));
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.width / 2;
}

@end
