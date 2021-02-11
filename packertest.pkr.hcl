variable "ami_name" {
  type = string
  # This example demostrates that you can load variables from the environment.
  # In real usage, the AWS sdk used by the Amazon builder can automatically
  # load credentials from the environment, so you wouldn't need to do this
  # step. See the Packer AWS docs for more details.
  default = "packertest"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "packertest" {
  ami_name      = "packer-bitwarden"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

# a build block invokes sources and runs provisioning steps on them.
build {

  sources = ["source.amazon-ebs.packertest"]

  provisioner "shell" {
    inline = ["sudo apt-get update", "sudo apt-get install -y docker.io", "sudo docker pull bitwardenrs/server:latest"]
  }

}


