data "aws_ami" "get_ami" {
  #executable_users = ["self"]
  most_recent      = true
  #name_regex       = "^packer-bitwarden"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["packer-bitwarden"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
