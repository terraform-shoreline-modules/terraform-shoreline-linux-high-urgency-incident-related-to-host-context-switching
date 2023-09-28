resource "shoreline_notebook" "high_urgency_incident_related_to_host_context_switching" {
  name       = "high_urgency_incident_related_to_host_context_switching"
  data       = file("${path.module}/data/high_urgency_incident_related_to_host_context_switching.json")
  depends_on = [shoreline_action.invoke_cpu_usage_script,shoreline_action.invoke_remediate_context_switching_rate]
}

resource "shoreline_file" "cpu_usage_script" {
  name             = "cpu_usage_script"
  input_file       = "${path.module}/data/cpu_usage_script.sh"
  md5              = filemd5("${path.module}/data/cpu_usage_script.sh")
  description      = "The system may be overloaded with too many requests, causing the CPU to switch between different processes frequently, leading to high context switching rates."
  destination_path = "/agent/scripts/cpu_usage_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "remediate_context_switching_rate" {
  name             = "remediate_context_switching_rate"
  input_file       = "${path.module}/data/remediate_context_switching_rate.sh"
  md5              = filemd5("${path.module}/data/remediate_context_switching_rate.sh")
  description      = "Consider restarting the affected service or host."
  destination_path = "/agent/scripts/remediate_context_switching_rate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_usage_script" {
  name        = "invoke_cpu_usage_script"
  description = "The system may be overloaded with too many requests, causing the CPU to switch between different processes frequently, leading to high context switching rates."
  command     = "`chmod +x /agent/scripts/cpu_usage_script.sh && /agent/scripts/cpu_usage_script.sh`"
  params      = []
  file_deps   = ["cpu_usage_script"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_usage_script]
}

resource "shoreline_action" "invoke_remediate_context_switching_rate" {
  name        = "invoke_remediate_context_switching_rate"
  description = "Consider restarting the affected service or host."
  command     = "`chmod +x /agent/scripts/remediate_context_switching_rate.sh && /agent/scripts/remediate_context_switching_rate.sh`"
  params      = ["SERVICE_NAME"]
  file_deps   = ["remediate_context_switching_rate"]
  enabled     = true
  depends_on  = [shoreline_file.remediate_context_switching_rate]
}

