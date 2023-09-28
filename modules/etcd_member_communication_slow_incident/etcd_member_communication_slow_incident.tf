resource "shoreline_notebook" "etcd_member_communication_slow_incident" {
  name       = "etcd_member_communication_slow_incident"
  data       = file("${path.module}/data/etcd_member_communication_slow_incident.json")
  depends_on = [shoreline_action.invoke_net_traffic_check,shoreline_action.invoke_etcd_cluster_resources]
}

resource "shoreline_file" "net_traffic_check" {
  name             = "net_traffic_check"
  input_file       = "${path.module}/data/net_traffic_check.sh"
  md5              = filemd5("${path.module}/data/net_traffic_check.sh")
  description      = "High network traffic between etcd cluster members."
  destination_path = "/agent/scripts/net_traffic_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "etcd_cluster_resources" {
  name             = "etcd_cluster_resources"
  input_file       = "${path.module}/data/etcd_cluster_resources.sh"
  md5              = filemd5("${path.module}/data/etcd_cluster_resources.sh")
  description      = "Increase the resources allocated to the Etcd cluster by adding more nodes or increasing the CPU and memory on the existing nodes."
  destination_path = "/agent/scripts/etcd_cluster_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_net_traffic_check" {
  name        = "invoke_net_traffic_check"
  description = "High network traffic between etcd cluster members."
  command     = "`chmod +x /agent/scripts/net_traffic_check.sh && /agent/scripts/net_traffic_check.sh`"
  params      = ["ETCD_PORT","ETCD_MEMBERS_LIST"]
  file_deps   = ["net_traffic_check"]
  enabled     = true
  depends_on  = [shoreline_file.net_traffic_check]
}

resource "shoreline_action" "invoke_etcd_cluster_resources" {
  name        = "invoke_etcd_cluster_resources"
  description = "Increase the resources allocated to the Etcd cluster by adding more nodes or increasing the CPU and memory on the existing nodes."
  command     = "`chmod +x /agent/scripts/etcd_cluster_resources.sh && /agent/scripts/etcd_cluster_resources.sh`"
  params      = ["NEW_NODE_MEMORY","NEW_NODE_COUNT","NEW_NODE_CPU"]
  file_deps   = ["etcd_cluster_resources"]
  enabled     = true
  depends_on  = [shoreline_file.etcd_cluster_resources]
}

