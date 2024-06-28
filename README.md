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

Running the tests in the nested WORKSPACE (`r2`) shows a failure when doing config_setting transitions:
```
r2 git:(main) ✗ bazelisk test //...
DEBUG: /Users/mennyevendanan/dev/menny/test-config-bazel-repo/r2/starlark/scss.bzl:22:10: css_processor_type: <target //starlark:css_processor_type>
DEBUG: /Users/mennyevendanan/dev/menny/test-config-bazel-repo/r2/starlark/scss.bzl:22:10: css_processor_type: <target //starlark:css_processor_type>
DEBUG: /Users/mennyevendanan/dev/menny/test-config-bazel-repo/r2/starlark/scss.bzl:22:10: css_processor_type: <target //starlark:css_processor_type>
DEBUG: /Users/mennyevendanan/dev/menny/test-config-bazel-repo/r2/starlark/scss.bzl:22:10: css_processor_type: <target //starlark:css_processor_type>
DEBUG: /Users/mennyevendanan/dev/menny/test-config-bazel-repo/r2/starlark/scss.bzl:22:10: css_processor_type: <target //starlark:css_processor_type>
DEBUG: /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/external/bazel_skylib/lib/unittest.bzl:465:10: In test _scss_binary_test_impl from //starlark:test_scss.bzl: Expected "True", but got "False"
DEBUG: /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/external/bazel_skylib/lib/unittest.bzl:465:10: In test _scss_binary_test_failure_impl from //starlark:test_scss.bzl: Expected failure of target_under_test, but found success
INFO: Analyzed 6 targets (38 packages loaded, 181 targets configured).
FAIL: //starlark:tests_lightningcss_scss_binary_test (see /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/execroot/r2/bazel-out/darwin_arm64-fastbuild/testlogs/starlark/tests_lightningcss_scss_binary_test/test.log)
FAIL: //starlark:tests_unknown_processor_scss_binary_test (see /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/execroot/r2/bazel-out/darwin_arm64-fastbuild/testlogs/starlark/tests_unknown_processor_scss_binary_test/test.log)
INFO: Found 2 targets and 4 test targets...
INFO: Elapsed time: 1.083s, Critical Path: 0.44s
INFO: 23 processes: 15 internal, 8 darwin-sandbox.
INFO: Build completed, 2 tests FAILED, 23 total actions
//starlark:tests_postcss_as_default_scss_binary_test                     PASSED in 0.2s
//starlark:tests_postcss_scss_binary_test                                PASSED in 0.2s
//starlark:tests_lightningcss_scss_binary_test                           FAILED in 0.3s
  /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/execroot/r2/bazel-out/darwin_arm64-fastbuild/testlogs/starlark/tests_lightningcss_scss_binary_test/test.log
//starlark:tests_unknown_processor_scss_binary_test                      FAILED in 0.3s
  /private/var/tmp/_bazel_mennyevendanan/616d65f3c4e5b0f6f418367e3ebc5577/execroot/r2/bazel-out/darwin_arm64-fastbuild/testlogs/starlark/tests_unknown_processor_scss_binary_test/test.log

Executed 4 out of 4 tests: 2 tests pass and 2 fail locally.
There were tests whose specified size is too big. Use the --test_verbose_timeout_warnings command line option to see which ones these are.
```
