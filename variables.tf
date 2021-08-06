
# Required before deployment

variable "gcp_project" {
    type = string
    default = "" # Your GCP Project name
}

variable "privatekeypath" {
    type = string
    default = "" # The path to your GCP private key ("somekey")
}

variable "publickeypath" {
    type = string
    default = "" # The path to your GCP public key ("somekey.pub")
}


variable "gcp_region" {
    type = string
    default = "us-central-1" 
}

variable "gcp_az" {
    type = string
    default = "us-central1-c" 
}

variable "cidr_range" {
    type = string
    default = "10.2.0.0/16"
}

variable "allow_cidr_range" {
    type = string
    default = "0.0.0.0/0"
}

variable "machinetype" {
    type = string
    default = "e2-medium"
}

variable "machineimage" {
    type = string
    default = "centos-cloud/centos-7"
}

variable "sshuser" {
    type = string
    default = "centos"
}

variable "machinename" {
    type = string
    default = "tf-splunk"
}

variable "splunkwebport" {
    type = number
    default = "8000"
}