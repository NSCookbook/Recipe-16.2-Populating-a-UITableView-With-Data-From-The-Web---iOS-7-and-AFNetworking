//
//  TableViewController.m
//  WebTableView
//
//  Created by joseph hoffman on 12/23/13.
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *googlePlacesArrayFromAFNetworking;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self makeRestuarantRequests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeRestuarantRequests
{
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=restuarants+in+sydney&sensor=false&key=AIzaSyDfdpFcPFSr-0lTaxsyia84VU0VAsgEt1c"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
        
        NSLog(@"The Array: %@",self.googlePlacesArrayFromAFNetworking);
        
        [self.tableView reloadData];
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.googlePlacesArrayFromAFNetworking count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    
    if([tempDictionary objectForKey:@"rating"] != NULL)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5",[tempDictionary   objectForKey:@"rating"]];
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Not Rated"];
    }
    
    return cell;
}


#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ViewController *detailViewController = (ViewController *)segue.destinationViewController;
    detailViewController.restuarantDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
}

@end
