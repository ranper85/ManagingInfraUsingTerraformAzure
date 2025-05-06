# 1. Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "loganalytics-${var.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "staging"
  }
}

# 2. Diagnostic Settings for the Linux VM
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name                       = "linuxvm-diagnostics"
  target_resource_id         = azurerm_linux_virtual_machine.linuxvm.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  log_analytics_destination_type = "Dedicated"

  logs {
    category = "LinuxSyslog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"  # This is a valid metric category
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

# 3. Action Group for Alerts
resource "azurerm_monitor_action_group" "alert_group" {
  name                = "vm-alerts-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "vmalerts"

  email_receiver {
    name                    = "adminTeam"
    email_address           = var.alert_email  # Make sure var.alert_email is set in your variables
    use_common_alert_schema = true
  }

  tags = {
    environment = "staging"
  }
}

# 4. CPU Usage Alert (Triggers if CPU > 80%)
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "high-cpu-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.linuxvm.id]
  description         = "Triggers if CPU usage > 60% for 5 minutes"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }

  tags = {
    environment = "staging"
  }
}
