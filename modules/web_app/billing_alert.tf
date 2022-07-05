data "google_billing_account" "billing_account" {
  display_name = var.billing_account_name
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.billing_account.id
  display_name    = "Billing Budget Slow Down"
  amount {
    specified_amount {
      currency_code = "USD"
      units         = "100"
    }
  }
  threshold_rules {
    threshold_percent = 0.5
  }
}
