local_repository(
    name = "r2",
    path = __workspace_dir__ + "/r2",
)

load("@r2//:bzl_repos.bzl", "setup_repos")

setup_repos()

load("@r2//:toolchain.bzl", "setup_toolchains")

setup_toolchains()
