using DataFrames: DataFrame
using StructuredLaTeXTables
using Test

# Example 1: Handbook of Writing for the Mathematical Sciences
# source: https://nhigham.com/2019/11/19/better-latex-tables-with-booktabs/

trigmv = "\\trigmv"
trig_expmv = "\\trigexpmv"
trig_block = "\\trigblock"
expleja = "\\expleja"
tols = "\$\\tol=\\tols\$"
told = "\$\\tol=\\told\$"

df1 = DataFrame(
    method=repeat([trigmv, trig_expmv, trig_block, expleja], 2),
    mv=[11034, 21952, 15883, 11180, 15846, 31516, 32023, 17348],
    error=[1.3e-7, 1.3e-7, 5.2e-8, 8.0e-9, 2.7e-11, 2.7e-11, 1.1e-11, 1.5e-11],
    time=[3.9, 6.2, 7.1, 4.3, 5.6, 8.8, 1.4e1, 6.6],
    tol=repeat([tols, told], inner=4),
)

observed1 = make_latex_tabular(df1,
    data=[:mv => raw"$mv$", :error => raw"Rel.~err", :time => raw"Time"],
    metadata=[:method => "", :tol => "not used here"],
    emphasis=:tol, # need emphasis in metadata
    swap_headers=true,
)

# NOTE: entry '14.0' should be '1.4e1' to match original.
# NOTE: Add trailing '\n'?
expected1 = replace(
raw"\begin{tabular}{lcccccc}
\toprule
& \multicolumn{3}{c}{$\tol=\tols$} & \multicolumn{3}{c}{$\tol=\told$} \\
\cmidrule(lr){2-4}\cmidrule(lr){5-7}
& $mv$ & Rel.~err & Time & $mv$ & Rel.~err & Time \\
\midrule
\trigmv & 11034 & 1.3e-7 & 3.9 & 15846 & 2.7e-11 & 5.6 \\
\trigexpmv & 21952 & 1.3e-7 & 6.2 & 31516 & 2.7e-11 & 8.8 \\
\trigblock & 15883 & 5.2e-8 & 7.1 & 32023 & 1.1e-11 & 14.0 \\
\expleja & 11180 & 8.0e-9 & 4.3 & 17348 & 1.5e-11 & 6.6 \\
\bottomrule
\end{tabular}",
"\r\n" => "\n")

@test observed1 == expected1
