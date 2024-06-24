provider "google" {
<<<<<<< HEAD
  project = "budgetbuddy" # Replace with your GCP project ID
=======
  project = "BudgetBuddy" # Replace with your GCP project ID
>>>>>>> 0782cffb1d69bf5e79a2b1d14240229559ea5186
  region  = "us-west2"       # GCP region
}

resource "google_compute_instance" "app" {
  name         = "budget-buddy-app"
  machine_type = "e2-micro"
  zone         = "us-west2-a" # Replace with a valid zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Replace with a valid image if needed
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  tags = ["http-server"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    USERNAME=$(whoami)
    sudo usermod -aG docker $USERNAME
    sudo -u $USERNAME docker run -d -p 80:5000 campinwaladsae/income-expense-app
  EOF
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

   allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["http-server"]
}
