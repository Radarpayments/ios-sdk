//
//  UITableViewController+ConfirmChoosedCard.m
//  CardKit
//
//  Created by Alex Korotkov on 5/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBindingViewController.h"
#import "CardKTextField.h"
#import "CardKCardView.h"
#import "CardKBankLogoView.h"
#import "CardKConfig.h"
#import "CardKSwitchView.h"
#import "CardKKindPaymentViewController.h"
#import "CardKButtonView.h"

#import "CardKCardNumberTextField.h"
#import "CardKExpireDateTextField.h"
#import "CardKCVCTextField.h"
#import <CardKitCore/CKCToken.h>

#import "CardKBinding.h"
#import "BindingCellView.h"
#import "VerifyCompaniesView.h"

#import "Constants.h"
#import "Logger.h"

@implementation CardKBindingViewController {
  CardKBankLogoView *_bankLogoView;
  CardKCardNumberTextField *_cardNumberCell;
  CardKExpireDateTextField *_expireDateTextField;
  CardKCVCTextField *_cvcTextField;
  UIButton *_doneButton;
  NSMutableArray *_sections;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  VerifyCompaniesView *_verifyCompanies;
}
- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];

    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }

    _bankLogoView = [[CardKBankLogoView alloc] init];

    _cardNumberCell = [[CardKCardNumberTextField alloc] init];
    
    _expireDateTextField = [[CardKExpireDateTextField alloc] init];
    
    _cvcTextField = [[CardKCVCTextField alloc] init];


    _doneButton = [[CardKButtonView alloc] init];
    _doneButton.tag = 30005;
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _languageBundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);

    [_doneButton addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _sections = [self _defaultSections];
    
  self.tableView.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
  self.view.backgroundColor = CardKConfig.shared.theme.colorTableBackground;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
}


- (NSMutableArray *)_defaultSections {
  NSArray *sections = @[
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

- (void)_cardChanged {
  NSString *number = _cardNumberCell.number;
  [_bankLogoView fetchBankInfo: CardKConfig.shared.mrBinApiURL cardNumber: number];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_cKitDelegate didLoadController:self];
  
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
  
  self.tableView.tableHeaderView.frame = CGRectMake(20, 0, 40, 40);
  
  for (NSString *cellID in @[CardKBankLogoCellID, CardKCardCellID, CardKCVCAndExpireDateCellID, CardKButtonCellID, CardKSwitchCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
  
  self.title = NSLocalizedStringFromTableInBundle(@"payment", nil, _languageBundle, "payment");
  _verifyCompanies = [[VerifyCompaniesView alloc] init];
  [self.view addSubview:_verifyCompanies];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self.tableView reloadData];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  if (self.view.frame.size.height > self.view.frame.size.width) {
    _verifyCompanies.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 50);
  } else {
    _verifyCompanies.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.frame.size.width, 50);
  }
}

- (NSString *)purchaseButtonTitle {
  return _doneButton.currentTitle;
}

- (void)setPurchaseButtonTitle:(NSString *)purchaseButtonTitle {
  [_doneButton setTitle:purchaseButtonTitle forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [[self navigationController] setNavigationBarHidden:NO animated:YES];
  self.navigationItem.backBarButtonItem.tintColor = CardKConfig.shared.theme.colorLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKRows] count];
}

