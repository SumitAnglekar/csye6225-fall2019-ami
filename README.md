# Build Instructions
1. Clone the git repository: `git@github.com:<username>/         fa2019-team-002-ami.git`
   Usernames that can be used are SumitAnglekar94, shah-tejas, ishitasequeira

# Installation
1. `https://www.iannoble.co.uk/how-to-install-packer/` 
2. `https://www.digitalocean.com/community/tutorials/how-to-install-and-get-started-with-packer-on-an-ubuntu-12-04-vps`


# Build AMI (Amazon Machine Image) using Packer commands
1. packer --version
2. packer validate -var-file=<local-var-file-name> centos-ami.json
3. packer build -var-file=<local-var-file-name> centos-ami.json

### Once you run packer commands your AMI is created, check the UI and verify with the AMI id in the terminal

# Launch the EC2 instance for the created AMI
### (In this assignment we are going to launch the instance with terraform commands directly)
### Confirm that you have set all your variable values correctly in terraform.tfvars file

1. Run the `terraform init` command in the root "terraform directory"
2. `terraform plan` to check if all the required variables have their respective values
3. `terraform apply` to run the entire terraform script to generate the ec2 instance. (This might take a while ~10mins)
4. Check the UI for the EC2 instance and confirm that it's up and running (2/2).

# Deploying the Web application on the running EC2 instance

1. Before starting with deployment, make sure you have cleaned and install the repository so that you have all the dependencies as well.

1. Copying the created .war file from recipe/target/recipe.war to the given initialized ec2 instance
`scp <path-to-source-file> centos@<ec2_instance_ip>:<destination_path>`
example: `scp /home/sumit/Documents/cloud/ccwebapp/webapp/recipe/target/recipe.war centos@34.200.252.13:~`

2. Login to the centos
`ssh centos@34.200.252.13`

3. Make the Tomcat directory writeable
`cd /opt/tomcat/`
`sudo chmod -R 777 .`

4. Copy the .war file and deploy it in webapps
`cd webapps`
`cp ~/recipe.war .`

5. Restart the postgres
`sudo systemctl restart postgresql`

6. Restart tomcat
`sudo systemctl restart tomcat`

5. Check the tomcat log if the application has been deployed and started correctly
`sudo tail -f -n 100 /opt/tomcat/logs/catalina.log`

## Verifying the application APIs, if they can be accessed from the IP address of EC2 instance

### Append the ec2 instance ip in the url for testing application endpoints 
 Example: 
    1. Register a User (<instance_ip>:8080/v1/user)
    eg: `54.147.44.242:8080/recipe/v1/user`
    2. Get User records (<instance_ip>:8080/v1/user/self)
    eg: `54.147.44.242:8080/recipe/v1/user/self`
    3. Update User recordds (<instance_ip>:8080/v1/user/self)
    eg: `54.147.44.242:8080/recipe/v1/user/self`
    4. Register a Recipe (<instance_ip>:8080/v1/recipe/)
    eg: `54.147.44.242:8080/recipe/v1/recipe/`
    5. Get recipe Information (<instance_ip>:8080/v1/recipe/{id})
    eg: `54.147.44.242:8080/recipe/v1/recipe/aac56c9f-9818-42f5-bbb7-f8816b79be3b`
    6. Get the newest recipe (<instance_ip>:8080/v1/recipes)
    eg: `54.147.44.242:8080/recipe/v1/recipes`
    7. Changes in the recipe (PUT) (<instance_ip>:8080/v1/recipe/{id}) 
    eg: `54.147.44.242:8080/recipe/v1/recipes`
    8. Delete a particular recipe (<instance_ip>:8080/v1/recipe/{id})
    eg: `54.147.44.242:8080/recipe/v1/recipe/aac56c9f-9818-42f5-bbb7-f8816b79be3b`
    9. Register an Image (<instance_ip>:8080/v1/recipe/{id}/image)
    eg: `54.147.44.242:8080/recipe/v1/recipe/0c4307ea-90da-49a9-aa4f-5b9864f4d674/image`
    10. Get an image (<instance_ip>:8080/v1/recipe/{recipeId}/image/{imageId})
    eg: `54.147.44.242:8080/recipe/v1/recipe/0c4307ea-90da-49a9-aa4f-5b9864f4d674/image/aac56c9f-9818-42f5-bbb7-f8816b79be3b`
    11. Delete an image (<instance_ip>:8080/v1/recipe/{recipeId}/image/{imageId})
    eg: `54.147.44.242:8080/recipe/v1/recipe/0c4307ea-90da-49a9-aa4f-5b9864f4d674/image/aac56c9f-9818-42f5-bbb7-f8816b79be3b`
   
