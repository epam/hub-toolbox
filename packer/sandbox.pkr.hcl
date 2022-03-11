packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "superhub-toolbox" {
  project_id = "superhub"
  source_image = "ubuntu-minimal-2110-impish-v20220203"
  ssh_username = "packer"
  zone = "us-central1-a"
  image_name = "superhub-toolbox-2" 
}

build {
  sources = ["sources.googlecompute.superhub-toolbox"]

  provisioner "shell" {
    script = "setup.sh"
  }
}


