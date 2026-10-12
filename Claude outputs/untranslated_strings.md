# iSoko – hardcoded UI strings (not yet `.localized`)

Convention found: `"key".localized` → `Resources/Localizable.xcstrings` (en / fr / rw / sw). Keys are `common.label.*`, `common.action.*`, `common.status.*`, `auth.*`, etc.
Scan covered `title:`, `placeholder:`, `subtitle:`, `text:`, `message:`, `.text =`, `.title =`, `setTitle(...)`, `UIBarButtonItem(title:)`. Error logs, `print`, Logger, cell tags/identifiers were excluded.

## A. Key ALREADY exists – only swap the literal for `"key".localized` (no new translation)

| Literal | Existing key |
|---|---|
| 2 due soon | common.label.due_soon (check: has "2" hardcoded, see C) |
| Action needed | common.status.action_needed |
| Add Receipt Images | common.label.receipt_images |
| Back to login | common.reset_password_success.login_button |
| Category | common.label.category |
| Choose your account type | common.signup.header_title |
| Confirm password | common.verify_password_reset.confirm_password_label |
| Continue as Guest | auth.continue_as_guest |
| Done (x5) | common.success.done_button |
| Edit (x4) | common.action.edit |
| Email | common.label.email_placeholder (verify wording) |
| Enter Supplier Name | common.label.supplier_name_placeholder |
| Enter email | common.reset_password.email_placeholder |
| Enter password | common.verify_password_reset.password_placeholder |
| Events | events.title / common.label.events |
| Forgot password? | common.reset_password.header_title |
| In Stock | common.status.in_stock |
| Login | auth.login |
| Login required | auth.login_required.title |
| Method | common.label.method |
| New password | common.verify_password_reset.password_label |
| Number of Expenses | common.label.number_of_expenses |
| On track | common.status.on_track |
| Orders | business.hub.orders |
| Out of Stock | common.status.out_of_stock |
| Password changed | common.reset_password_success.header_title |
| Payment Method (x7) | common.label.payment_method |
| Phone number | common.label.phone_number |
| Please login to continue, or continue as guest. | auth.login_required.message |
| Products | common.label.products |
| Profit & Loss | common.label.profit_and_loss |
| Quick Actions | common.label.quick_actions |
| Rating | common.label.rating |
| Reset password | common.verify_password_reset.header_title / .confirm_button |
| Revenue | common.label.revenue |
| Sales Details | common.label.sales_details |
| Select Report Type | common.label.select_report_type |
| Send code | common.reset_password.confirm_button |
| Share | common.success.share_button |
| Share App | common.more_view.share_app |
| Spending | common.label.spending |
| Start Date (x7) | common.label.start_date |
| Subtotal | common.label.subtotal |
| Success (x2) | common.success.title |
| Summary | common.label.summary |
| Supplier (x5) | common.label.supplier |
| Supplier Name (x5) | common.label.supplier_name |
| Suppliers | common.label.suppliers |
| This month | common.label.this_month |
| Total Expenses | common.label.total_expenses |
| Total Orders | common.label.total_orders |
| Total Products | common.label.total_products |
| Total Sales | common.label.total_sales |
| Total Value | common.label.total_value |
| Total entries | common.label.total_entries |
| Transactions | common.label.transactions |
| View Details | common.action.view_details |
| Out of Stock / Out of stock | common.status.out_of_stock |

## B. NEW keys needed (plain strings)

**Common actions / buttons** – Cancel (x7), Close, Create (x13), Okay, Proceed (x2), Register, Reject, Reorder, Resend, Restock, Retry, Sign Out, Submit, Apply Filters, Clear Filters, Copy Code, Update Password, Update Sale, Update Supplier, Edit Supplier, Add Supplier, Register Supplier, Register Association, Delete Account, Change Password, Place Order (x2), Continue with Google, Select Date, View History (x2), Call, WhatsApp, Website (x3), Contacts (x2), Mobile, Office Location

