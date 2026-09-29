variable "environment" {
  type = string

  validation {
    condition     = var.environment == "shared"
    error_message = "environment must be shared."
  }
}

variable "instance_size" {
  type    = string
  default = "medium"
}

variable "role" {
  type      = string
  ephemeral = true

  validation {
    condition     = contains(["plan", "deploy"], var.role)
    error_message = "role must be plan or deploy."
  }
}

resource "terraform_data" "registry" {
  input = {
    environment   = var.environment
    instance_size = var.instance_size
  }

  lifecycle {
    # Referencing var.role makes its validation run before this resource is created on apply.
    precondition {
      condition     = contains(["plan", "deploy"], var.role)
      error_message = "role must be plan or deploy."
    }
  }
}

output "environment" {
  value = terraform_data.registry.output.environment
}

output "instance_size" {
  value = terraform_data.registry.output.instance_size
}
