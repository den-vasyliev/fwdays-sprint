
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_START=true INSTALL_K3S_SKIP_ENABLE=true sh -
sudo k3s server --snapshotter native&
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml 
sudo chmod o+r /etc/rancher/k3s/k3s.yaml
alias k=kubectl
go install github.com/kubecolor/kubecolor@latest
alias kubectl=kubecolor
compdef kubecolor=kubectl
curl -sS https://webi.sh/k9s | sh
alias kk="EDITOR='code --wait' ~/.local/opt/k9s-v0.32.5/bin/k9s"

k version
k get all -A
k get componentstatuses 
k get no
k top no
k api-resources
k cluster-info

k get po -v 7
k get po -v 9

RBAC
k config view
k auth whoami
k auth can-i list pods -n demo
k proxy
k explain csr

echo <client-certificate-data> |base64 -d|openssl x509 -text    

How to add user
https://medium.com/@muppedaanvesh/a-hand-on-guide-to-kubernetes-rbac-with-a-user-creation-%EF%B8%8F-1ad9aa3cafb1

NETWORKING 
cat /proc/sys/net/netfilter/nf_conntrack_max
cat /proc/sys/net/netfilter/nf_conntrack_count

sudo find / -name conntrack
path_to/conntrack -L
path_to/conntrack -E
path_to/conntrack –L –d 10.32.0.1
sudo iptables-save

https://adil.medium.com/how-to-fix-conntrack-table-full-dropping-packets-in-kubernetes-07f561a432aa

HELM
go-demo-app intro - https://github.com/den-vasyliev/go-demo-app

helm template demo ./helm --output-dir test --release-name --create-namespace
helm install demo ./helm -n demo --create-namespace
curl -H "Content-Type: application/json" -d '{"text": "dddabcde"}' localhost:8080 
wget -O /tmp/g.png https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png
curl -F 'image=@/tmp/g.png' localhost:8080

GITOPS
curl -s https://fluxcd.io/install.sh | bash
. <(flux completion zsh)

read -s GITHUB_TOKEN
export GITHUB_TOKEN
export GITHUB_USER=den-vasyliev
flux check --pre

flux bootstrap github \
  --token-auth \
  --owner=$GITHUB_USER \
  --token=$GITHUB_TOKEN \
  --repository=fw-demo \
  --branch=main \
  --path=clusters/k3s \
  --personal=false

flux create source git demo-chart \
--branch master \
--url=https://github.com/den-vasyliev/go-demo-app \
--interval=5m \
--export

flux create helmrelease demo \
    --namespace=demo \
    --target-namespace=demo \
    --interval=10m \
    --source=GitRepository/demo-chart.flux-system \
    --reconcile-strategy=Revision \
    --chart=./helm --export