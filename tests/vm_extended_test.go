package main

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/compute/armcompute"
	"github.com/cloudnationhq/terraform-azure-vm/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type VmDetails struct {
	ResourceGroupName string
	Name              string
}

type VmClient struct {
	subscriptionId string
	vmClient       *armcompute.VirtualMachinesClient
}

func NewVmClient(t *testing.T, subscriptionId string) *VmClient {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "Failed to create credential")

	vmClient, err := armcompute.NewVirtualMachinesClient(subscriptionId, cred, nil)
	require.NoError(t, err, "Failed to create vm client")

	return &VmClient{
		subscriptionId: subscriptionId,
		vmClient:       vmClient,
	}
}

func (c *VmClient) GetVm(ctx context.Context, t *testing.T, details *VmDetails) *armcompute.VirtualMachine {
	resp, err := c.vmClient.Get(ctx, details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get vm")
	return &resp.VirtualMachine
}

func InitializeTerraform(t *testing.T) *terraform.Options {
	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)
	return tfOpts
}

func CleanupTerraform(t *testing.T, tfOpts *terraform.Options) {
	shared.Cleanup(t, tfOpts)
}

func TestVm(t *testing.T) {
	tfOpts := InitializeTerraform(t)
	defer CleanupTerraform(t, tfOpts)

	subscriptionId := terraform.Output(t, tfOpts, "subscription_id")
	vmClient := NewVmClient(t, subscriptionId)

	vmMap := terraform.OutputMap(t, tfOpts, "vm")
	vmDetails := &VmDetails{
		ResourceGroupName: vmMap["resource_group_name"],
		Name:              vmMap["name"],
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancel()

	vm := vmClient.GetVm(ctx, t, vmDetails)
	verifyVm(t, vmDetails, vm)
}

func verifyVm(t *testing.T, details *VmDetails, vm *armcompute.VirtualMachine) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*vm.Name,
		"Virtual machine name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*vm.Properties.ProvisioningState),
		"Virtual machine provisioning state is not Succeeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "vm"),
		"Virtual machine name does not start with the right abbreviation",
	)
}
