# tapsig

tapsig enables you to test unix commands in an easy and declarative way. You
write down the expected outcome of a test, its stdout, stderr and rc and then
simply call the script. tapsig is a tap producer, so you can use its test files
for any TAP harness.

To run a test, simply call tapsig with a testfile:

```
$ tapsig t/01basic.t
```

A testfile to test _/bin/true_ can be as simple as that:

```
#!/usr/bin/tapsig

tap /bin/true

done_testing
```

This works as tapsig expects a program to produce no output on stderr
and stdout and exit with a return code of zero.

But you can simple tell tapsig that you have different expectations:

```
#!/usr/bin/tapsig

name "Totally different expectations"

rc_is 1

stdout_is <<EOF
Look at me, i'm from stdout!
EOF

stderr_is <<EOF
This should be on stderr!
EOF

tap my_command

done_testing
```

As you can see from the last example, you can also add a name for a test that
makes it easier to track a failing test.

Testfiles are shell scripts, so you can just use anything you would use
normally. Say you  want to test a command with a lot of options and only
one option changes in every test.

```
set -- command --arg0 --arg1 --arg2

for arg in --arg4,--arg5; do
	tap "$@" "$arg"
done
```

And finally, testfiles can contain more on just one test:

```
name true
tap /bin/true

name false
rc_is 1
tap /bin/false

done_testing
```

## Available functions

### tap _COMMAND_ [_ARGS_]...

Calls _COMMAND_ and checks the predeclared expectations.

### done\_testing

Declares the end of tests. _tapsig_ will fail if this function isn't
called at the end of the test file.

### name _NAME_

Sets the name for the next test.

### rc\_is _RC_

Sets the expected return code for the next tap command.

### stdout\_is

Reads the expected content of stdout for the the next tap command
from stdin.

### stderr\_is

Reads the expected content of stderr for the the next tap command
from stdin.

### file\_is _FILE_

Reads the expected content of _FILE_ for the the next tap command
from stdin.

### diag [_MESSAGE_]

Prints a diagnostic message which is guaranteed not to interfere with test
output. Either prints _MESSAGE_ or read the diagnostic output from stdin.

### bail\_out [_REASON_]

Indicates to the harness that things are going so badly all testing should terminate.

### skip _REASON_

Skips the current test. _tapsig_ will output special ok's which a harness
interprets as skipped, but passing, tests.

### todo _REASON_

Declares that the next test is expected to fail. _tapsig_ will
run the test normally, but print out a special flag indicating it is
"todo". Harnesses will interpret failures as being ok.  Should anything
succeed, it will report it as an unexpected success.  You then know the
thing you had todo is done and can remove the function call.

### depends\_on _COMMAND_

Checks if _COMMAND_ is available and skips all tests otherwise.

## Author and Copyright

Copyright (C) 2016 Mario Domgoergen

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
