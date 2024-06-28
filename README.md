The `--@r2//starlark:css_processor_type` flag control the outputs of `scss_binary`:

`bazelisk build --@r2//starlark:css_processor_type=lightningcss  //...` will output:
```
Target //:scss_binary_root up-to-date:
  bazel-bin/scss_binary_root.css
  bazel-bin/scss_binary_root_lightningcss.out
```

`bazelisk build //..` will output:
```
Target //:scss_binary_root up-to-date:
  bazel-bin/scss_binary_root.css
  bazel-bin/scss_binary_root_postcss.out
```

Passing an illegal value (`bazelisk build --@r2//starlark:css_processor_type=lightnis  //..`) will fail the build:
```
ERROR: /private/var/tmp/_bazel_mennyevendanan/86fbf581dec8654f534e7d4ff3f42ae4/external/r2/starlark/BUILD:6:14: in css_processor rule @@r2//starlark:css_processor_type:
Traceback (most recent call last):
	File "/private/var/tmp/_bazel_mennyevendanan/86fbf581dec8654f534e7d4ff3f42ae4/external/r2/starlark/scss.bzl", line 8, column 13, in _css_processor_build_setting_impl
		fail("{label} was created with css-processor type '{raw_type}' which is not in [{values}].".format(
Error in fail: @r2//starlark:css_processor_type was created with css-processor type 'lightnis' which is not in [postcss, lightningcss].
ERROR: /private/var/tmp/_bazel_mennyevendanan/86fbf581dec8654f534e7d4ff3f42ae4/external/r2/starlark/BUILD:6:14: Analysis of target '@@r2//starlark:css_processor_type' failed
ERROR: Analysis of target '//:scss_binary_root' failed; build aborted: Analysis failed
```

Running the tests in the root WORKSPACE passes for all tests:
```
bazelisk test @r2//...
INFO: Analyzed 6 targets (0 packages loaded, 0 targets configured).
INFO: Found 2 targets and 4 test targets...
INFO: Elapsed time: 0.272s, Critical Path: 0.11s
INFO: 5 processes: 8 linux-sandbox.
INFO: Build completed successfully, 5 total actions
@r2//starlark:tests_lightningcss_scss_binary_test                        PASSED in 0.0s
@r2//starlark:tests_postcss_as_default_scss_binary_test                  PASSED in 0.0s
@r2//starlark:tests_postcss_scss_binary_test                             PASSED in 0.0s
@r2//starlark:tests_unknown_processor_scss_binary_test                   PASSED in 0.0s
```

Running the tests in the nested WORKSPACE (`r2`) shows a failure when doing config_setting transitions:
```
bazelisk test @r2//...
INFO: Analyzed 6 targets (0 packages loaded, 0 targets configured).
FAIL: //starlark:tests_lightningcss_scss_binary_test (see /home/menny/.cache/bazel/_bazel_menny/4d6896445dfb68a24aa652832a8899c3/execroot/r2/bazel-out/k8-fastbuild/testlogs/starlark/tests_lightningcss_scss_binary_test/test.log)
FAIL: //starlark:tests_unknown_processor_scss_binary_test (see /home/menny/.cache/bazel/_bazel_menny/4d6896445dfb68a24aa652832a8899c3/execroot/r2/bazel-out/k8-fastbuild/testlogs/starlark/tests_unknown_processor_scss_binary_test/test.log)
INFO: Found 2 targets and 4 test targets...
INFO: Elapsed time: 0.184s, Critical Path: 0.06s
INFO: 3 processes: 4 linux-sandbox.
INFO: Build completed, 2 tests FAILED, 3 total actions
//starlark:tests_postcss_as_default_scss_binary_test            (cached) PASSED in 0.0s
//starlark:tests_postcss_scss_binary_test                       (cached) PASSED in 0.0s
//starlark:tests_lightningcss_scss_binary_test                           FAILED in 0.0s
  /home/menny/.cache/bazel/_bazel_menny/4d6896445dfb68a24aa652832a8899c3/execroot/r2/bazel-out/k8-fastbuild/testlogs/starlark/tests_lightningcss_scss_binary_test/test.log
//starlark:tests_unknown_processor_scss_binary_test                      FAILED in 0.0s
  /home/menny/.cache/bazel/_bazel_menny/4d6896445dfb68a24aa652832a8899c3/execroot/r2/bazel-out/k8-fastbuild/testlogs/starlark/tests_unknown_processor_scss_binary_test/test.log

Executed 2 out of 4 tests: 2 tests pass and 2 fail locally.
There were tests whose specified size is too big. Use the --test_verbose_timeout_warnings command line option to see which ones these are.
```
