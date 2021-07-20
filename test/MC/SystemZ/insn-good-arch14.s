# For arch14 and above.
# RUN: llvm-mc -triple s390x-linux-gnu -mcpu=arch14 -show-encoding %s \
# RUN:   | FileCheck %s

#CHECK: lbear	0                       # encoding: [0xb2,0x00,0x00,0x00]
#CHECK: lbear	0(%r1)                  # encoding: [0xb2,0x00,0x10,0x00]
#CHECK: lbear	0(%r15)                 # encoding: [0xb2,0x00,0xf0,0x00]
#CHECK: lbear	4095                    # encoding: [0xb2,0x00,0x0f,0xff]
#CHECK: lbear	4095(%r1)               # encoding: [0xb2,0x00,0x1f,0xff]
#CHECK: lbear	4095(%r15)              # encoding: [0xb2,0x00,0xff,0xff]

	lbear	0
	lbear	0(%r1)
	lbear	0(%r15)
	lbear	4095
	lbear	4095(%r1)
	lbear	4095(%r15)

#CHECK: lpswey	-524288                 # encoding: [0xeb,0x00,0x00,0x00,0x80,0x71]
#CHECK: lpswey	-1                      # encoding: [0xeb,0x00,0x0f,0xff,0xff,0x71]
#CHECK: lpswey	0                       # encoding: [0xeb,0x00,0x00,0x00,0x00,0x71]
#CHECK: lpswey	1                       # encoding: [0xeb,0x00,0x00,0x01,0x00,0x71]
#CHECK: lpswey	524287                  # encoding: [0xeb,0x00,0x0f,0xff,0x7f,0x71]
#CHECK: lpswey	0(%r1)                  # encoding: [0xeb,0x00,0x10,0x00,0x00,0x71]
#CHECK: lpswey	0(%r15)                 # encoding: [0xeb,0x00,0xf0,0x00,0x00,0x71]
#CHECK: lpswey	524287(%r1)             # encoding: [0xeb,0x00,0x1f,0xff,0x7f,0x71]
#CHECK: lpswey	524287(%r15)            # encoding: [0xeb,0x00,0xff,0xff,0x7f,0x71]

	lpswey	-524288
	lpswey	-1
	lpswey	0
	lpswey	1
	lpswey	524287
	lpswey	0(%r1)
	lpswey	0(%r15)
	lpswey	524287(%r1)
	lpswey	524287(%r15)

#CHECK: nnpa                            # encoding: [0xb9,0x3b,0x00,0x00]

	nnpa

#CHECK: qpaci	0                  	# encoding: [0xb2,0x8f,0x00,0x00]
#CHECK: qpaci	0(%r1)             	# encoding: [0xb2,0x8f,0x10,0x00]
#CHECK: qpaci	0(%r15)            	# encoding: [0xb2,0x8f,0xf0,0x00]
#CHECK: qpaci	4095                 	# encoding: [0xb2,0x8f,0x0f,0xff]
#CHECK: qpaci	4095(%r1)             	# encoding: [0xb2,0x8f,0x1f,0xff]
#CHECK: qpaci	4095(%r15)             	# encoding: [0xb2,0x8f,0xff,0xff]

	qpaci	0
	qpaci	0(%r1)
	qpaci	0(%r15)
	qpaci	4095
	qpaci	4095(%r1)
	qpaci	4095(%r15)

#CHECK: rdp	%r0, %r0, %r0           # encoding: [0xb9,0x8b,0x00,0x00]
#CHECK: rdp	%r0, %r0, %r15          # encoding: [0xb9,0x8b,0x00,0x0f]
#CHECK: rdp	%r0, %r15, %r0          # encoding: [0xb9,0x8b,0xf0,0x00]
#CHECK: rdp	%r15, %r0, %r0          # encoding: [0xb9,0x8b,0x00,0xf0]
#CHECK: rdp	%r0, %r0, %r0, 15       # encoding: [0xb9,0x8b,0x0f,0x00]
#CHECK: rdp	%r4, %r5, %r6, 7        # encoding: [0xb9,0x8b,0x57,0x46]

	rdp	%r0, %r0, %r0
	rdp	%r0, %r0, %r15
	rdp	%r0, %r15, %r0
	rdp	%r15, %r0, %r0
	rdp	%r0, %r0, %r0, 15
	rdp	%r4, %r5, %r6, 7

