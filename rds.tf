    # Subnet groups
    resource "aws_db_subnet_group" "default" {
        
        name = "main"
        description = "Database VPC private subnets"
        subnet_ids = [
            "${split(",",module.vpc.vpc_private_subnet_ids)}"
        ]

        lifecycle {
            create_before_destroy = true
        }

    }

    # Security group
    resource "aws_security_group" "db" {
        
        name = "Rancher-Database-SG"
        description = "Allow rancher server to access database server."
        vpc_id = "${module.vpc.vpc_id}"

        # Allow traffic from the rancher server security group
        ingress {
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            security_groups = [
                "${module.rancher_server.server_security_group_id}"
            ]
        }

        lifecycle {
            create_before_destroy = true
        }

    }

    # Database instance
    resource "aws_db_instance" "default" {

        allocated_storage = 10
        engine = "mysql"
        engine_version = "5.6.23"
        identifier = "rancher-database"
        instance_class = "db.t2.micro"
        final_snapshot_identifier = "rancher-database-final"
        publicly_accessible = false
        db_subnet_group_name = "${aws_db_subnet_group.default.name}"
        vpc_security_group_ids = [
            "${aws_security_group.db.id}"
        ]

        # Database details
        name = "rancherserverdb"
        username = "root"
        password = "password01"

        lifecycle {
            create_before_destroy = true
        }

    }