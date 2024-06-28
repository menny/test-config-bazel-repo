load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load(":scss.bzl", "scss_binary")

def _scss_binary_test_impl(ctx):
    env = analysistest.begin(ctx)

    target_under_test = analysistest.target_under_test(env)
    output_files = target_under_test[DefaultInfo].files.to_list()

    # Two outputs, css and map
    asserts.equals(env, 2, len(output_files))
    asserts.true(
        env,
        output_files[0].short_path.endswith("/{}.css".format(target_under_test.label.name)),
        msg = "expected output file to be css, but was {}".format(output_files[0].short_path),
    )

    actions = analysistest.target_actions(env)
    asserts.equals(env, 2, len(actions))

    if ctx.attr._verify_lightningcss:
        asserts.equals(env, True, output_files[1].short_path.endswith("lightningcss.out"))
    else:
        asserts.equals(env, True, output_files[1].short_path.endswith("postcss.out"))

    return analysistest.end(env)

def _scss_binary_test_failure_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(env, "@r2//starlark:css_processor_type was created with css-processor type 'blah' which is not in [postcss, lightningcss].")
    return analysistest.end(env)

_scss_binary_postcss_test = analysistest.make(
    _scss_binary_test_impl,
    attrs = {
        "_verify_lightningcss": attr.bool(default = False),
    },
    config_settings = {
        "@r2//starlark:css_processor_type": "postcss",
    },
)

_scss_binary_lightningcss_test = analysistest.make(
    _scss_binary_test_impl,
    attrs = {
        "_verify_lightningcss": attr.bool(default = True),
    },
    config_settings = {
        "@r2//starlark:css_processor_type": "lightningcss",
    },
)

_scss_binary_unknown_test = analysistest.make(
    _scss_binary_test_failure_impl,
    config_settings = {
        "@r2//starlark:css_processor_type": "blah",
    },
    expect_failure = True,
)

_scss_binary_default_test = analysistest.make(
    _scss_binary_test_impl,
    attrs = {
        "_verify_lightningcss": attr.bool(default = False),
    },
)

# Macro to setup the test.
def _scss_binary_test_setup(name, my_data, test_impl):
    under_test = "{}_scss_binary_test_subject".format(name)
    test_target = "{}_scss_binary_test".format(name)
    scss_binary(
        name = under_test,
        my_data = my_data,
        tags = ["manual"],
    )

    test_impl(
        name = test_target,
        target_under_test = ":" + under_test,
        tags = ["manual"],
    )

    return test_target

def scss_binary_test_suite(name):
    """
    Sets up the test suite for the scss binary rule

    Args:
        name (string): The name to use for the test-suite
    """

    native.test_suite(
        name = name,
        tests = [
            _scss_binary_test_setup(name + "_lightningcss", "lightningcss", _scss_binary_lightningcss_test),
            _scss_binary_test_setup(name + "_unknown_processor", "unknown", _scss_binary_unknown_test),
            _scss_binary_test_setup(name + "_postcss", "postcss", _scss_binary_postcss_test),
            _scss_binary_test_setup(name + "_postcss_as_default", "postcss_as_default", _scss_binary_default_test),
        ],
    )
