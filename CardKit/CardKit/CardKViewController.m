//
//  CKitViewController.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKViewController.h"
#import "CardKTextField.h"
#import "CardKCardView.h"
#import "CardKBankLogoView.h"
#import "CardKFooterView.h"
#import "CardKConfig.h"
#import "CardKSwitchView.h"
#import "CardKKindPaymentViewController.h"
#import "SeTokenGenerator.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKOwnerCellID = @"owner";
const NSString *CardKSwitchCellID = @"switch";
const NSString *CardKButtonCellID = @"button";
const NSString *CardKRows = @"rows";
const NSString *CardKSectionTitle = @"title";
NSString *CardKFooterID = @"footer";

@interface ScanViewWrapper: UIView

@property UIButton *backButton;

@end

@implementation ScanViewWrapper {
  UIView *_clippingView;
  UIView *_scanView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _clippingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _clippingView.clipsToBounds = YES;
    _clippingView.autoresizesSubviews = NO;
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_clippingView];
    [self addSubview:_backButton];
  }
  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  
  _clippingView.frame = self.bounds;
  _scanView.frame = self.bounds;
  [_scanView layoutSubviews];
  
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && _clippingView.frame.size.height > _clippingView.frame.size.width) {
    _clippingView.frame = CGRectMake(0, 0, _clippingView.frame.size.width, 300);
  }
  _scanView.center = CGPointMake(_clippingView.bounds.size.width * 0.5, _clippingView.bounds.size.height * 0.5);
  _backButton.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
  if (@available(iOS 11.0, *)) {
    if (self.safeAreaInsets.bottom > 0) {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 72 - self.safeAreaInsets.bottom);
    } else {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
    }
  } else {
    _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
  }
}

-(void)setScanView:(UIView *)scanView {
  _scanView = scanView;
  [_clippingView addSubview:scanView];
}


@end


@implementation CardKViewController {
  BOOL _allowSaveBinding;
  ScanViewWrapper *_scanViewWrapper;
  CardKBankLogoView *_bankLogoView;
  CardKTextField *_ownerTextField;
  CardKCardView *_cardView;
  UIButton *_doneButton;
  NSMutableArray *_sections;
  CardKFooterView *_cardFooterView;
  CardKFooterView *_ownerFooterView;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSString *_lastAnouncment;
  NSMutableArray *_ownerErrors;
  CardKSwitchView *_switchView;
  BOOL _displayCardHolderField;
}


- (instancetype)init {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];

    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }

    _ownerErrors = [[NSMutableArray alloc] init];

    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _languageBundle, @"Title");

    _cardView = [[CardKCardView alloc] init];
    [_cardView addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardView addTarget:self action:@selector(_switchToOwner) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_cardView.scanCardTapRecognizer addTarget:self action:@selector(_scanCard:)];

    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.placeholder = NSLocalizedStringFromTableInBundle(@"cardholderPlaceholder", nil, _languageBundle, @"Card holde placeholder");
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventEditingDidBegin];
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventValueChanged];
    [_ownerTextField addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _ownerTextField.stripRegexp = @"[^a-zA-Z' .]";
    _ownerTextField.tag = 30003;
      
    _ownerTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _ownerTextField.returnKeyType = UIReturnKeyContinue;

    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _doneButton.tag = 30005;
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _languageBundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);

    [_doneButton addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _switchView = [[CardKSwitchView alloc] init];
    _switchView.tag = 30004;
    _sections = [self _defaultSections];
  }
  
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
}

+(UIViewController *) create:(id<CardKDelegate>)cardKViewControllerDelegate controller:(CardKViewController *) controller {
  
  CardKKindPaymentViewController *cardKKindPaymentViewController = [[CardKKindPaymentViewController alloc] init];
  cardKKindPaymentViewController.cKitDelegate = cardKViewControllerDelegate;
  
  if ([CardKConfig.shared.bindings count] == 0) {
    return controller;
  }
  
  return cardKKindPaymentViewController;
}

- (NSMutableArray *)_defaultSections {
  NSArray *sections = @[
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"card", nil, _languageBundle, @"Card section title"), CardKRows: @[CardKCardCellID]},
    @{CardKRows: @[CardKButtonCellID]},
  ];
  
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithCapacity:3];
  
  [defaultSections setArray:sections];

  return defaultSections;
}

- (void)_animateError {
  [_doneButton animateError];
}

