{
  "builders": [
    {
      "type": "qemu",
      "iso_url": "./rhel-8.1-x86_64-dvd.iso",
      "iso_checksum": "2323ad44d75df1a1e83048a34e196ddfedcd6c0f6c49ea59bf08095e3bb9ef65",
      "iso_checksum_type": "sha256",
      "output_directory": "./output",
      "shutdown_command": "shutdown -h +10",
      "shutdown_timeout": "15m",
      "disk_size": "10240",
      "format": "qcow2",
      "vm_name": "rhel-8.1-x86_64.qcow2",
      "headless": false,
      "ssh_username": "root",
      "ssh_password": "root_password",
      "ssh_timeout": "20m",
      "boot_wait": "10s",
      "boot_command": [
        "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg inst.sshd<enter><wait>"
      ],
      "http_directory": "http",
      "qemuargs": [
        ["-m", "16192"],
        ["-smp", "8"],
        ["-cdrom", "rhel-8.1-x86_64-dvd.iso"],
        ["-boot", "order=cd,once=d"],
        ["-machine", "type=pc,accel=kvm"]
      ]
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "#!/bin/bash",
        "mkdir -p /etc/yum.repos.d /etc/yum/vars /media/cdrom",
        "mount /dev/cdrom /media/cdrom || mount /dev/sr0 /media/cdrom",
        "cat > /etc/yum.repos.d/local.repo <<EOF",
        "[BaseOS]",
        "name=BaseOS",
        "baseurl=file:///media/cdrom/BaseOS",
        "enabled=1",
        "gpgcheck=0",
        "",
        "[AppStream]",
        "name=AppStream",
        "baseurl=file:///media/cdrom/AppStream",
        "enabled=1",
        "gpgcheck=0",
        "EOF",
        "mkdir -p /etc/yum/vars",
        "echo '8.1' > /etc/yum/vars/releasever",
        "dnf clean all",
        "dnf makecache",
        "dnf install -y cloud-init",
        "systemctl enable cloud-init"]
    }
  ]
}