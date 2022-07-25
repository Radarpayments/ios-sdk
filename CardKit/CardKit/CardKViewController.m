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
#import "CardKButtonView.h"

#import "CardKCardNumberTextField.h"
#import "CardKExpireDateTextField.h"
#import "CardKCVCTextField.h"
#import "CKCToken.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKBankLogoCellID = @"bankLogo";
const NSString *CardKCVCAndExpireDateCellID = @"cvcAndExpireDate";
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
  CardKCardNumberTextField *_cardNumberCell;
  CardKExpireDateTextField *_expireDateTextField;
  CardKCVCTextField *_cvcTextField;
  CardKTextField *_ownerTextField;
  UIButton *_doneButton;
  NSMutableArray *_sections;
  CardKFooterView *_cardFooterView;
  CardKFooterView *_ownerFooterView;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
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

    _cardNumberCell = [[CardKCardNumberTextField alloc] init];
    [_cardNumberCell addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardNumberCell addTarget:self action:@selector(_switchToExpireDate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_cardNumberCell.scanCardTapRecognizer addTarget:self action:@selector(_scanCard:)];

    _expireDateTextField = [[CardKExpireDateTextField alloc] init];
//    [_expireDateTextField addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_expireDateTextField addTarget:self action:@selector(_switchToSecureCode) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _cvcTextField = [[CardKCVCTextField alloc] init];
//    [_cvcTextField addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];


    _doneButton = [[CardKButtonView alloc] init];
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
    @{CardKRows: @[CardKBankLogoCellID]},
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"card", nil, _languageBundle, @"Card section title"), CardKRows: @[CardKCardCellID]},
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"cardholder", nil, _languageBundle, @"Cardholder section title"), CardKRows: @[CardKCVCAndExpireDateCellID]},
    @{CardKRows: @[CardKButtonCellID]},
  ];
  
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithCapacity:3];
  
  [defaultSections setArray:sections];

  return defaultSections;
}

- (void)_animateError {
  [_doneButton animateError];
}


- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _cardNumberCell.allowedCardScaner = allowedCardScaner;

}

- (BOOL)allowedCardScaner {
  return _cardNumberCell.allowedCardScaner;
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
  NSString *number = _cardNumberCell.number;
  [_bankLogoView fetchBankInfo: CardKConfig.shared.mrBinApiURL cardNumber: number];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_cKitDelegate didLoadController:self];
  
  CardKTheme *theme = CardKConfig.shared.theme;

  self.tableView.backgroundColor = CardKConfig.shared.theme.colorCellBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
  
  self.tableView.tableHeaderView.frame = CGRectMake(20, 0, 40, 40);

  UINavigationBar *bar = [self.navigationController navigationBar];
  bar.barTintColor = theme.colorCellBackground;
  
  for (NSString *cellID in @[CardKBankLogoCellID, CardKCardCellID, CardKCVCAndExpireDateCellID, CardKButtonCellID, CardKSwitchCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
  
  self.title = @"Payment";
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CardKTheme *theme = CardKConfig.shared.theme;
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

  if ([CardKSwitchCellID isEqual:cellID]) {
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  if ([CardKBankLogoCellID isEqual:cellID]) {
      _bankLogoView.frame = CGRectMake(20, 0, 40, 40);
      _bankLogoView.title = @"";
      
      [cell.contentView addSubview:_bankLogoView];
  } else if ([CardKCardCellID isEqual:cellID]) {
    _cardNumberCell.frame = CGRectMake(20, 0, cell.contentView.bounds.size.width - 40, cell.contentView.bounds.size.height);
    
    [cell.contentView addSubview:_cardNumberCell];
  } else if ([CardKCVCAndExpireDateCellID isEqual:cellID]) {
    NSInteger width = cell.contentView.bounds.size.width;
    NSInteger height = cell.contentView.bounds.size.height;
    
    UIView *expireView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, width / 2 - 40, height)];
    
    [expireView addSubview:_expireDateTextField];
    _expireDateTextField.frame = CGRectMake(0, 0, expireView.frame.size.width, height);
    [cell.contentView addSubview:expireView];
    
    UIView *cvcView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expireView.frame) + 20, 0, width / 2 - 20, height)];
    _cvcTextField.frame = CGRectMake(0, 0, cvcView.frame.size.width, height);
    [cvcView addSubview:_cvcTextField];
    [cell.contentView addSubview:cvcView];
  } else if ([CardKButtonCellID isEqual:cellID]) {
    _doneButton.frame = CGRectMake(20, 0, cell.contentView.bounds.size.width - 40, cell.contentView.bounds.size.height);
    [cell.contentView addSubview:_doneButton];
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    _switchView.frame = CGRectMake(20, 0, cell.contentView.bounds.size.width - 40, cell.contentView.bounds.size.height);
    
    cell.accessoryView = [_switchView getSwitch];
    [cell.contentView addSubview:_switchView];
  }
  
  if (theme.colorCellBackground != nil) {
    cell.backgroundColor = theme.colorCellBackground;
  }
  
  cell.textLabel.textColor = theme.colorLabel;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row];
  if ([CardKButtonCellID isEqual:cellID]) {
    return 50;
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    return 40;
  } else if ([CardKBankLogoCellID isEqual:cellID]) {
    return 40;
  }
  
  return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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

- (void)_switchToExpireDate {
  [_expireDateTextField becomeFirstResponder];
}

- (void)_switchToSecureCode {
  [_cvcTextField becomeFirstResponder];
}

- (BOOL)_isFormValid {
  return [_cardNumberCell validate] || [_cvcTextField validate] || [_expireDateTextField validate];
}

- (void)_buttonPressed:(UIButton *)button {
  if (![self _isFormValid]) {
    [self _animateError];
    return;
  }
  
  CKCCardParams *ckcCardParams = [[CKCCardParams alloc] init];

  ckcCardParams.pan = [_cardNumberCell number];
  ckcCardParams.cvc = _cvcTextField.secureCode;
  ckcCardParams.expiryMMYY = _expireDateTextField.expirationDate;
  ckcCardParams.mdOrder = CardKConfig.shared.mdOrder;
  ckcCardParams.pubKey = CardKConfig.shared.pubKey;


  CKCTokenResult *seToken = [CKCToken generateWithCard:ckcCardParams];

  [_cKitDelegate cardKitViewController:self didCreateSeToken:seToken.token allowSaveBinding: _switchView.getSwitch.isOn isNewCard: YES];
  
}

- (void)_scanCard:(UITapGestureRecognizer *)gestureRecognizer {
  if (_cardNumberCell.allowedCardScaner && _cardNumberCell.number.length != 0) {
    return;
  }
  
  [_cardNumberCell resignFirstResponder];
  
  [_cKitDelegate cardKitViewControllerScanCardRequest:self];
}

- (CardKCardView *)getCardKView {
  return [[CardKCardView alloc] init];
}

- (NSString *)getCardOwner {
    return @"";
}

- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc bindingId:(nullable NSString *)bindingId {
  if (holderName.length > 0) {
    _cardNumberCell.number = number;
  }
  
  if (date.length > 0) {
    _expireDateTextField.expirationDate = date;
  }
  
  if (cvc.length > 0) {
    _cvcTextField.secureCode = cvc;
  }
  
  if (bindingId.length > 0) {
    _cardNumberCell.bindingId = bindingId;
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
