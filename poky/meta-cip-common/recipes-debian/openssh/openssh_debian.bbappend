# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

# modify sshd_config
do_install_append() {
    # remove hmac-sha2-512 from MACs.
    # ssh client teraterm cannot connect to the ssh server via hmac-sha2-512.
    APPEND_LINE="# Remove hmac-sha2-512 as a workaround to enforced disconnection from teraterm"
    sed -i '$ a '"$APPEND_LINE"'' ${D}${sysconfdir}/ssh/sshd_config
    APPEND_LINE="MACs umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256"
    sed -i '$ a '"$APPEND_LINE"'' ${D}${sysconfdir}/ssh/sshd_config
}
