# Abbreviations and Terminology

## Abbreviations

|         |                                                                                          |
| ------- | ---------------------------------------------------------------------------------------- |
| AV      | Access Vector                                                                            |
| AVC     | Access Vector Cache                                                                      |
| BLP     | Bell-La Padula                                                                           |
| CC      | [Common Criteria](http://www.commoncriteriaportal.org/)                                  |
| CIL     | Common Intermediate Language                                                             |
| CMW     | Compartmented Mode Workstation                                                           |
| DAC     | Discretionary Access Control                                                             |
| FLASK   | Flux Advanced Security Kernel                                                            |
| Fluke   | Flux kernel Environment                                                                  |
| Flux    | The Flux Research Group                                                                  |
| ID      | Identification                                                                           |
| LSM     | Linux Security Module                                                                    |
| LAPP    | Linux, Apache, PostgreSQL, PHP / Perl / Python                                           |
| LSPP    | Labeled Security Protection Profile                                                      |
| MAC     | Mandatory Access Control                                                                 |
| MCS     | Multi-Category Security                                                                  |
| MLS     | Multi-Level Security                                                                     |
| MMAC    | Middleware Mandatory Access Control                                                      |
| NSA     | National Security Agency                                                                 |
| OM      | Object Manager                                                                           |
| OTA     | over the air                                                                             |
| PAM     | Pluggable Authentication Module                                                          |
| RBAC    | Role-based Access Control                                                                |
| RBACSEP | Role-based Access Control Separation                                                     |
| rpm     | Red Hat Package Manager                                                                  |
| SELinux | Security Enhanced Linux                                                                  |
| SID     | Security Identifier                                                                      |
| SMACK   | [Simplified Mandatory Access Control Kernel](http://www.schaufler-ca.com/)               |
| SUID    | Super-user Identifier                                                                    |
| TE      | Type Enforcement                                                                         |
| UID     | User Identifier                                                                          |
| XACE    | X (windows) Access Control Extension                                                     |

## Terminology

These give a brief introduction to the major components that form the
core SELinux infrastructure.

<table>
<tbody>
<tr>
<td>Access Vector (AV)</td>
<td>A bit map representing a set of permissions (such as open, read, write).</td>
</tr>
<tr>
<td>Access Vector Cache (AVC)</td>
<td><p>A component that stores access decisions made by the SELinux <strong>Security Server</strong> for subsequent use by <strong>Object Managers</strong>. This allows previous decisions to be retrieved without the overhead of re-computation.</p>
<p>Within the core SELinux services there are two <strong>Access Vector Caches</strong>:</p></td>
</tr>
<tr>
<td>Domain</td>
<td>For SELinux this consists of one or more processes associated to the type component of a <strong>Security Context</strong>. <strong>Type Enforcement</strong> rules declared in Policy describe how the domain will interact with objects (see <strong>Object Class</strong>).</td>
</tr>
<tr>
<td>Linux Security Module (LSM)</td>
<td><p>A framework that provides hooks into kernel components (such as disk and network services) that can be utilised by security modules (e.g. SELinux and SMACK) to perform access control checks.</p>
<p>Currently only one LSM module can be loaded, however work is in progress to stack multiple modules).</p></td>
</tr>
<tr>
<td>Mandatory Access Control</td>
<td>An access control mechanisim enforced by the system. This can be achieved by 'hard-wiring' the operating system and applications (the bad old days - well good for some) or via a policy that conforms to a <strong>Policy</strong>. Examples of policy based MAC are SELinux and SMACK.</td>
</tr>
<tr>
<td>Multi-Level Security (MLS)</td>
<td>Based on the Bell-La &amp; Padula model (BLP) for confidentiality in that (for example) a process running at a 'Confidential' level can read / write at their current level but only read down levels or write up levels. While still used in this way, it is more commonly used for application separation utilising the Multi-Category Security (MCS) variant.</td>
</tr>
<tr>
<td>Object Class</td>
<td><p>Describes a resource such as files, sockets or services.</p>
<p>Each 'class' has relevant permissions associated to it such as read, write or export. This allows access to be enforced on the instantiated object by their <strong>Object Manager</strong>. </p></td>
</tr>
<tr>
<td>Object Manager</td>
<td><p>Userspace and kernel components that are responsible for the labeling, management (e.g. creation, access, destruction) and enforcement of the objects under their control. <strong>Object Managers</strong> call the <strong>Security Server</strong> for an access decision based on a source and target <strong>Security Context</strong> (or <strong>SID</strong>), an <strong>Object Class</strong> and a set of permissions (or <strong>AV</strong>s). The <strong>Security Server</strong> will base its decision on whether the currently loaded <strong>Policy</strong> will allow or deny access.</p>
<p>An <strong>Object Manager</strong> may also call the <strong>Security Server</strong> to compute a new <strong>Security Context</strong> or <strong>SID</strong> for an object.</p></td>
</tr>
<tr>
<td>Policy</td>
<td>A set of rules determining access rights. In SELinux these rules are generally written in a kernel policy language using either <em><strong>m4</strong>(1)</em> macro support (e.g. Reference Policy) or the new CIL language. The <strong>Policy</strong> is then compiled into a binary format for loading into the <strong>Security Server</strong>.</td>
</tr>
<tr>
<td>Role Based Access Control</td>
<td>SELinux users are associated to one or more roles, each role may then be associated to one or more <strong>Domain</strong> types.</td>
</tr>
<tr>
<td>Role Based Access Control-Seperation</td>
<td><p>Role-based separation of user home directories. An optional policy tunable is required:</p>
<p>tunableif enable_rbacsep</p></td>
</tr>
<tr>
<td>Security Server</td>
<td><p>A sub-system in the Linux kernel that makes access decisions and computes security contexts based on <strong>Policy</strong> on behalf of SELinux-aware applications and Object Managers.</p>
<p>The<strong> Security Server</strong> does not enforce a decision, it merely states whether the operation is allowed or not according to the <strong>Policy</strong>. It is the SELinux-aware application or <strong>Object Manager</strong> responsibility to enforce the decision.</p></td>
</tr>
<tr>
<td>Security Context</td>
<td><p>An SELinux <strong>Security Context</strong> is a variable length string that consists of the following mandatory components <em>user:role:type</em> and an optional <em>[:range]</em> component.</p>
<p>Generally abbreviated to 'context', and sometimes called a 'label'.</p></td>
</tr>
<tr>
<td>Security Identifier (SID)</td>
<td><p>SIDs are unique opaque integer values mapped by the kernel <strong>Security Server</strong> and userspace AVC that represent a <strong>Security Context</strong>.</p>
<p>The SIDs generated by the kernel <strong>Security Server</strong> are <em>u32</em> values that are passed via the <strong>Linux Security Module</strong> hooks to/from the kernel <strong>Object Managers</strong>.</p></td>
</tr>
<tr>
<td>Type Enforcement</td>
<td>SELinux makes use of a specific style of type enforcement (TE) to enforce <strong>Mandatory Access Control</strong>. This is where all subjects and objects have a type identifier associated to them that can then be used to enforce rules laid down by <strong>Policy</strong>.</td>
</tr>
</tbody>
</table>

<!-- %CUTHERE% -->

---
**[[ PREV ]](toc.md)** **[[ TOP ]](#)** **[[ NEXT ]](selinux_overview.md)**
