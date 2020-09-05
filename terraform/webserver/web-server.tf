# Create a new tag
resource "digitalocean_tag" "web" {
  name = "web-server"
}

# Create a new droplet
resource "digitalocean_droplet" "terraform" {
  image = var.ubuntu-image
  name = "${var.prefix}-${var.environment}"
  region = var.region
  size = var.size
  tags = [
    digitalocean_tag.web.id]
  resize_disk = var.resize_disk
  ssh_keys = var.ssh_keys

  provisioner "remote-exec" {

    connection {
      host = self.ipv4_address
      type = "ssh"
      user = "root"
      private_key = file("~/.ssh/id_rsa")
      timeout = "2m"
    }

    inline = [
      "if [ ! -x /usr/bin/python ]; then ln -sv /usr/bin/python3 /usr/bin/python; fi"
    ]
  }

  provisioner "local-exec" {
    command = "echo '[web-server]\n ${digitalocean_droplet.terraform.ipv4_address } \n' > do_hosts"
  }

  provisioner "local-exec" {
    command = "sleep 4m && ansible-playbook -i do_hosts ../../ansible/webserver/web-server.yml"
  }

}

# Create a new domain
resource "digitalocean_record" "terraform" {
  domain = var.domain
  name = var.record
  type = "A"
  ttl = 30
  value = digitalocean_droplet.terraform.ipv4_address
}