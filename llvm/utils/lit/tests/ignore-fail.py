# Check that --ignore-fail produces exit status 0 despite various kinds of
# test failures but doesn't otherwise suppress those failures.

# RUN: not %{lit} -j 1 %{inputs}/ignore-fail | FileCheck %s
# RUN: %{lit} -j 1 --ignore-fail %{inputs}/ignore-fail | FileCheck %s

# END.

# CHECK: FAIL: ignore-fail :: fail.txt
# CHECK: UNRESOLVED: ignore-fail :: unresolved.txt
# CHECK: XFAIL: ignore-fail :: xfail.txt
# CHECK: XPASS: ignore-fail :: xpass.txt

#      CHECK: Testing Time:
# CHECK-NEXT:   Expectedly Failed : 1
# CHECK-NEXT:   Unresolved : 1
# CHECK-NEXT:   Failed : 1
# CHECK-NEXT:   Unexpectedly Passed: 1
#  CHECK-NOT: {{.}}
