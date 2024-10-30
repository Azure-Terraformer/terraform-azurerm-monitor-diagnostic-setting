provider "azurerm" {
  features {}
}
provider "random" {

}

variables {
  application_name = "aztf-test"
  location         = "westus3"
}

run "setup" {
  module {
    source = "./testing/setup"
  }
  providers = {
    azurerm = azurerm
    random  = random
  }
}

run "storage-only" {
  module {
    source = "./examples/storage-only"
  }

  variables {
    diagnostic_prefix = "foo"
    diagnostic_name   = "bar"
  }

  providers = {
    azurerm = azurerm
    random  = random
  }

  assert {
    condition     = strcontains(module.diagnostic_setting.name, "${var.diagnostic_prefix}-${var.diagnostic_name}-")
    error_message = "Must have the prefix '${var.diagnostic_prefix}-${var.diagnostic_name}'"
  }

  assert {
    condition     = can(regex("^${var.diagnostic_prefix}-${var.diagnostic_name}-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", module.diagnostic_setting.name))
    error_message = "Name format must be correct"
  }
}
