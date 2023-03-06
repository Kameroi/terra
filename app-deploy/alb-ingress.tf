# https://kubernetes.io/docs/concepts/services-networking/ingress/
# target-type: instance for LB/nodeport services, IP for ClusterIP
resource "kubectl_manifest" "default_ingress" {
  yaml_body = <<-EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  namespace: default
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/load-balancer-name: aws-load-balancer-controller
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: kube-wp
              port:
                number: 8080
EOF
}