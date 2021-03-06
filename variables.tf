variable "vpc_id" { }

variable "cache_name" { }
variable "cache_nodes" {
  default = "1"
}
variable "engine_version" {
  default = "1.4.24"
}
variable "instance_type" {
  default = "cache.t2.micro"
}
variable "maintenance_window" {
  # SUN 01:00AM-02:00AM ET
  default = "sun:05:00-sun:06:00"
}

variable "private_subnet_ids" { }

variable "alarm_actions" { }
