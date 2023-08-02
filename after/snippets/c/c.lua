return {
    s('#ip', fmt([[
    #include <stdio.h>
    #include <stdlib.h>
    #include "{}"

    ]], {i(1, "Header")})),

    s('#ib', fmt([[
    #include <stdio.h>

    int main()
    {{
        {}

        return 0;
    }}
    ]],{i(1)})
    ),

    s('func', fmt([[
    {} {}({})
    {{
        {}
        return {};
    }}
    ]], {i(1, "tipo"),
            i(2, "nome"),
            i(3, "args"),
            i(4),
            i(5)
        })),

    s('voi', fmt([[
    void {}({}) 
    {{
        {}
    }}
    ]], {
            i(1, "nome"),
            i(2, "args"),
            i(3)
        })),

    s('pv', fmt([[
    printf("%d{}", {});
    ]], { 
            i(1), 
            i(2, "var")
        })),
    s('fpt', fmt([[
    fprintf(stderr, "{}\n");
    ]], { 
            i(1, "Aquiii"), 
        })),

    s('fpv', fmt([[
    fprintf(stderr, "%d{}", {});
    ]], { 
            i(1), 
            i(2, "var")
        })),

    s('masi', fmt([[
    malloc(sizeof({}));
    ]], { 
            i(1), 
        })),

    s('pt', fmt([[
    printf("{}\n");
    ]], {i(1)})),

    s('fo', fmt([[
    for({}; {}; {}) {{
            {}
    }}
    ]], {
            i(1, "init"),
            i(2, "cond"),
            i(3, "incr"),
            i(4)
        }))

}
