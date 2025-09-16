return {
    s({
        trig = "\\mknotes",
        dscr = "Make notes",
    },
    fmt([[
    \documentclass[12pt,a4paper]{{article}}
    \usepackage[top=1cm, bottom=2cm, left=1.5cm, right=1.5cm]{{geometry}}

    \usepackage[utf8]{{inputenc}}
    \usepackage{{enumitem}}

    \usepackage{{makecell}}

    \usepackage{{tgheros}}
    \renewcommand\familydefault{{\sfdefault}}

    \title{{\textbf{{Title}}}}
    \author{{}}
    \date{{}}

    \begin{{document}}
    \maketitle
    \end{{document}}
    ]], {})),
}

