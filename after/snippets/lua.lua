return {
    s({
        trig = "mksnip",
        dscr = "Create a snippet!"
    }, 
    {
        t("s({"),
        t({ '', '\ttrig = "' }), i(1, "trigger"), t('",'),
        t({ '', '\tdscr = "' }), i(2, "description"), t('",'),
        t({ '', '},', '{', '\t' }), i(0, "snippet"), t({ '', '}),' }),
    })
}
