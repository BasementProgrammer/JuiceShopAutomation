# Juice Shop Automation
OWASP Juice shop is a tool that IT Professionals can use to test their knowledge of common website vunerabilities. The web page is designed with several vunerabilities baked in. The intent of Juice Shop is that you can test out your knowledge of common vunerabilities.

However, as I pointed out in my video:
https://www.youtube.com/watch?v=XdSranGhF7Q

You can also use Juice shop as the back end to help you understand how to implement security measures to protect your website as well. For example setting up a WAF to help protect against SQL *Injection attacks from reaching your application in the first place.

## Challenges
One of the more challenging aspects of using Juice SHop is getting it set up, esoppecially in an environment where you may want it running persistently. This project is designed to help automate the setup and help you get to the fun parts.

## Files
Install.sh -
The file is designed to be used as part of a Cloud Init script that you can use to set up Juice Shop on a cloud instance. It has been tested on: 

### OCI
Ubuntu 20.04

The file is specifically designed to be run as a CloudInit script, so it lacks the *sudo* commands necessary to be run as an interactive script. 



## Next steps
Build a complete Terraform script to launch as a stack in OCI.

Build an interactive script