- (void)_centeredViewForIpad: (UIView *) view center:(CGPoint) center {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    view.center = center;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CardKTheme *theme = CardKConfig.shared.theme;
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

  if (theme.colorCellBackground != nil) {
    cell.backgroundColor = theme.colorCellBackground;
  }
  
  cell.textLabel.textColor = theme.colorLabel;
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  
  CGSize size = self.view.bounds.size;
  CGPoint center = CGPointMake(cell.frame.size.width / 2, cell.contentView.frame.size.height / 2);
  
  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && size.width > 468) {
    cell.contentView.frame = CGRectMake(0, 0, 468, cell.contentView.frame.size.height);
  }
  
  
  NSInteger width = cell.contentView.bounds.size.width;
  NSInteger height = cell.contentView.bounds.size.height;
  
  if ([CardKBankLogoCellID isEqual:cellID]) {
    UIView *mainContainer  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _bankLogoView.frame = CGRectMake(20, 0, 40, 40);
    _bankLogoView.title = @"";
    
    [mainContainer addSubview:_bankLogoView];
      
    [self _centeredViewForIpad:mainContainer center:center];
    [cell.contentView addSubview:mainContainer];
  } else if ([CardKCardCellID isEqual:cellID]) {
    UIView *cardNumberCellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _cardNumberCell.frame = CGRectMake(20, 0, cell.contentView.bounds.size.width - 40, cell.contentView.bounds.size.height);
    
    [cardNumberCellContainer addSubview:_cardNumberCell];
    
    [self _centeredViewForIpad:_cardNumberCell center:center];
    
    [cell.contentView addSubview:cardNumberCellContainer];
  } else if ([CardKCVCAndExpireDateCellID isEqual:cellID]) {
    UIView *mainContainer  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIView *expireView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, width / 2 - 40, height)];
    
    [expireView addSubview:_expireDateTextField];
    _expireDateTextField.frame = CGRectMake(0, 0, expireView.frame.size.width, height);
    [mainContainer addSubview:expireView];
    
    UIView *cvcView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expireView.frame) + 20, 0, width / 2 - 20, height)];
    _cvcTextField.frame = CGRectMake(0, 0, cvcView.frame.size.width, height);
    [cvcView addSubview:_cvcTextField];
    [mainContainer addSubview:cvcView];
    
    [self _centeredViewForIpad:mainContainer center:center];

    [cell.contentView addSubview:mainContainer];
  } else if ([CardKButtonCellID isEqual:cellID]) {
    _doneButton.frame = CGRectMake(20, 0, width - 40, height);
    [self _centeredViewForIpad:_doneButton center:center];

    [cell.contentView addSubview:_doneButton];
  }
  
  if (theme.colorCellBackground != nil) {
    cell.backgroundColor = theme.colorCellBackground;
  }
  
  cell.textLabel.textColor = theme.colorLabel;
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
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
  if (CardKConfig.shared.bindingCVCRequired) {
    return [_cvcTextField validate];
  }
  return YES;
}

- (void)_buttonPressed:(UIButton *)button {
  if (![self _isFormValid]) {
    [self _animateError];
    [Logger logWithClass:[CardKBindingViewController class]
          tag:TAG message:[NSString stringWithFormat:@"The binding form is not valid"]
          exception:nil];
    return;
  }
  
  CardKBinding *ckcBinding = self.cardKBinding;
  
  CKCBindingParams *ckcBindingParams = [[CKCBindingParams alloc] init];

  if (CardKConfig.shared.bindingCVCRequired) {
    ckcBindingParams.cvc = _cvcTextField.secureCode;
  }
  
  ckcBindingParams.bindingID = ckcBinding.bindingId;
  ckcBindingParams.mdOrder = CardKConfig.shared.mdOrder;
  ckcBindingParams.pubKey = CardKConfig.shared.pubKey;

  CKCTokenResult *seToken = [CKCToken generateWithBinding:ckcBindingParams];
  self.cardKBinding.secureCode = _cvcTextField.secureCode;
  
  [Logger logWithClass:[CardKBindingViewController class]
          tag:TAG message:[NSString stringWithFormat:@"Generate seToken:  %@", seToken.token]
          exception:nil];
  
  [_cKitDelegate bindingViewController:self didCreateSeToken:seToken.token allowSaveBinding:NO isNewCard: NO];
}

- (void)setCardKBinding:(CardKBinding *)cardKBinding {
  _cardNumberCell.binding = cardKBinding;
  _expireDateTextField.binding = cardKBinding;
  if (!CardKConfig.shared.bindingCVCRequired) {
    _cvcTextField.binding = cardKBinding;;
  } else {
    [_cvcTextField becomeFirstResponder];
  }
}

- (CardKBinding *)cardKBinding {
  return _cardNumberCell.binding;
}
@end