#CHECK: stbear	0                       # encoding: [0xb2,0x01,0x00,0x00]
#CHECK: stbear	0(%r1)                  # encoding: [0xb2,0x01,0x10,0x00]
#CHECK: stbear	0(%r15)                 # encoding: [0xb2,0x01,0xf0,0x00]
#CHECK: stbear	4095                    # encoding: [0xb2,0x01,0x0f,0xff]
#CHECK: stbear	4095(%r1)               # encoding: [0xb2,0x01,0x1f,0xff]
#CHECK: stbear	4095(%r15)              # encoding: [0xb2,0x01,0xff,0xff]

	stbear	0
	stbear	0(%r1)
	stbear	0(%r15)
	stbear	4095
	stbear	4095(%r1)
	stbear	4095(%r15)

#CHECK: vcfn	%v0, %v0, 0, 0          # encoding: [0xe6,0x00,0x00,0x00,0x00,0x5d]
#CHECK: vcfn	%v0, %v0, 15, 0         # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x5d]
#CHECK: vcfn	%v0, %v0, 0, 15         # encoding: [0xe6,0x00,0x00,0x0f,0x00,0x5d]
#CHECK: vcfn	%v0, %v15, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x5d]
#CHECK: vcfn	%v0, %v31, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x5d]
#CHECK: vcfn	%v15, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x5d]
#CHECK: vcfn	%v31, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x5d]
#CHECK: vcfn	%v14, %v17, 11, 9       # encoding: [0xe6,0xe1,0x00,0x09,0xb4,0x5d]

	vcfn	%v0, %v0, 0, 0
	vcfn	%v0, %v0, 15, 0
	vcfn	%v0, %v0, 0, 15
	vcfn	%v0, %v15, 0, 0
	vcfn	%v0, %v31, 0, 0
	vcfn	%v15, %v0, 0, 0
	vcfn	%v31, %v0, 0, 0
	vcfn	%v14, %v17, 11, 9

#CHECK: vclfnl	%v0, %v0, 0, 0          # encoding: [0xe6,0x00,0x00,0x00,0x00,0x5e]
#CHECK: vclfnl	%v0, %v0, 15, 0         # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x5e]
#CHECK: vclfnl	%v0, %v0, 0, 15         # encoding: [0xe6,0x00,0x00,0x0f,0x00,0x5e]
#CHECK: vclfnl	%v0, %v15, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x5e]
#CHECK: vclfnl	%v0, %v31, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x5e]
#CHECK: vclfnl	%v15, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x5e]
#CHECK: vclfnl	%v31, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x5e]
#CHECK: vclfnl	%v14, %v17, 11, 9       # encoding: [0xe6,0xe1,0x00,0x09,0xb4,0x5e]

	vclfnl	%v0, %v0, 0, 0
	vclfnl	%v0, %v0, 15, 0
	vclfnl	%v0, %v0, 0, 15
	vclfnl	%v0, %v15, 0, 0
	vclfnl	%v0, %v31, 0, 0
	vclfnl	%v15, %v0, 0, 0
	vclfnl	%v31, %v0, 0, 0
	vclfnl	%v14, %v17, 11, 9

#CHECK: vclfnh	%v0, %v0, 0, 0          # encoding: [0xe6,0x00,0x00,0x00,0x00,0x56]
#CHECK: vclfnh	%v0, %v0, 15, 0         # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x56]
#CHECK: vclfnh	%v0, %v0, 0, 15         # encoding: [0xe6,0x00,0x00,0x0f,0x00,0x56]
#CHECK: vclfnh	%v0, %v15, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x56]
#CHECK: vclfnh	%v0, %v31, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x56]
#CHECK: vclfnh	%v15, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x56]
#CHECK: vclfnh	%v31, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x56]
#CHECK: vclfnh	%v14, %v17, 11, 9       # encoding: [0xe6,0xe1,0x00,0x09,0xb4,0x56]

	vclfnh	%v0, %v0, 0, 0
	vclfnh	%v0, %v0, 15, 0
	vclfnh	%v0, %v0, 0, 15
	vclfnh	%v0, %v15, 0, 0
	vclfnh	%v0, %v31, 0, 0
	vclfnh	%v15, %v0, 0, 0
	vclfnh	%v31, %v0, 0, 0
	vclfnh	%v14, %v17, 11, 9

