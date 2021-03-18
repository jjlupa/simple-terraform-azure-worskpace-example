# simple-terraform-azure-worskpace-example
Quick walkthrough of Terraform Workspace idiom w/ Azure. The use case I want to explore a bit is how to
use terraform workspaces to support multi-environment deploy. In this particular case, i'm driving secret
management outside of this configuration (specifically, I'm ignoring it. I like ParameterStore in AWS, or
SecretsManager.  For Azure, I've only used Cosmos, but there is probably something better).

Architecturally, the GOAL is to be able to encompass all configuration in a set of tf files (in this case
main.tf, but of course terraform aggregates files and modules according to it's rules). Secret management
becomes important when you do this, and you should figure out what works best for you. You can imagine how
to use this syntax to drive environment injection, which is the last resort of scoundrels (me).

# Outside the project

I'm using a Mac, I'm setting up my creds through azure-cli (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos).

All login and setup of the base IAM role is managed externally.

# Inside the project


# Usage

* Get setup

`git pull`
`az login`
`terraform init`

* Build workspaces

`terraform workspace new dev`
`terraform workspace new prod`

* let's go ahead and switch workspaces to show the command

`terraform workspace select dev`

Before we go on, take a second to poke around the .terraform to see how it's isolating state. You want remote state for
your projects, of course, but it's useful in this case to be able to see it next to the code. Note that you can't get rid
of the "default" workspace, which isn't the best, as you end up with a configuration which isn't mapped to anything. You'll
have to decide what that means. If you are getting all formal on an environment stack, you maybe use default for your infra
change testing, but it IS an environment, so you better config for it.  I wish there was some way to make sure I deleted
any default assets I created on checkin, but  ¯\_(ツ)_/¯.

Peek inside main.tf, and variables.tf now.

- main.tf : This represents our infra we are creating. I'm just going to make a RG and something else small, to show how
things are differentiated per environment.

- variables.tf : This is where we'll manage input variables, output variables, and local variables.  It will help if you
enforce an idiom of only referencing locals across your infrastructure, and translating input variables into local variables
for a couple reasons, but mostly so you can controll input variance in one place. It just makes it easier to trust that weird
shit isn't going on downstream.  This isn't a real problem with a small thing like this but by the time you are building out
a real environment stack, you start to get a lot of LOC, and you have to think like a software engineer on code layout.

Usage on these config items is `"${local.workspace["instance_type"]}"`, where instance_type would be the variable name (for whatever the value you want to mutate is).  Notice that in THIS implementation, we merge default locals into the contextualized workspace locals. I'm not 100% on this strategy, but it works and allows you to not have to respecify the world.    

* Go ahead and deploy now:

`terraform plan`
`terraform apply`


