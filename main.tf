terraform {
  required_version = "~> 0.14.2"
}

provider "google" {
 project = var.gcp_project
 region = var.gcp_region
 zone = var.gcp_az
}

resource "google_compute_network" "splunk" {
  name                    = "splunk"
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"

}

resource "google_compute_subnetwork" "splunk" {
  name          = "splunk"
  ip_cidr_range = var.cidr_range
  region        = var.gcp_region
  network       = google_compute_network.splunk.id

}

resource "google_compute_firewall" "splunkweb-rule" {
  name = "splunk-web"
  network = "splunk"
  allow {
      protocol = "tcp"
      ports = [var.splunkwebport]
  }
  source_ranges = var.allow_cidr_range

  depends_on = [google_compute_network.splunk]
}

resource "google_compute_firewall" "ssh-rule" {
  name = "ssh"
  network = "splunk"
  allow {
      protocol = "tcp"
      ports = ["22"]
  }
  source_ranges = var.allow_cidr_range

  depends_on = [google_compute_network.splunk]
}

resource "google_compute_instance" "splunk" {
  name         = var.machinename
  machine_type = var.machinetype

  metadata = {
    ssh-keys = "${var.sshuser}:${file(var.publickeypath)}"
  }

  tags = ["splunk"]

  boot_disk {
    initialize_params {
      image = var.machineimage
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork = "splunk"
    access_config {
    }
  }

  provisioner "file" {

    connection {
      type = "ssh"
      timeout = "120s"
      user = var.sshuser
      host = google_compute_instance.splunk.network_interface.0.access_config.0.nat_ip
    }
    
    source = "./splunk-resources"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    connection {
      host = google_compute_instance.splunk.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.sshuser
      timeout = "120s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "sudo chmod +x /tmp/splunk-resources/installsplunkasrootuser.sh",
      "sudo /tmp/splunk-resources/installsplunkasrootuser.sh",
      "echo Splunk is installed!"
    ]
  }


  depends_on = [google_compute_subnetwork.splunk]
}

output "internal_ip" {
  value = google_compute_instance.splunk.network_interface.0.network_ip
}

output "external_ip" {
  value = google_compute_instance.splunk.network_interface.0.access_config.0.nat_ip
}