#CHECK: vcnf	%v0, %v0, 0, 0          # encoding: [0xe6,0x00,0x00,0x00,0x00,0x55]
#CHECK: vcnf	%v0, %v0, 15, 0         # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x55]
#CHECK: vcnf	%v0, %v0, 0, 15         # encoding: [0xe6,0x00,0x00,0x0f,0x00,0x55]
#CHECK: vcnf	%v0, %v15, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x55]
#CHECK: vcnf	%v0, %v31, 0, 0         # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x55]
#CHECK: vcnf	%v15, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x55]
#CHECK: vcnf	%v31, %v0, 0, 0         # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x55]
#CHECK: vcnf	%v14, %v17, 11, 9       # encoding: [0xe6,0xe1,0x00,0x09,0xb4,0x55]

	vcnf	%v0, %v0, 0, 0
	vcnf	%v0, %v0, 15, 0
	vcnf	%v0, %v0, 0, 15
	vcnf	%v0, %v15, 0, 0
	vcnf	%v0, %v31, 0, 0
	vcnf	%v15, %v0, 0, 0
	vcnf	%v31, %v0, 0, 0
	vcnf	%v14, %v17, 11, 9

#CHECK: vcrnf	%v0, %v0, %v0, 0, 0     # encoding: [0xe6,0x00,0x00,0x00,0x00,0x75]
#CHECK: vcrnf	%v0, %v0, %v0, 15, 0    # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x75]
#CHECK: vcrnf	%v0, %v0, %v0, 0, 15    # encoding: [0xe6,0x00,0x00,0x0f,0x00,0x75]
#CHECK: vcrnf	%v0, %v0, %v31, 0, 0    # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x75]
#CHECK: vcrnf	%v0, %v31, %v0, 0, 0    # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x75]
#CHECK: vcrnf	%v31, %v0, %v0, 0, 0    # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x75]
#CHECK: vcrnf	%v18, %v3, %v20, 11, 9  # encoding: [0xe6,0x23,0x40,0x09,0xba,0x75]

	vcrnf	%v0, %v0, %v0, 0, 0
	vcrnf	%v0, %v0, %v0, 15, 0
	vcrnf	%v0, %v0, %v0, 0, 15
	vcrnf	%v0, %v0, %v31, 0, 0
	vcrnf	%v0, %v31, %v0, 0, 0
	vcrnf	%v31, %v0, %v0, 0, 0
	vcrnf	%v18, %v3, %v20, 11, 9

#CHECK: vclzdp	%v0, %v0, 0             # encoding: [0xe6,0x00,0x00,0x00,0x00,0x51]
#CHECK: vclzdp	%v0, %v0, 15            # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x51]
#CHECK: vclzdp	%v0, %v15, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x51]
#CHECK: vclzdp	%v0, %v31, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x51]
#CHECK: vclzdp	%v15, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x51]
#CHECK: vclzdp	%v31, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x51]
#CHECK: vclzdp	%v18, %v3, 12           # encoding: [0xe6,0x23,0x00,0xc0,0x08,0x51]

	vclzdp	%v0, %v0, 0
	vclzdp	%v0, %v0, 15
	vclzdp	%v0, %v15, 0
	vclzdp	%v0, %v31, 0
	vclzdp	%v15, %v0, 0
	vclzdp	%v31, %v0, 0
	vclzdp	%v18, %v3, 12

#CHECK: vcsph	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x00,0x7d]
#CHECK: vcsph	%v0, %v0, %v0, 15       # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x7d]
#CHECK: vcsph	%v0, %v0, %v15, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x00,0x7d]
#CHECK: vcsph	%v0, %v0, %v31, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x7d]
#CHECK: vcsph	%v0, %v15, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x7d]
#CHECK: vcsph	%v0, %v31, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x7d]
#CHECK: vcsph	%v15, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x7d]
#CHECK: vcsph	%v31, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x7d]
#CHECK: vcsph	%v18, %v3, %v20, 12     # encoding: [0xe6,0x23,0x40,0xc0,0x0a,0x7d]

	vcsph	%v0, %v0, %v0, 0
	vcsph	%v0, %v0, %v0, 15
	vcsph	%v0, %v0, %v15, 0
	vcsph	%v0, %v0, %v31, 0
	vcsph	%v0, %v15, %v0, 0
	vcsph	%v0, %v31, %v0, 0
	vcsph	%v15, %v0, %v0, 0
	vcsph	%v31, %v0, %v0, 0
	vcsph	%v18, %v3, %v20, 12

