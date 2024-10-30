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
    diagnostic_name   = ""     # must be set 
    diagnostic_prefix = "diag" # this is the default value, must be set otherwise this will fail
  }

  providers = {
    azurerm = azurerm
    random  = random
  }

  assert {
    condition     = strcontains(module.diagnostic_setting.name, "diag-")
    error_message = "Must have the prefix 'diag'"
  }

  assert {
    condition     = can(regex("^diag-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", module.diagnostic_setting.name))
    error_message = "Name format must be correct"
  }
}
