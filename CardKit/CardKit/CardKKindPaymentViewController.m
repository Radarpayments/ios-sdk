//
//  UITableViewController+CardKKindPaymentViewController.m
//  CardKit
//
//  Created by Alex Korotkov on 5/13/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "CardKKindPaymentViewController.h"
#import "CardKViewController.h"
#import "CardKConfig.h"
#import "CardKBinding.h"
#import "CardKBindingViewController.h"
#import "CardKBankLogoView.h"
#import "CardKPaymentView.h"
#import "PaymentSystemProvider.h"
#import "CardKApplePayButtonView.h"
#import "DividerView.h"
#import "BindingCellView.h"
#import "NewCardCellView.h"
#import "CardKAllPaymentMethodsController.h"

#import "Constants.h"

@implementation CardKKindPaymentViewController {
  UIButton *_button;
  CardKApplePayButtonView *_applePayButton;
  UIBarButtonItem *_editModeButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  CardKBankLogoView *_bankLogoView;
  NSMutableArray *_removedBindings;
  NSMutableArray *_currentBindings;
  BOOL _isEditing;
  id<CardKDelegate> _cKitDelegate;
  DividerView *_dividerView;
  NewCardCellView *_newCardCellView;
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKKindPaymentViewController class]];
    _removedBindings = [[NSMutableArray alloc] init];
    _currentBindings = [[NSMutableArray alloc] initWithArray:CardKConfig.shared.bindings];
    
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _sections = [self _defaultSections];
    
    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _languageBundle, @"Title");

    _dividerView = [[DividerView alloc] init];
    _dividerView.title = NSLocalizedStringFromTableInBundle(@"payByCard", nil, _languageBundle, @"payByCard");;
    
    _newCardCellView = [[NewCardCellView alloc] init];
  }
  return self;
}

- (void)setCKitDelegate:(id<CardKDelegate>)cKitDelegate {
  _applePayButton = [[CardKApplePayButtonView alloc] initWithDelegate: cKitDelegate];

  _applePayButton.paymentButtonStyle = PKPaymentButtonStyleWhiteOutline;
  
  _applePayButton.cardKPaymentViewDelegate = self;
  _applePayButton.controller = self;
  _cKitDelegate = cKitDelegate;
}

- (id<CardKDelegate>)cKitDelegate {
  return _cKitDelegate;
}

- (NSArray *)_defaultSections {
  NSMutableArray *bindings = [[NSMutableArray alloc] initWithArray:@[]];
  
  [bindings addObject:@{CardKPayCardButtonCellID: @[]}];
  [bindings addObject:@{CardKDividerCellID: @[]}];
  for (CardKBinding * binding in _currentBindings) {
    BindingCellView *cellBinding = [[BindingCellView alloc] init];
    cellBinding.binding = binding;
    cellBinding.showShortCardNumber = YES;
    [bindings addObject:@{ CardKSavedCardsCellID: cellBinding}];
  }
  
  [bindings addObject:@{NewCardCellID: @[]}];
  [bindings addObject:@{AllPaymentMethodsCellID: @[]}];
  
  
  return @[@{CardKRows: bindings}];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.tag = 40001;
  
  for (NSString *cellID in @[CardKSavedCardsCellID, CardKPayCardButtonCellID, CardKDividerCellID, NewCardCellID, AllPaymentMethodsCellID]) {
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;
  self.tableView.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
  [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
//  UINavigationBar *bar = [self.navigationController navigationBar];
//  bar.barTintColor = theme.colorLabel;
//  [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
  
  _bankLogoView.frame = CGRectMake(self.view.bounds.size.width * 2, 0, 0, 0);
  
//  self.navigationController.navigationBar.tintColor = CardKConfig.shared.theme.colorLabel;
//  self.navigationController.
}


- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];
  
  NSInteger width = cell.contentView.frame.size.width;
  NSInteger boundWidth = cell.bounds.size.width;
  
  if([CardKSavedCardsCellID isEqual:cellID]) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = cell.contentView.frame;
    [cell.contentView addSubview:bindingCellView];
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    _applePayButton.frame = CGRectMake(0, 0, width < 500 ? width : 500, 110);
    _applePayButton.center = CGPointMake(width * 0.5, 150 * 0.5);
      
    cell.separatorInset = UIEdgeInsetsMake(0.f, boundWidth, 0.f, 0.f);
    [cell.contentView addSubview:_applePayButton];
  } else if ([CardKDividerCellID isEqual:cellID]) {
    _dividerView.frame = CGRectMake(0, 0,  width - 40, 56);
    _dividerView.center = CGPointMake(width * 0.5, 56 * 0.5);

    cell.separatorInset = UIEdgeInsetsMake(0.f, boundWidth, 0.f, 0.f);
    [cell.contentView addSubview:_dividerView];
  } else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = cell.contentView.frame;
    [cell.contentView addSubview:_newCardCellView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else if ([AllPaymentMethodsCellID isEqual:cellID]) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"allPaymentMethods", nil, _languageBundle, @"allPaymentMethods");
    cell.textLabel.textColor = CardKConfig.shared.theme.colorLabel;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
  }
   
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }
  

  return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  if([CardKSavedCardsCellID isEqual:cellID]) {
    BindingCellView *bindingCellView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    bindingCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:bindingCellView];
    
  }  else if ([NewCardCellID isEqual:cellID]) {
    _newCardCellView.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 20, cell.contentView.frame.size.height);
    [cell.contentView addSubview:_newCardCellView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  if ([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBindingViewController *cardKBindingViewController = [[CardKBindingViewController alloc] init];
    
    BindingCellView *selectedBindingView = _sections[indexPath.section][CardKRows][indexPath.row][CardKSavedCardsCellID];
    
    cardKBindingViewController.cardKBinding = selectedBindingView.binding;
    cardKBindingViewController.bankLogoView = _bankLogoView;
    cardKBindingViewController.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:cardKBindingViewController animated:true];
  } else if ([NewCardCellID isEqual:cellID]) {
    CardKViewController *controller = [[CardKViewController alloc] init];
    controller.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:controller animated:YES];
  } else if ([AllPaymentMethodsCellID isEqual:cellID]) {
    CardKAllPaymentMethodsController *controller = [[CardKAllPaymentMethodsController alloc] init];
    controller.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"";
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
   [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
   [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];

  if ([CardKPayCardButtonCellID isEqual:cellID] && self.verticalButtonsRendered) {
    return 150;
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    return 100;
  }

  return 56;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];
  
  return [CardKSavedCardsCellID isEqual:cellID] || [NewCardCellID isEqual:cellID] || [AllPaymentMethodsCellID isEqual:cellID];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKRows][indexPath.row] allKeys] firstObject];

  if (CardKConfig.shared.isEditBindingListMode && [CardKSavedCardsCellID isEqual:cellID]) {
    return YES;
  } else {
    return NO;
  }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (void)pressedCardPayButton {
  CardKViewController *controller = [[CardKViewController alloc] init];
  controller.cKitDelegate = _cKitDelegate;
  
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)pressedApplePayButton:(PKPaymentAuthorizationViewController *) authController {
  [self.navigationController presentViewController:authController animated:YES completion:nil];
}
@end