#CHECK: vpkzr	%v0, %v0, %v0, 0, 0     # encoding: [0xe6,0x00,0x00,0x00,0x00,0x70]
#CHECK: vpkzr	%v0, %v0, %v0, 0, 15    # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x70]
#CHECK: vpkzr	%v0, %v0, %v0, 255, 0   # encoding: [0xe6,0x00,0x00,0x0f,0xf0,0x70]
#CHECK: vpkzr	%v0, %v0, %v31, 0, 0    # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x70]
#CHECK: vpkzr	%v0, %v31, %v0, 0, 0    # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x70]
#CHECK: vpkzr	%v31, %v0, %v0, 0, 0    # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x70]
#CHECK: vpkzr	%v13, %v17, %v21, 121, 11 # encoding: [0xe6,0xd1,0x50,0xb7,0x96,0x70]

	vpkzr	%v0, %v0, %v0, 0, 0
	vpkzr	%v0, %v0, %v0, 0, 15
	vpkzr	%v0, %v0, %v0, 255, 0
	vpkzr	%v0, %v0, %v31, 0, 0
	vpkzr	%v0, %v31, %v0, 0, 0
	vpkzr	%v31, %v0, %v0, 0, 0
	vpkzr	%v13, %v17, %v21, 0x79, 11

#CHECK: vschp	%v0, %v0, %v0, 0, 0     # encoding: [0xe6,0x00,0x00,0x00,0x00,0x74]
#CHECK: vschp	%v0, %v0, %v0, 15, 0    # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x74]
#CHECK: vschp	%v0, %v0, %v0, 0, 0     # encoding: [0xe6,0x00,0x00,0x00,0x00,0x74]
#CHECK: vschp	%v0, %v0, %v0, 15, 0    # encoding: [0xe6,0x00,0x00,0x00,0xf0,0x74]
#CHECK: vschp	%v0, %v0, %v0, 0, 12    # encoding: [0xe6,0x00,0x00,0xc0,0x00,0x74]
#CHECK: vschp	%v0, %v0, %v15, 0, 0    # encoding: [0xe6,0x00,0xf0,0x00,0x00,0x74]
#CHECK: vschp	%v0, %v0, %v31, 0, 0    # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x74]
#CHECK: vschp	%v0, %v15, %v0, 0, 0    # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x74]
#CHECK: vschp	%v0, %v31, %v0, 0, 0    # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x74]
#CHECK: vschp	%v15, %v0, %v0, 0, 0    # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x74]
#CHECK: vschp	%v31, %v0, %v0, 0, 0    # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x74]
#CHECK: vschp	%v18, %v3, %v20, 11, 4  # encoding: [0xe6,0x23,0x40,0x40,0xba,0x74]
#CHECK: vschp	%v18, %v3, %v20, 0, 15  # encoding: [0xe6,0x23,0x40,0xf0,0x0a,0x74]

	vschp	%v0, %v0, %v0, 0, 0
	vschp	%v0, %v0, %v0, 15, 0
	vschp	%v0, %v0, %v0, 0, 0
	vschp	%v0, %v0, %v0, 15, 0
	vschp	%v0, %v0, %v0, 0, 12
	vschp	%v0, %v0, %v15, 0, 0
	vschp	%v0, %v0, %v31, 0, 0
	vschp	%v0, %v15, %v0, 0, 0
	vschp	%v0, %v31, %v0, 0, 0
	vschp	%v15, %v0, %v0, 0, 0
	vschp	%v31, %v0, %v0, 0, 0
	vschp	%v18, %v3, %v20, 11, 4
	vschp	%v18, %v3, %v20, 0, 15

