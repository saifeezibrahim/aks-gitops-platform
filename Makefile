TF := terraform -chdir=terraform

.PHONY: init plan apply kubeconfig values bootstrap status lint destroy

init:
	$(TF) init

plan:
	$(TF) plan -out=tfplan

apply:
	$(TF) apply tfplan

kubeconfig:
	az aks get-credentials -g "$$($(TF) output -raw resource_group)" -n "$$($(TF) output -raw cluster_name)" --overwrite-existing

values:
	./scripts/render-values.sh

bootstrap:
	./scripts/bootstrap-argocd.sh

status:
	kubectl -n argocd get applications
	kubectl -n sample-app get pods

lint:
	$(TF) fmt -check -recursive
	helm lint charts/sample-app -f charts/sample-app/values-azure.yaml

# Load balancers and disks created inside the cluster go with the resource group.
destroy:
	$(TF) destroy
