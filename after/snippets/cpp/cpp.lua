return {
    s({
        trig = "#bg",
        dscr = "Basic guards",
    },
    {
        t({"#ifndef "}), i(1), 
        t({"", "#define "}), rep(1), 
        i(0),
        t({"", "", "#endif // "}), rep(1)
    }),
}