#CHECK: vschsp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x20,0x74]
#CHECK: vschsp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x20,0x74]
#CHECK: vschsp	%v0, %v0, %v0, 12       # encoding: [0xe6,0x00,0x00,0xc0,0x20,0x74]
#CHECK: vschsp	%v0, %v0, %v15, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x20,0x74]
#CHECK: vschsp	%v0, %v0, %v31, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x22,0x74]
#CHECK: vschsp	%v0, %v15, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x20,0x74]
#CHECK: vschsp	%v0, %v31, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x24,0x74]
#CHECK: vschsp	%v15, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x20,0x74]
#CHECK: vschsp	%v31, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x28,0x74]
#CHECK: vschsp	%v18, %v3, %v20, 0      # encoding: [0xe6,0x23,0x40,0x00,0x2a,0x74]

	vschsp	%v0, %v0, %v0, 0
	vschsp	%v0, %v0, %v0, 0
	vschsp	%v0, %v0, %v0, 12
	vschsp	%v0, %v0, %v15, 0
	vschsp	%v0, %v0, %v31, 0
	vschsp	%v0, %v15, %v0, 0
	vschsp	%v0, %v31, %v0, 0
	vschsp	%v15, %v0, %v0, 0
	vschsp	%v31, %v0, %v0, 0
	vschsp	%v18, %v3, %v20, 0

#CHECK: vschdp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x30,0x74]
#CHECK: vschdp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x30,0x74]
#CHECK: vschdp	%v0, %v0, %v0, 12       # encoding: [0xe6,0x00,0x00,0xc0,0x30,0x74]
#CHECK: vschdp	%v0, %v0, %v15, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x30,0x74]
#CHECK: vschdp	%v0, %v0, %v31, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x32,0x74]
#CHECK: vschdp	%v0, %v15, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x30,0x74]
#CHECK: vschdp	%v0, %v31, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x34,0x74]
#CHECK: vschdp	%v15, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x30,0x74]
#CHECK: vschdp	%v31, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x38,0x74]
#CHECK: vschdp	%v18, %v3, %v20, 0      # encoding: [0xe6,0x23,0x40,0x00,0x3a,0x74]

	vschdp	%v0, %v0, %v0, 0
	vschdp	%v0, %v0, %v0, 0
	vschdp	%v0, %v0, %v0, 12
	vschdp	%v0, %v0, %v15, 0
	vschdp	%v0, %v0, %v31, 0
	vschdp	%v0, %v15, %v0, 0
	vschdp	%v0, %v31, %v0, 0
	vschdp	%v15, %v0, %v0, 0
	vschdp	%v31, %v0, %v0, 0
	vschdp	%v18, %v3, %v20, 0

#CHECK: vschxp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x40,0x74]
#CHECK: vschxp	%v0, %v0, %v0, 0        # encoding: [0xe6,0x00,0x00,0x00,0x40,0x74]
#CHECK: vschxp	%v0, %v0, %v0, 12       # encoding: [0xe6,0x00,0x00,0xc0,0x40,0x74]
#CHECK: vschxp	%v0, %v0, %v15, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x40,0x74]
#CHECK: vschxp	%v0, %v0, %v31, 0       # encoding: [0xe6,0x00,0xf0,0x00,0x42,0x74]
#CHECK: vschxp	%v0, %v15, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x40,0x74]
#CHECK: vschxp	%v0, %v31, %v0, 0       # encoding: [0xe6,0x0f,0x00,0x00,0x44,0x74]
#CHECK: vschxp	%v15, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x40,0x74]
#CHECK: vschxp	%v31, %v0, %v0, 0       # encoding: [0xe6,0xf0,0x00,0x00,0x48,0x74]
#CHECK: vschxp	%v18, %v3, %v20, 0      # encoding: [0xe6,0x23,0x40,0x00,0x4a,0x74]

	vschxp	%v0, %v0, %v0, 0
	vschxp	%v0, %v0, %v0, 0
	vschxp	%v0, %v0, %v0, 12
	vschxp	%v0, %v0, %v15, 0
	vschxp	%v0, %v0, %v31, 0
	vschxp	%v0, %v15, %v0, 0
	vschxp	%v0, %v31, %v0, 0
	vschxp	%v15, %v0, %v0, 0
	vschxp	%v31, %v0, %v0, 0
	vschxp	%v18, %v3, %v20, 0

