.PHONY: test

export TF_PATH

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(TF_PATH) ./vm_test.go

#test_extended:
#	cd tests && env go test -v -timeout 60m -run TestVmss ./vmss_extended_test.go
