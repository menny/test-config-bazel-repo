load("@bazel_skylib//lib:unittest.bzl", "register_unittest_toolchains")
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

def setup_toolchains():
    bazel_skylib_workspace()
    register_unittest_toolchains()
