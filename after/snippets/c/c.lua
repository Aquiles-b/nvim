return {
    s({
        trig = "pt",
        dscr = "Printf with \\n",
    },
    {
        t({'printf("'}),
        i(1),
        t({'\\n");'})
    }),

    s({
        trig = "ptv",
        dscr = "Printf with \\n and value",
    },
    {
        t({'printf("'}),
        i(1),
        t({'\\n", '}),
        i(2),
        t({');'}),
    }),

}