- (void)setDisplayCardHolderField:(BOOL)displayCardHolderField {
  if (displayCardHolderField) {
    [_sections insertObject:@{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"cardholder", nil, _languageBundle, @"Cardholder section title"), CardKRows: @[CardKOwnerCellID]} atIndex:1];
  }
  
  _displayCardHolderField = displayCardHolderField;
}

- (BOOL)displayCardHolderField {
  return _displayCardHolderField;
}

- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _cardView.allowedCardScaner = allowedCardScaner;
}

- (BOOL)allowedCardScaner {
  return _cardView.allowedCardScaner;
}

- (void)setAllowSaveBinding:(BOOL)allowSaveBinding {
  if (allowSaveBinding) {
    [_sections insertObject:@{CardKRows: @[CardKSwitchCellID]} atIndex:[_sections count] - 1];
  }
  _allowSaveBinding = allowSaveBinding;
}

- (BOOL)allowSaveBinding {
  return _allowSaveBinding;
}

- (void)setIsSaveBinding:(BOOL)isSaveBinding {
  _switchView.isSaveBinding = isSaveBinding;
}

- (BOOL)isSaveBinding {
  return self.isSaveBinding;
}

- (void)_cardChanged {
  NSString *number = _cardView.number;

  [_bankLogoView fetchBankInfo: CardKConfig.shared.mrBinApiURL cardNumber: number];
  [self _refreshErrors];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_cKitDelegate didLoadController:self];
  
  CardKTheme *theme = CardKConfig.shared.theme;
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);

  self.tableView.tableHeaderView = _bankLogoView;
  self.tableView.separatorColor = theme.colorSeparatar;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;

  UINavigationBar *bar = [self.navigationController navigationBar];
  bar.barTintColor = theme.colorCellBackground;
  
  _doneButton.tintColor = theme.colorButtonText;
      
  for (NSString *cellID in @[CardKCardCellID, CardKOwnerCellID, CardKButtonCellID, CardKSwitchCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect r = tableView.readableContentGuide.layoutFrame;
    cell.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, r.size.width, cell.contentView.bounds.size.height);
  
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";

  if ([CardKOwnerCellID isEqual:cellID]) {
    cell.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x - 6, 0, r.size.width, cell.contentView.bounds.size.height);
  }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    CGRect r = tableView.readableContentGuide.layoutFrame;
    UITableViewHeaderFooterView * v = (UITableViewHeaderFooterView *)view;
    v.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, v.contentView.bounds.size.width, v.contentView.bounds.size.height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self.tableView reloadData];
}

- (NSString *)purchaseButtonTitle {
  return _doneButton.currentTitle;
}

- (void)setPurchaseButtonTitle:(NSString *)purchaseButtonTitle {
  [_doneButton setTitle:purchaseButtonTitle forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGRect bounds = _doneButton.superview.bounds;
  _doneButton.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKRows] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return _sections[section][CardKSectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CardKTheme *theme = CardKConfig.shared.theme;
  
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
  
  if ([CardKCardCellID isEqual:cellID]) {
    _cardView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_cardView];
  } else if ([CardKOwnerCellID isEqual:cellID]) {
    _ownerTextField.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_ownerTextField];
  } else if ([CardKButtonCellID isEqual:cellID]) {
    [cell.contentView addSubview:_doneButton];
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    _switchView.frame = cell.contentView.bounds;
    cell.accessoryView = [_switchView getSwitch];
    [cell.contentView addSubview:_switchView];
  }
  
  if (theme.colorCellBackground != nil) {
    cell.backgroundColor = theme.colorCellBackground;
  }
  
  cell.textLabel.textColor = theme.colorLabel;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 38;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CardKFooterID];
  if (view == nil) {
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:CardKFooterID];
  }

  if(section == 0) {
    if (_cardFooterView == nil) {
      _cardFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
      
    }
    
    [view.contentView addSubview:_cardFooterView];
    view.contentView.frame = view.contentView.bounds; 
  } else if (section == 1) {
    if (_ownerFooterView == nil) {
      _ownerFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    }
    
    [view.contentView addSubview:_ownerFooterView];
  }

  return view;
}

- (void)_switchToOwner {
  [_ownerTextField becomeFirstResponder];
  [_cardView resetLeftImage];
}

- (void)_clearOwnerError {
  [_cardView resetLeftImage];
  [_ownerErrors removeAllObjects];
  _ownerTextField.showError = NO;
  [self _refreshErrors];
}

