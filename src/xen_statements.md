# Xen Statements

Xen policy supports additional policy language statements: *iomemcon*,
*ioportcon*, *pcidevicecon*, *pirqcon* and *devicetreecon* that are
discussed in the sections that follow, also the
[**XSM/FLASK Configuration**](http://xenbits.xen.org/docs/4.2-testing/misc/xsm-flask.txt)
document contains further information.

Policy version 30 introduced the *devicetreecon* statement and also
expanded the existing I/O memory range to 64 bits in order to support
hardware with more than 44 bits of physical address space (32-bit count
of 4K pages).

To compile these additional statements using ***semodule**(8)*, ensure
that the ***semanage.conf**(5)* file has the *policy-target=xen* entry.

## *iomemcon*

Label i/o memory. This may be a single memory location or a range.

**The statement definition is:**

```
iomemcon addr context
```

**Where:**

*iomemcon*

The *iomemcon* keyword.

*addr*

The memory address to apply the context. This may also be a range that consists
of a start and end address separated by a hypen \'-\'.

*context*

The security context to be applied.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Examples:**

```
iomemcon 0xfebd9 system_u:object_r:nicP_t
iomemcon 0xfebe0-0xfebff system_u:object_r:nicP_t
```

## *ioportcon*

Label i/o ports. This may be a single port or a range.

**The statement definition is:**

```
ioportcon port context
```

**Where:**

*ioportcon*

The *ioportcon* keyword.

*port*

The *port* to apply the context. This may also be a range that consists of a
start and end port number separated by a hypen \'-\'.

*context*

The security context to be applied.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Examples:**

```
ioportcon 0xeac0 system_u:object_r:nicP_t
ioportcon 0xecc0-0xecdf system_u:object_r:nicP_t
```

## *pcidevicecon*

Label a PCI device.

**The statement definition is:**

```
pcidevicecon pci_id context
```

**Where:**

*pcidevicecon*

The *pcidevicecon* keyword.

*pci_id*

The PCI indentifer.

*context*

The security context to be applied.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
pcidevicecon 0xc800 system_u:object_r:nicP_t
```

## *pirqcon*

Label an interrupt level.

**The statement definition is:**

```
pirqcon irq context
```

**Where:**

*pirqcon*

The *pirqcon* keyword.

*irq*

The interrupt request number.

*context*

The security context to be applied.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
pirqcon 33 system_u:object_r:nicP_t
```

## *devicetreecon*

Label device tree nodes.

**The statement definition is:**

```
devicetreecon path context
```

**Where:**

*devicetreecon*

The *devicetreecon* keyword.

*path*

The device tree path. If this contains spaces enclose within *""* as shown in
the example.

*context*

The security context to be applied.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
devicetreecon "/this is/a/path" system_u:object_r:arm_path
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](infiniband_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](modular_policy_statements.md)**
