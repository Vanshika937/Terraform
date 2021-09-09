provider "aws"{


region="us-east-1"
shared_credentials_file="cred.txt"
profile="default"



}

resource "aws_instance"  "os1"{                             #ec2 instance
ami="ami-0ab4d1e9cf9a1215a"
instance_type="t2.micro"
security_groups = ["${aws_security_group.mySecurityGroup.name}"]           
key_name="myKey"
tags={
Name="My TF OS"
}

}
resource "aws_key_pair" "key1" {                           #generating keypair
  key_name   = "myKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/SNpAT84ocnCX67zdXEMcf9ZFSybAyGVVKhEoxH3/bp/kZG+aafMCHGVDy6H6UHQN2I5tQ3NCxrSwFrNIRpGA07Y1zcqzld2LKrdYo6J1kedWanQuuYOUlOkZ2LeUAMcc41N7OzQ60VZkz3UZcPF7r0qY5kvD7Z+qEmyrXRn65VK7ZRXdYCtFEzEBARbIjn9biYZYMqmVBNr4ijMet5leA0c5PlU+YPSb61WHU/AtPqIAgJJtuNEw3jH5iJQQOWsnNm11TzXK2okJDA+/d/kmgrjliqjvxk9P9ACsqNqJHo8M/nZgnUAd5fySOV3bvDmLxt6vAl89mVJ1/Vlrfgoz rsa-key-20210720"
}

resource "aws_security_group" "mySecurityGroup" {          #security group
  name = "mySecurityGroup"
  
  description = "Allow ssh connections on port 22"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "volume1"{                       #generating volume
availability_zone=aws_instance.os1.availability_zone
size=1
tags={
Name="myVol"
}
}

resource "aws_volume_attachment" "vol_Attachment"{        #attach volume to the instance
device_name="/dev/sdh"
volume_id=aws_ebs_volume.volume1.id
instance_id=aws_instance.os1.id
}
