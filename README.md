## Build Instructions
1. Clone the git repository: `git@github.com:<username>/         fa2019-team-002-ami.git`
   Usernames that can be used are SumitAnglekar94, shah-tejas, ishitasequeira

## Installation
1. `https://www.iannoble.co.uk/how-to-install-packer/` 
2.  `https://www.digitalocean.com/community/tutorials/how-to-install-and-get-started-with-packer-on-an-ubuntu-12-04-vps`


## Build AMI (Amazon Machine Image) using Packer commands
1. packer --version
2. packer validate
3. packer build 

## Launch the EC2 instance from the created AMI
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

## Deploying the Web application on the running EC2 instance

# Setting up database environment in CentOS 7
1. Install the postgresql-server package and the “contrib” package, that adds some additional utilities and functionality:
`sudo yum -y install postgresql-server postgresql-contrib`

2. Create a new PostgreSQL database cluster: 
`sudo postgresql-setup initdb`

3. By default, PostgreSQL does not allow password authentication. We will change that by editing its host-based authentication (HBA) configuration.
Open the HBA configuration with your favorite text editor. We will use vi:
`sudo vi /var/lib/pgsql/data/pg_hba.conf`
Then replace “ident” with “md5”
PostgreSQL is now configured to allow password authentication.

4. Start and enable PostgreSQL:
`sudo systemctl start postgresql`
`sudo systemctl enable postgresql`

5. The installation procedure created a user account called postgres that is associated with the default Postgres role. In order to use Postgres, we’ll need to log into that account. You can do that by typing:
`sudo -i -u postgres`

6. You can create the appropriate database by simply calling this command as the postgres user:
`createdb recipe`

7. We can create a new role by typing:
`createuser --interactive`

8. Now we connect to the recipe database as the Postgres role by typing:
`psql`

9. We give appropriate password to the created postgres role 
`\password`

10. `\q`

11. Create a new cloud user 
`sudo adduser cloud`

12. `sudo -i -u cloud psql -d recipe`

13. Set password for created user
`\password`

## Verifying the application APIs, if they can be accessed from the IP address of EC2 instance
1.
2.

