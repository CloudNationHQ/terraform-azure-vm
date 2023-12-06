.PHONY: test test_extended

export TF_PATH

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(TF_PATH) ./vm_test.go

test_extended:
	cd tests && env go test -v -timeout 60m -run TestVm ./vm_extended_test.go
