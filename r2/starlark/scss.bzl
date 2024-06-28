
CssProcessorInfo = provider("Declares which CSS processor to use. This is controlled via a build config variable.", fields = ["processor"])

def _css_processor_build_setting_impl(ctx):
    raw_type = ctx.build_setting_value
    values = ["postcss", "lightningcss"]
    if raw_type not in values:
        fail("{label} was created with css-processor type '{raw_type}' which is not in [{values}].".format(
            label = str(ctx.label),
            raw_type = raw_type,
            values = ", ".join(values),
        ))

    return CssProcessorInfo(processor = raw_type)

css_processor = rule(
    implementation = _css_processor_build_setting_impl,
    build_setting = config.string(flag = True),
)

def _should_use_lightningcss(css_processor_type):
    print("css_processor_type: {}".format(css_processor_type))
    return css_processor_type[CssProcessorInfo].processor == "lightningcss"

def _scss_binary_impl(ctx):
    extra_file_name = "lightningcss.out" if _should_use_lightningcss(ctx.attr._css_processor_type) else "postcss.out"
    extra_file_name = "{}_{}".format(ctx.label.name, extra_file_name)
    output_content = "{} using {}. extra: {}".format(ctx.attr.my_data, ctx.attr._css_processor_type[CssProcessorInfo].processor, extra_file_name)
    ctx.actions.write(ctx.outputs.css, output_content)

    extra_file = ctx.actions.declare_file(extra_file_name)
    ctx.actions.write(extra_file, ctx.attr.my_data)

    return [
        DefaultInfo(
            files = depset([
                ctx.outputs.css,
                extra_file
            ]),
        ),
    ]


scss_binary = rule(
    doc = "Test rule",
    implementation = _scss_binary_impl,
    attrs = {
        "my_data": attr.string(),
        "_css_processor_type": attr.label(
            default = Label("@r2//starlark:css_processor_type"),
            doc = "Which css processor to use. See CssProcessorInfo.",
        ),
    },
    outputs = {
        "css": "%{name}.css",
    },
)