#CHECK: vscshp	%v0, %v0, %v0           # encoding: [0xe6,0x00,0x00,0x00,0x00,0x7c]
#CHECK: vscshp	%v0, %v0, %v31          # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x7c]
#CHECK: vscshp	%v0, %v31, %v0          # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x7c]
#CHECK: vscshp	%v31, %v0, %v0          # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x7c]
#CHECK: vscshp	%v18, %v3, %v20         # encoding: [0xe6,0x23,0x40,0x00,0x0a,0x7c]

	vscshp	%v0, %v0, %v0
	vscshp	%v0, %v0, %v31
	vscshp	%v0, %v31, %v0
	vscshp	%v31, %v0, %v0
	vscshp	%v18, %v3, %v20

#CHECK: vsrpr	%v0, %v0, %v0, 0, 0     # encoding: [0xe6,0x00,0x00,0x00,0x00,0x72]
#CHECK: vsrpr	%v0, %v0, %v0, 0, 15    # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x72]
#CHECK: vsrpr	%v0, %v0, %v0, 255, 0   # encoding: [0xe6,0x00,0x00,0x0f,0xf0,0x72]
#CHECK: vsrpr	%v0, %v0, %v31, 0, 0    # encoding: [0xe6,0x00,0xf0,0x00,0x02,0x72]
#CHECK: vsrpr	%v0, %v31, %v0, 0, 0    # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x72]
#CHECK: vsrpr	%v31, %v0, %v0, 0, 0    # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x72]
#CHECK: vsrpr	%v13, %v17, %v21, 121, 11 # encoding: [0xe6,0xd1,0x50,0xb7,0x96,0x72]

	vsrpr	%v0, %v0, %v0, 0, 0
	vsrpr	%v0, %v0, %v0, 0, 15
	vsrpr	%v0, %v0, %v0, 255, 0
	vsrpr	%v0, %v0, %v31, 0, 0
	vsrpr	%v0, %v31, %v0, 0, 0
	vsrpr	%v31, %v0, %v0, 0, 0
	vsrpr	%v13, %v17, %v21, 0x79, 11

#CHECK: vupkzh	%v0, %v0, 0             # encoding: [0xe6,0x00,0x00,0x00,0x00,0x54]
#CHECK: vupkzh	%v0, %v0, 15            # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x54]
#CHECK: vupkzh	%v0, %v15, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x54]
#CHECK: vupkzh	%v0, %v31, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x54]
#CHECK: vupkzh	%v15, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x54]
#CHECK: vupkzh	%v31, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x54]
#CHECK: vupkzh	%v18, %v3, 12           # encoding: [0xe6,0x23,0x00,0xc0,0x08,0x54]

	vupkzh	%v0, %v0, 0
	vupkzh	%v0, %v0, 15
	vupkzh	%v0, %v15, 0
	vupkzh	%v0, %v31, 0
	vupkzh	%v15, %v0, 0
	vupkzh	%v31, %v0, 0
	vupkzh	%v18, %v3, 12

#CHECK: vupkzl	%v0, %v0, 0             # encoding: [0xe6,0x00,0x00,0x00,0x00,0x5c]
#CHECK: vupkzl	%v0, %v0, 15            # encoding: [0xe6,0x00,0x00,0xf0,0x00,0x5c]
#CHECK: vupkzl	%v0, %v15, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x00,0x5c]
#CHECK: vupkzl	%v0, %v31, 0            # encoding: [0xe6,0x0f,0x00,0x00,0x04,0x5c]
#CHECK: vupkzl	%v15, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x00,0x5c]
#CHECK: vupkzl	%v31, %v0, 0            # encoding: [0xe6,0xf0,0x00,0x00,0x08,0x5c]
#CHECK: vupkzl	%v18, %v3, 12           # encoding: [0xe6,0x23,0x00,0xc0,0x08,0x5c]

	vupkzl	%v0, %v0, 0
	vupkzl	%v0, %v0, 15
	vupkzl	%v0, %v15, 0
	vupkzl	%v0, %v31, 0
	vupkzl	%v15, %v0, 0
	vupkzl	%v31, %v0, 0
	vupkzl	%v18, %v3, 12
