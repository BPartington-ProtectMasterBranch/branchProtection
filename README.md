# branchProtection
This web service receives a branch created webhook from Github, and protects the master branch.  It can easily be customized to support any protections required for an organization.  

# Usage
## Server Setup
This web service for receiving a webhook utilizes Sinatra server.  For details on how to install and setup the Sinatra server, please visit http://www.sinatrarb.com/.

Once Sinatra is setup, if you are running your Sinatra server from localhost you must utilize ngrok to provide a web facing URL to Github.  Details on how to do this can be found at https://developer.github.com/webhooks/configuring/.

Once ngrok is running, start up your Sinatra server issuing the following from a command line:
    ruby ./myapp.rb

## Webhook Configuration
To configure the webhook for usage, please do the following:
 1. Go to the organization settings tab on Github, then select 'Webhooks' from the far left menu.
 1. Click 'Add ewbhook'
 1. For the Payload URL enter the Forwarding item from the ngrok console output (it will be something like 'https://5e7fc985.ngrok.io'), and then append '/payload'.  The final value you enter will be something like 'https://5e7fc985.ngrok.io/payload'
 1. Change the Content type to 'application/json'
 1. Select 'Let me select individual events', then select 'Branch or tag creation'
 1. Click the 'Add webhook' button.

## Create a Repository
To create a repository to see if all is working as expected, create a new repository from within the organization you setup the webhook for.  You must either select to automatically create a README file when creating the repository, or manually add a file for the master branch to be created and this to work.

Good luck and enjoy!


# Resource Material Used
http://www.sinatrarb.com/
https://developer.github.com/webhooks/configuring/
