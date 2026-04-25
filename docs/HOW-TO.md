# WealthPulse - HOW TO PUBLISH

## Pre-Submission Checklist

### 1. Privacy Policy
- Privacy Policy URL required: https://github.com/lauer3912/ios-WealthPulse/blob/main/docs/PrivacyPolicy.md
- Must be publicly accessible

### 2. App Store Connect Setup

#### Create App Record
1. Go to App Store Connect > My Apps > "+" > "New App"
2. Select:
   - Platforms: iOS
   - App Name: WealthPulse
   - Primary Language: English (US)
   - Bundle ID: com.ggsheng.WealthPulse
   - SKU: WealthPulse-001
   - User Access: Full Access

#### Enter App Information
- **Description**: See docs/Listing.md
- **Keywords**: See docs/Listing.md
- **Marketing URL**: (optional) https://wealthpulse.app
- **Support URL**: https://github.com/lauer3912/ios-WealthPulse
- **Category**: Finance > Budgeting & Finance
- **Age Rating**: 4+

#### Set Pricing
- Base Price: $9.99 USD
- Subscription Tiers:
  - Premium Monthly: $2.99/month
  - Premium Yearly: $19.99/year

#### App Privacy
- Answer "No" to all questions (we collect no data)

### 3. Upload Build
1. Open WealthPulse.xcodeproj in Xcode
2. Select "Any iOS Device" as destination
3. Product > Archive
4. Distribute App > App Store Connect > Upload

### 4. Submit for Review
- Anti-fraud: No special handling required
- Export Compliance: Answer "No" (not subject to encryption)
- Content Rights: No third-party content
- Ad Identification: No ads

## Review Notes
- First review typically takes 24-48 hours
- Provide test account credentials if required
- For subscription apps, include clear downgrade/cancel instructions

## Subscription Setup in App Store Connect
1. Go to the app > In-App Purchases
2. Create Auto-Renewable Subscriptions
3. Set up:
   - Product ID: wealthpulse_premium_monthly
   - Product ID: wealthpulse_premium_yearly
4. Configure pricing and availability

## Build Requirements
- Xcode 15.0+
- iOS Deployment Target: 15.0+
- Swift 5.9
- No additional frameworks required (using native StoreKit 2)

## Troubleshooting

**Archive fails**: Run `xcodegen generate` first
**Signing errors**: Check Development Team is set to ZhiFeng Sun (9L6N2ZF26B)
**StoreKit errors**: Ensure In-App Purchases are configured in App Store Connect

## GitHub Repository
https://github.com/lauer3912/ios-WealthPulse
