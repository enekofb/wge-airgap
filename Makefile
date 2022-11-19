all: images charts

images: pull-images push-images

charts: pull-charts push-charts

push-images:
	bash images/wge-load-images.sh -i wge-images.tar.gz -r myregistry.domain.com:5000

pull-images:
	 kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec['containers','initContainers'][*].image}" |tr -s '[[:space:]]' '\n' \
	| sort | uniq | grep -vE 'kindest|kube-(.*)|etcd|coredns' | tee wge-images.txt
	bash images/wge-save-images.sh -l wge-images.txt

pull-charts:
	vendir sync  -f charts/wge.yml

push-charts:
	helm cm-push -f ./charts/tmp/cert-manager/cert-manager-0.0.8.tgz private
	helm cm-push -f ./charts/tmp/tf-controller/tf-controller-0.9.2.tgz private
	helm cm-push -f ./charts/tmp/wge/mccp-10.0.0-rc.1.tgz private



