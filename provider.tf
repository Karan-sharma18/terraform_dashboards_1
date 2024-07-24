terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      version = "3.39.1"
    }
  }
}

provider "newrelic" {
  # Configuration options
  account_id = 4438268
  api_key = "NRAK-FOMEYXN4G5I2MDK4C4KD0BRLOO5"
  region = "US"
}