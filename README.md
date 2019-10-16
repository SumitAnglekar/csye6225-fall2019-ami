# Build Instructions
1. Clone the git repository: `git@github.com:<username>/         fa2019-team-002-ami.git`
   Usernames that can be used are SumitAnglekar94, shah-tejas, ishitasequeira

# Installation
1. `https://www.iannoble.co.uk/how-to-install-packer/` 
2.  `https://www.digitalocean.com/community/tutorials/how-to-install-and-get-started-with-packer-on-an-ubuntu-12-04-vps`


# Build AMI (Amazon Machine Image) using Packer commands
1. packer --version
2. packer validate
3. packer build 

# Launch the EC2 instance from the created AMI
1. Login to AWS console.
2. Navigate to services-> EC2 -> Instances
3. Click on `Launch Instance`
4. Select the created/build AMI from `My AMIs`
5. Choose an `instance type` we keep it to default; ie : `t2.micro` (click on `Configure Instance Details`)
6. Under `Configure Instance Details` select appropriate Network and Subnet and make sure that `Auto-assign Public IP` is always enabled (click Next:Add Storage)
7. Default setup for Add Storage
8. Default setup for Add Tags
9. `Configure Security Group` : 
    Create a security group with required name and description.
    Add required rules and it's parameters like `type`,`Portocol`,`Port Range`,`Source`,`Description`.
10. Review the instance and it's configuration and launch it.

# Setting database environment and deploying the Web application on the running EC2 instance

1. Copying the created .war file from recipe/target/recipe.war to the given initialized ec2 instance
`scp <path-to-source-file> centos@<ec2_instance_ip>:<destination_path>`

2. By default, PostgreSQL does not allow password authentication. We will change that by editing its host-based authentication (HBA) configuration.
Open the HBA configuration with your favorite text editor. We will use vi:
`sudo vi /var/lib/pgsql/data/pg_hba.conf`
Then replace “ident” with “md5”
PostgreSQL is now configured to allow password authentication.

3. The installation procedure created a user account called cloud that is associated with the cloud role. In order to use Postgres, we’ll need to set password for user cloud. You can do that by typing:
`sudo -i -u cloud psql -d recipe`
`recipe=# \password`
This will ask for a password. This password should be same as db_user_password

4. Restart the postgres
`sudo systemctl restart tomcat`

5. Check the tomcat log if the application has been deployed and started correctly
`sudo tail -f -n 100 /opt/tomcat/logs/catalina.log`

## Verifying the application APIs, if they can be accessed from the IP address of EC2 instance

### Append the ec2 instance ip in the url for testing application endpoints 
 Example: 
    1. Register a User (<instance_ip>:8080/v1/user)
    2. Get User records (<instance_ip>:8080/v1/user/self)
    3. Update User recordds (<instance_ip>:8080/v1/user/self)
    4. Register a Recipe (<instance_ip>:8080/v1/recipe/)
    5. Get recipe Information (<instance_ip>:8080/v1/recipe/{id})
    6. Delete a particular recipe (<instance_ip>:8080/v1/recipe/{id})


