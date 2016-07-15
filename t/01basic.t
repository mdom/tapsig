#!/usr/bin/env tapsig

cat > tapsig01 <<EOF
name true
tap true

name false
rc_is 1
tap false

name "not ok"
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

name file_is

file_is foo <<EOI
foo
EOI

tap sh -c 'echo foo > foo'

name "file_is not identical"

file_is foo <<EOI
foo
EOI

tap sh -c 'echo bar > foo'

todo foo
tap true

todo bar
tap false

done_testing
EOF

stdout_is <<EOF
ok 1 true
ok 2 false
not ok 3 not ok
ok 4 false and stderr
ok 5 file_is
# 1c1
# < foo
# ---
# > bar
not ok 6 file_is not identical
ok 7 # TODO foo
not ok 8 # TODO bar
1..8
EOF

tap "$current_dir/tapsig" tapsig01

done_testing
