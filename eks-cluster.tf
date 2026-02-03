module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.12.0"

  name = "myapp-eks-cluster"
  kubernetes_version = "1.33"
  endpoint_public_access  = true

# Most Important Line : Pods will run in private network. - To access internet, they need NAT. - To expose app, you’ll need Load Balancer or Ingress.
  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  # Whoever created this cluster is admin inside Kubernetes
  enable_cluster_creator_admin_permissions = true  

# These are default Kubernetes components AWS installs
#   addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {
#       before_compute = true
#     }
#     kube-proxy             = {}
#     vpc-cni                = {
#       before_compute = true
#     }
#   }
  
  tags = 
    environment = "development"
    application = "myapp"

# This is the node group configuration. We are using AWS managed node groups, which means that AWS will take care of provisioning and managing the EC2 instances that will run our Kubernetes worker nodes.
  eks_managed_node_groups = {
    dev = {
    instance_types = ["t2.small"]
    ami_type       = "AL2023_x86_64_STANDARD"
    min_size       = 1
    max_size       = 3
    desired_size   = 3
    }
  }
}