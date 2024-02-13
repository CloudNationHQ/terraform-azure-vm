# Changelog

## [1.2.1](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.2.0...v1.2.1) (2024-02-13)


### Bug Fixes

* make extensions optional again ([#64](https://github.com/CloudNationHQ/terraform-azure-vm/issues/64)) ([5924e82](https://github.com/CloudNationHQ/terraform-azure-vm/commit/5924e828c359f3ea5f6d1ca0cd927623543a6dfa))

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.1.1...v1.2.0) (2024-02-12)


### Features

* naming variable is optional now ([#62](https://github.com/CloudNationHQ/terraform-azure-vm/issues/62)) ([890875a](https://github.com/CloudNationHQ/terraform-azure-vm/commit/890875a2524fb3abb94372183a3ebb54f8713003))

## [1.1.1](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.1.0...v1.1.1) (2024-02-12)


### Bug Fixes

* refactored for each loop by using static keys in the extension resource to prevent unknown value issues ([#60](https://github.com/CloudNationHQ/terraform-azure-vm/issues/60)) ([f6de31c](https://github.com/CloudNationHQ/terraform-azure-vm/commit/f6de31c66ca182dcee165e825bb9abae1b20af6d))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.0.2...v1.1.0) (2024-01-29)


### Features

* add some missing properties ([#56](https://github.com/CloudNationHQ/terraform-azure-vm/issues/56)) ([99c7448](https://github.com/CloudNationHQ/terraform-azure-vm/commit/99c7448f18ee117e792180651215052887972109))

## [1.0.2](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.0.1...v1.0.2) (2024-01-25)


### Bug Fixes

* separate tags of the nic from the instance ([#54](https://github.com/CloudNationHQ/terraform-azure-vm/issues/54)) ([935301d](https://github.com/CloudNationHQ/terraform-azure-vm/commit/935301d06b84c4622706a6661ee368388e4069a4))

## [1.0.1](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v1.0.0...v1.0.1) (2024-01-24)


### Bug Fixes

* make the disks property in data_disks optional again ([#51](https://github.com/CloudNationHQ/terraform-azure-vm/issues/51)) ([3652a21](https://github.com/CloudNationHQ/terraform-azure-vm/commit/3652a2198e7dec6a384736f0a524671f801e3240))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.9.0...v1.0.0) (2024-01-23)


### ⚠ BREAKING CHANGES

* Enhancing reliability in import scenarios. This change will cause a recreate on existing resources.

### Features

* refined key value configurations for all resources ([#48](https://github.com/CloudNationHQ/terraform-azure-vm/issues/48)) ([fd56760](https://github.com/CloudNationHQ/terraform-azure-vm/commit/fd56760b41c0e7bca183c736caddab4b49768daa))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.8.0...v0.9.0) (2024-01-23)


### Features

* add support for optional plan block ([#47](https://github.com/CloudNationHQ/terraform-azure-vm/issues/47)) ([4ab8f13](https://github.com/CloudNationHQ/terraform-azure-vm/commit/4ab8f13874954e253b203f92d088637c827b5b3a))
* added the ability to override ip config name network interfaces ([#42](https://github.com/CloudNationHQ/terraform-azure-vm/issues/42)) ([9247191](https://github.com/CloudNationHQ/terraform-azure-vm/commit/9247191e487fec57384bcfcc3ab123ada97456c5))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#46](https://github.com/CloudNationHQ/terraform-azure-vm/issues/46)) ([14cf680](https://github.com/CloudNationHQ/terraform-azure-vm/commit/14cf680c0f97714e3f54add18a43709c180d08f2))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#34](https://github.com/CloudNationHQ/terraform-azure-vm/issues/34)) ([a599f7c](https://github.com/CloudNationHQ/terraform-azure-vm/commit/a599f7c38c79cd02bcec2aabe9775a6a40eb2cb9))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#45](https://github.com/CloudNationHQ/terraform-azure-vm/issues/45)) ([55c2eb4](https://github.com/CloudNationHQ/terraform-azure-vm/commit/55c2eb4e82db8bff5091ef6337e074d62fb7ac11))
* small refactor workflows ([#43](https://github.com/CloudNationHQ/terraform-azure-vm/issues/43)) ([a83f3b1](https://github.com/CloudNationHQ/terraform-azure-vm/commit/a83f3b1cf18c153aeadb4afa73af0df08bd04a16))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.7.0...v0.8.0) (2024-01-08)


### Features

* add additional validation in variables ([#32](https://github.com/CloudNationHQ/terraform-azure-vm/issues/32)) ([05bc676](https://github.com/CloudNationHQ/terraform-azure-vm/commit/05bc676dc3bb1d5cd0831ab923dd28f082ac2f04))
* add support for additional user assigned identities ([#31](https://github.com/CloudNationHQ/terraform-azure-vm/issues/31)) ([769f6bc](https://github.com/CloudNationHQ/terraform-azure-vm/commit/769f6bc4c55f91a36491a5c85abb486d04f9c6c0))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.6.0...v0.7.0) (2024-01-04)


### Features

* besided generating passwords or ssh keys within the module itself, it is also possible to use outputs from other modules as well ([#29](https://github.com/CloudNationHQ/terraform-azure-vm/issues/29)) ([753e054](https://github.com/CloudNationHQ/terraform-azure-vm/commit/753e05409b20aa6cee7ae3482268512e8ee2f71a))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.5.0...v0.6.0) (2023-12-21)


### Features

* add optional computer name properties ([#26](https://github.com/CloudNationHQ/terraform-azure-vm/issues/26)) ([ce68bf2](https://github.com/CloudNationHQ/terraform-azure-vm/commit/ce68bf26f9fa5b7b0fa0286340d3df2a4ded81b1))
* **deps:** bump github.com/stretchr/testify in /tests ([#23](https://github.com/CloudNationHQ/terraform-azure-vm/issues/23)) ([bf87c88](https://github.com/CloudNationHQ/terraform-azure-vm/commit/bf87c8837196a6c729a489a3b7137bab9f34d0a3))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#24](https://github.com/CloudNationHQ/terraform-azure-vm/issues/24)) ([660cc62](https://github.com/CloudNationHQ/terraform-azure-vm/commit/660cc6249e1c45ac41b86a3a8f3f3ad021707401))
* **deps:** Bumps https://github.com/gruntwork-io/terratest from 0.46.7 to 0.46.8. ([be40ade](https://github.com/CloudNationHQ/terraform-azure-vm/commit/be40ade9963dce5080247c27c2c5da568b723a00))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.4.0...v0.5.0) (2023-12-08)


### Features

* added an additional example demonstrating how to reference specific subnets in scenarios with multiple virtual machines ([#18](https://github.com/CloudNationHQ/terraform-azure-vm/issues/18)) ([f00c780](https://github.com/CloudNationHQ/terraform-azure-vm/commit/f00c78020909b8da52c10072a67cd9ca1733ed4a))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.3.0...v0.4.0) (2023-12-07)


### Features

* add auto increments on lun id disks ([#15](https://github.com/CloudNationHQ/terraform-azure-vm/issues/15)) ([680e58e](https://github.com/CloudNationHQ/terraform-azure-vm/commit/680e58e3b747c8d7d6df1e565dd79cdf7c17d0bb))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.2.0...v0.3.0) (2023-12-06)


### Features

* add extended tests ([#11](https://github.com/CloudNationHQ/terraform-azure-vm/issues/11)) ([ea913f2](https://github.com/CloudNationHQ/terraform-azure-vm/commit/ea913f24b9eeff99990e464d238d2cefa5d97e3a))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.1.1...v0.2.0) (2023-12-05)


### Features

* add custom data example ([#10](https://github.com/CloudNationHQ/terraform-azure-vm/issues/10)) ([aefd0ea](https://github.com/CloudNationHQ/terraform-azure-vm/commit/aefd0ea2271b9f32f7398fe65f1faf6607ec3521))
* add some missing properties ([#9](https://github.com/CloudNationHQ/terraform-azure-vm/issues/9)) ([0918a83](https://github.com/CloudNationHQ/terraform-azure-vm/commit/0918a83995c99b0ed25fa2207e6c6188f4a8b34e))
* change default windows image sku ([#7](https://github.com/CloudNationHQ/terraform-azure-vm/issues/7)) ([5930e49](https://github.com/CloudNationHQ/terraform-azure-vm/commit/5930e49e8803952afffd8f07bb5d2b22099b2e77))

## [0.1.1](https://github.com/CloudNationHQ/terraform-azure-vm/compare/v0.1.0...v0.1.1) (2023-11-27)


### Bug Fixes

* added managed identity ([#3](https://github.com/CloudNationHQ/terraform-azure-vm/issues/3)) ([d11f38f](https://github.com/CloudNationHQ/terraform-azure-vm/commit/d11f38f7951daabf313a4abb5839005f4da3b54d))

## 0.1.0 (2023-11-24)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-vm/issues/1)) ([137fde0](https://github.com/CloudNationHQ/terraform-azure-vm/commit/137fde0bace1c6246c52bc6aa5220ce1f77a0235))
