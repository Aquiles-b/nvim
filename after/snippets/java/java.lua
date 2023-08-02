return {
    s({
        trig = "sop",
        dscr = "System.out.print()",
    },
    {
        t("System.out.print("), i(0), t(");")
    }),

    s({
        trig = "sopln",
        dscr = "System.out.println()",
    },
    {
        t("System.out.println("), i(0), t(");")
    }),

    s({
        trig = "sopf",
        dscr = "Formatado",
    },
    {
        t('System.out.printf("'), i(1), t('", '), i(2), t(');')
    }),
}