- (void)_validateOwner {
  [_ownerErrors removeAllObjects];
  _ownerTextField.showError = NO;
  
  if (!_displayCardHolderField) {
    [self _refreshErrors];
    return;
  }
  
  NSString *incorrectCardholder = NSLocalizedStringFromTableInBundle(@"incorrectCardholder", nil, _languageBundle, @"incorrectCardholder");
  
  NSString *owner = [_ownerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSInteger len = owner.length;
  if (len == 0 || len > 40) {
    _ownerTextField.showError = YES;
    [_ownerErrors addObject:incorrectCardholder];
  } else {
    NSString *str = [owner stringByReplacingOccurrencesOfString:_ownerTextField.stripRegexp withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, owner.length)];
    if (![str isEqual:owner]) {
      _ownerTextField.showError = YES;
      [_ownerErrors addObject:incorrectCardholder];
    }
  }
  
  [self _refreshErrors];
}

- (void)_refreshErrors {
  _cardFooterView.errorMessages = _cardView.errorMessages;
  _ownerFooterView.errorMessages = _ownerErrors;
  [self _announceError];
}

- (void)_announceError {
  NSString *errorMessage = [_cardView.errorMessages firstObject] ?: [_ownerErrors firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (BOOL)_isFormValid {
  [_cardView validate];
  [self _validateOwner];
  [self _refreshErrors];
  return _cardFooterView.errorMessages.count == 0 && _ownerErrors.count == 0;
}

- (void)_buttonPressed:(UIButton *)button {
  [_cardView resetLeftImage];
  if (![self _isFormValid]) {
    [self _animateError];
    _lastAnouncment = nil;
    [self _announceError];
    return;
  }
  
  NSString *seToken = [SeTokenGenerator generateSeTokenWithCardView:_cardView];
  
  [_cKitDelegate cardKitViewController:self didCreateSeToken:seToken allowSaveBinding: _switchView.getSwitch.isOn isNewCard: YES];
}

- (void)_scanCard:(UITapGestureRecognizer *)gestureRecognizer {
  if (_cardView.allowedCardScaner && _cardView.number.length != 0) {
    return;
  }
  
  [_cardView resignFirstResponder];
  [_ownerTextField resignFirstResponder];
  
  [_cKitDelegate cardKitViewControllerScanCardRequest:self];
}

- (CardKCardView *)getCardKView {
    return _cardView;
}

- (NSString *)getCardOwner {
    return _ownerTextField.text;
}

- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc bindingId:(nullable NSString *)bindingId {
  if (number.length > 0) {
    _cardView.number = number;
  }
  if (holderName.length > 0) {
    _ownerTextField.text = holderName;
  }
  
  if (date.length > 0) {
    _cardView.expirationDate = date;
  }
  
  if (cvc.length > 0) {
    _cardView.secureCode = cvc;
  }
  
  if (bindingId.length > 0) {
    _cardView.bindingId = bindingId;
  }
  
  [_scanViewWrapper removeFromSuperview];
}

- (void)showScanCardView:(UIView *)view animated:(BOOL)animated {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  _scanViewWrapper = [[ScanViewWrapper alloc] initWithFrame:self.view.bounds];
  _scanViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _scanViewWrapper.backgroundColor = theme.colorTableBackground;
  _scanViewWrapper.scanView = view;
  _scanViewWrapper.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
  [_scanViewWrapper.backButton
    setTitle: NSLocalizedStringFromTableInBundle(@"scanBackButton", nil, _languageBundle, "scanBackButton")
    forState:UIControlStateNormal
  ];
  
  [_scanViewWrapper.backButton addTarget:self action:@selector(_cancelScan) forControlEvents:UIControlEventTouchUpInside];
  
  _scanViewWrapper.alpha = 0;
  [self.view addSubview:_scanViewWrapper];
  
  [UIView animateWithDuration:0.4 animations:^{
    self->_scanViewWrapper.alpha = 1;
  }];
}

- (void)_cancelScan {
  _scanViewWrapper.alpha = 1;
  [UIView animateWithDuration:0.3 animations:^{
    self->_scanViewWrapper.alpha = 0;
  } completion:^(BOOL finished) {
    [self->_scanViewWrapper removeFromSuperview];
    self->_scanViewWrapper = nil;
  }];
}


@end