**Form labels / placeholders** – Age Group, Association, Association Code, Association Name, Business Location, City/Town, City/Town (optional), Physical Address, Physical Address (optional), Founded Year, Number of Members, Instagram URL, LinkedIn URL, X (Twitter) URL, Website URL, Last Name, Location, Product, Product Name (x4), Name of the Product, Price Per Unit, Unit Price, Unit Cost, Low Stock Level, Minimum Order Qty, Measurement Unit (x3), Type of Commodity (x3), Quantity (x8), Amount Paid, Any, All Associations, All Categories, All Locations, Sales Type, Price Range, Min Price, Max Price, Filter By, Sort By (x2), Published, Items, Items Supplied, Current password, Enter password to confirm, Enter Category name (x4), Enter Email Address, Enter First Name, Enter Last Name, Enter Low Stock Level, Enter Unit Cost, Enter minimum quantity, Enter price, Enter product name, Enter your first name, Enter your second name, Select commodity type, Select unit, Select your age group, Select your gender, Search for products, Search for services, Search orders, Search products, Search services, This field is required (x2), Login With, Or, to

**Section / screen titles** – About the Product, Account Settings, Add a new Category, Additional Product Images, Choose an Option, Complete Association Registration, Contact Information, Create Your Profile, Custom Range, Date and Time, Location Information, OTP Verification, Order Status, Order Summary, Overview, Pricing, Primary Image, Primary Product Image, Product Images, Product Information, Quick…, Requirements, Select Time Frame, Similar Products, Similar Services, Stock Report, Update your password, What are you Selling?, Upload Certificate (Optional), Upload Logo (Optional), Profile Updated, Product Published, Password Reset Success (x2), Order Placed (x2), Error (x2)

**Stats / report labels** – Active Buyers, All customers, All suppliers, Available Stock, Awaiting Fulfillment, New Customers, Recently added, Points Earned, Profit, Stock Intake, Stock Value, Total Amount, Total Customers (x2), Total Referrals, Total Revenue, Total Spent, Total Supplied (x2), Total Suppliers (x2), Total Supplies, Your Referral Code, FEATURED, No reviews yet

**Sentences / messages** – Are you sure you want to sign out?, Select one of the options below:, Check back later., Try adjusting your search or filters., Pull down to try again., No Results Found, Nothing Here Yet, Something Went Wrong, Password has been reset successfully, Account has been deleted successfully, we're sorry to see you go!, A password reset email has been sent to your email address. Please check your e… (AuthCoordinator:452 – full text truncated in scan), Your product has been published successfully., Your profile has been updated successfully., Share the iSOKO app invite code, Share the iSOKO app by inviting your friends to check it out., iSOKO App Invitation, Valid registration documents, Minimum 5 active members, .png, .jpg, .jpeg up to 5MB, .png, .jpg, .jpeg, .pdf up to 5MB

## C. Dynamic strings – need a format key (`%@` / `%d`) and `.localized(with:)`

| Current | Proposed |
|---|---|
| `"Order \(orderNumber) created successfully"` (Home + TradeAssociation coordinators) | `orders.created_message` = "Order %@ created successfully" |
| `"\(qty) \(unit) available"` (x4 files) | `common.label.units_available` = "%@ %@ available" |
| `"\(qty) units"` | `common.label.units_count` = "%d units" |
| `"Price: \(currency) \(price)"` (x2) | `common.label.price_with_currency` = "Price: %@ %@" |
| `"(\(count) reviews)"` | `products.reviews_count` = "(%d reviews)" |
| `"Resend in \(n)s"` | `common.otp.resend_in` = "Resend in %ds" |
| `"Founded in " + year` (x2) | `common.label.founded_in` = "Founded in %@" |
| `"24% / 13% since last week"` | `common.label.percent_since_last_week` = "%@ since last week" |
| `"2 due soon"` | `common.label.n_due_soon` = "%d due soon" |
| `"\(priceText) / \(unit)"`, `"\(quantity)X \(name)"` | probably OK as-is (symbols only) – confirm |

## D. Looks like mock / test data – recommend NOT translating (or remove)

HomeViewModel: "by Zawadi Designs", "Fursa ya mafunzo na mitaji kutoka Stanbic Bank", "Partner Association", "Region, Kenya"
NewsListingViewModel: "Baraka Womens Football Club", "Founded in 2025", "www.association-website.com", "Nairobi, Kenya", "Finance \(i)", "Updated Test cases"
Debug-looking: "Modal Flow" (ModalCoordinator), "Center Action" (MainTabsViewController), "Create" test buttons (`btn01.setTitle("Create")` in Settings/ShareApp/TradeAssociation listings – confirm if real).

## Notes
- In Release builds `.localized` falls back to the English `en.lproj` bundle; xcstrings handles `en` already so no change needed there.
- Scan is regex-based; strings passed through other parameter names (e.g. `header:`, `buttonText:`) or built in storyboards/xibs could still be missing – happy to do a second pass after this batch.
