This example illustrates a virtual machine deployed in an availability zone with data disks.

## Notes

Data disks inherit the virtual machine zone unless `zone` is set on the disk. Zone-redundant disks (`*_ZRS`) span all zones, are always created without a zone and reject a `zone` set on the disk.
