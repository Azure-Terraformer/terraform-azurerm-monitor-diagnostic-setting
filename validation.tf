locals {
  name_is_valid = !(var.name == "" && var.randomize == false)
}
