variable "name" {
  type    = string
  default = ""
}
variable "prefix" {
  type    = string
  default = "diag"
}
variable "randomize" {
  type    = bool
  default = true
}
variable "resource_id" {
  type = string
}
variable "log_analytics_workspace_id" {
  type    = string
  default = null
}
variable "storage_account_id" {
  type    = string
  default = null
}
variable "eventhub_name" {
  type    = string
  default = null
}
variable "logs" {
  type    = list(any)
  default = []
}
variable "metrics" {
  type    = list(any)
  default = ["AllMetrics"]
}
variable "log_analytics_destination_type" {
  type    = string
  default = null
}
