data "terraform_remote_state" "state" {
  backend = "local"
  config = {
    path = "../app-infra/terraform.tfstate"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.state.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.state.outputs.cluster_name
}