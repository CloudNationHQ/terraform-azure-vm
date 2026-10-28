This example illustrates a virtual machine deployed in an availability zone with data disks.

## Notes

Data disks inherit the virtual machine zone unless `zone` is set on the disk. On a zonal virtual machine a disk zone must match the virtual machine zone; on a non-zonal virtual machine any disk zone is allowed. Zone-redundant disks (`*_ZRS`) span all zones, are always created without a zone and reject a `zone` set on the disk.
