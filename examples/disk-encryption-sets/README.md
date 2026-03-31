This example showcases disk encryption set support for managed disks using the disk-encryption-sets submodule.

## Notes

The submodule creates the disk encryption set and grants it access to the key vault key. To attach the encryption set to a managed disk in a single apply, use `instance.disk_encryption_set_ids` instead of `disk_encryption_set_id` inside each disk — this keeps the disk map keys resolvable at plan time.
