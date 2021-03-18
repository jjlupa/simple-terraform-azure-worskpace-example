
# Generally, environment name gets encoded in a whole bunch of things like URI's, so we want to be able to
# override it if we are creating custom environments which aren't part of a formalized stack.
variable "env" {
  type        = string
  description = "CD environment name override"
  default     = ""
}

# Always nice to be able to customize and grow these from commandline
variable "tags" {
  description = "A map of tags to add to all resources"
  default = {
    CreatedBy = "Terraform"
  }
}

#
# Unlike variables, locals are things we really don't want to customize per run, however, we do want to
# customize them per workspace, allowing us to differentiate characteristics of different environments.
#
# Access variables thus : instance_type = "${local.workspace["instance_type"]}"
# Notice how it's defined plural but referenced singular. n1 hashicorp.
#

locals {
  env = {
    default = {
      location = "centralus"

    }
    dev = {

    }
    prod = {
    }
  }

  # Which set of variables are we using?
  environmentindex = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"

  # This variable wil hold the properly contextualized variables, and will merge default in.
  workspace = merge(local.env["default"], local.env[local.environmentindex])
}
