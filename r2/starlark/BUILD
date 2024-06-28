load(":scss.bzl", "css_processor", "scss_binary")
load(":test_scss.bzl", "scss_binary_test_suite")

package(default_visibility = ["//visibility:public"])

css_processor(
    name = "css_processor_type",
    build_setting_default = "postcss",
)

scss_binary(
    name = "scss_binary",
    my_data = "hello",
)

scss_binary_test_suite(name = "tests")
