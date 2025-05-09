

# 1. Action Group for Alerts
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

# 2. CPU Usage Alert (Triggers if CPU > 60%)
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

  depends_on = [
    azurerm_linux_virtual_machine.linuxvm,
    azurerm_monitor_action_group.alert_group
  ]
}

# 3. When Available Memory Bytes < 20 for 5 min(default)
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "low-memory-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.linuxvm.id]
  description         = "Action will be triggered when Free disk space is less than 20."
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1073741824 
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }

  tags = {
    environment = "staging"
  }

  depends_on = [
    azurerm_linux_virtual_machine.linuxvm,
    azurerm_monitor_action_group.alert_group
  ]
}
