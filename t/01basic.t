#!/usr/bin/env tapsig

cat > tapsig01 <<EOF
name true
tap true

name false
rc_is 1
tap false

name "false and stderr"

cat > false_and_stderr <<EOI
echo foo >&2
exit 1
EOI
chmod +x false_and_stderr

rc_is 1
stderr_is <<EOI
foo
EOI

tap false_and_stderr

done_testing
EOF

stdout_is <<EOF
ok 1 true
ok 2 false
ok 3 false and stderr
1..3
EOF

tap "$current_dir/tapsig" tapsig01

done_testing
