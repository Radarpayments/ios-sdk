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

const NSString *CardKSavedCardsCellID = @"savedCards";
const NSString *CardKPayCardButtonCellID = @"button";
const NSString *CardKApplePayButtonCellID = @"applePay";
const NSString *CardKDividerCellID = @"divider";

const NSString *CardKKindPayRows = @"rows";

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
    _dividerView.title = @"Or pay by card";
    
    if (CardKConfig.shared.isEditBindingListMode) {
      _editModeButton = [[UIBarButtonItem alloc]
                         initWithTitle:NSLocalizedStringFromTableInBundle(@"edit", nil, _languageBundle, @"Edit")
                                     style: UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(_editMode:)];
      
      self.navigationItem.rightBarButtonItem = _editModeButton;
    }
    _isEditing = NO;
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

- (void)_editMode:(UIButton *)button {
  if (self.tableView.isEditing) {
    _isEditing = NO;
    [self.tableView setEditing:NO animated:YES];
    _editModeButton.title = NSLocalizedStringFromTableInBundle(@"edit", nil, _languageBundle, @"Edit");
    [self.cKitDelegate didRemoveBindings:_removedBindings];
    [self _disableRightBarButton];
  } else {
    _isEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    _editModeButton.title = NSLocalizedStringFromTableInBundle(@"save", nil, _languageBundle, @"Save");
  }
}

- (void)_disableRightBarButton {
  if (!_isEditing && [_currentBindings count] == 0) {
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (NSArray *)_defaultSections {
  NSMutableArray *bindings = [[NSMutableArray alloc] initWithArray:@[]];
  
  [bindings addObject:@{CardKPayCardButtonCellID: @[]}];
  [bindings addObject:@{CardKDividerCellID: @[]}];
  for (CardKBinding * binding in _currentBindings) {
    [bindings addObject:@{ CardKSavedCardsCellID: binding}];
  }
  
  
  return @[@{CardKKindPayRows: bindings}];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.tag = 40001;
  
  for (NSString *cellID in @[CardKSavedCardsCellID, CardKPayCardButtonCellID, CardKDividerCellID]) {
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;

  self.tableView.separatorColor = theme.colorSeparatar;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;

  UINavigationBar *bar = [self.navigationController navigationBar];
  bar.barTintColor = theme.colorCellBackground;

  _bankLogoView.frame = CGRectMake(self.view.bounds.size.width * 2, 0, 0, 0);
}


- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];
  
  NSInteger width = cell.contentView.frame.size.width;
  NSInteger boundWidth = cell.bounds.size.width;
  
  if([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBinding *cardKBinding = _sections[indexPath.section][CardKKindPayRows][indexPath.row][CardKSavedCardsCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BindingCellView * bindingCellView = [[BindingCellView alloc] init];
    bindingCellView.binding = cardKBinding;
    bindingCellView.showShortCardNumber = YES;
    
    [cell.contentView addSubview:bindingCellView];
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    _applePayButton.frame = CGRectMake(0, 0, width < 500 ? width : 500, 110);
    _applePayButton.center = CGPointMake(width * 0.5, 150 * 0.5);
      
    cell.separatorInset = UIEdgeInsetsMake(0.f, boundWidth, 0.f, 0.f);
    [cell.contentView addSubview:_applePayButton];
  } else if ([CardKDividerCellID isEqual:cellID]) {
    _dividerView.frame = CGRectMake(0, 0,  width - 40, 44);
    _dividerView.center = CGPointMake(width * 0.5, 44 * 0.5);

    cell.separatorInset = UIEdgeInsetsMake(0.f, boundWidth, 0.f, 0.f);
    [cell.contentView addSubview:_dividerView];
  }
   
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }

  return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  CGRect r = tableView.readableContentGuide.layoutFrame;

  if ([CardKSavedCardsCellID isEqual:cellID]) {
    cell.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, r.size.width - r.origin.x, cell.contentView.bounds.size.height);
  }
//  if ([CardKDividerCellID isEqual:cellID]) {
//    cell.contentView.frame = cell.bounds;
//  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  
  if ([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBindingViewController *cardKBindingViewController = [[CardKBindingViewController alloc] init];
    CardKBinding *cardKBinding = [[CardKBinding alloc] init];
    
    CardKBinding *selectedCardBinding = _sections[indexPath.section][CardKKindPayRows][indexPath.row][CardKSavedCardsCellID];
    
    cardKBinding.bindingId = selectedCardBinding.bindingId;
    cardKBinding.paymentSystem = selectedCardBinding.paymentSystem;
    cardKBinding.cardNumber = selectedCardBinding.cardNumber;
    cardKBinding.expireDate = selectedCardBinding.expireDate;

    cardKBindingViewController.cardKBinding = cardKBinding;
    cardKBindingViewController.bankLogoView = _bankLogoView;
    cardKBindingViewController.cKitDelegate = _cKitDelegate;
    
    [self.navigationController pushViewController:cardKBindingViewController animated:true];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return CardKConfig.shared.bindingsSectionTitle;
  }
  
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
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];

  if ([CardKPayCardButtonCellID isEqual:cellID] && self.verticalButtonsRendered) {
    return 150;
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
    return 100;
  }

  return 44;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];
  
  return [CardKSavedCardsCellID isEqual:cellID];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [[_sections[indexPath.section][CardKKindPayRows][indexPath.row] allKeys] firstObject];

  if (CardKConfig.shared.isEditBindingListMode && [CardKSavedCardsCellID isEqual:cellID]) {
    return YES;
  } else {
    return NO;
  }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_isEditing && editingStyle == UITableViewCellEditingStyleDelete) {
    [_removedBindings addObject: _currentBindings[indexPath.row]];
    [_currentBindings removeObjectAtIndex:indexPath.row];
    
  } else if (editingStyle == UITableViewCellEditingStyleDelete){
    [self.cKitDelegate didRemoveBindings:@[_currentBindings[indexPath.row]]];
    
    [_currentBindings removeObjectAtIndex:indexPath.row];
  }
  
  if ([_currentBindings count] != 0) {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else {
    _sections = @[@{CardKKindPayRows: @[@{CardKPayCardButtonCellID: @[]}]}];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
  }
  
  [self _disableRightBarButton];
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
