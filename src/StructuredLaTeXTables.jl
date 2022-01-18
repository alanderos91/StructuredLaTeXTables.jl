module StructuredLaTeXTables
using DataFrames

function tabular_header(data_labels, meta_labels, levels, swap_headers)
    number_meta_cols = length(meta_labels)
    number_data_cols = length(data_labels)
    number_levels = length(levels)

    if swap_headers
        # Use levels as the main headers.
        main_labels = levels
        sub_labels = data_labels
        number_main_cols = number_levels
        number_sub_cols = number_data_cols
    else
        # Use levels as the subheaders.
        main_labels = data_labels
        sub_labels = levels
        number_main_cols = number_data_cols
        number_sub_cols = number_levels
    end

    # Begin a new tabular environment with the given column specification.
    spec1 = repeat("l", number_meta_cols)
    spec2 = repeat(repeat("c", number_sub_cols), number_main_cols)
    column_specification = string("{", spec1, spec2, "}")
    output_string = "\\begin{tabular}$(column_specification)"

    # Build the table header with the given nested structure.
    meta_header = repeat("& ", number_meta_cols-1)
    data_header = ""
    horizontal_rules = repeat("& ", number_meta_cols-1)
    start_idx = 1 + number_meta_cols
    stop_idx = start_idx + number_sub_cols - 1
    for label in main_labels
        data_header *= "& \\multicolumn{$(number_sub_cols)}{c}{$(label)} "
        horizontal_rules *= "\\cmidrule(lr){$(start_idx)-$(stop_idx)}"
        start_idx += number_sub_cols
        stop_idx += number_sub_cols
    end
    header = strip(string(meta_header, " ", data_header))    
    horizontal_rules = strip(horizontal_rules)

    # Build the table subheader.
    meta_subheader = join(meta_labels, " & ")
    data_subheader = repeat(string(" & ", join(sub_labels, " & ")), number_main_cols)
    subheader = strip(string(meta_subheader, " ", data_subheader))

    # Put everything together and add a horizontal line to mark the end of the header.
    output_string *= "\n\\toprule"
    output_string *= "\n$(header) \\\\"
    output_string *= "\n$(horizontal_rules)"
    output_string *= "\n$(subheader) \\\\"
    output_string *= "\n\\midrule"

    return output_string
end

function tabular_body(df, data_cols, meta_cols, swap_headers)
    output_string = ""

    # Group DataFrame by the selected metadata and iterate over its SubDataFrames.
    for sub in groupby(df, meta_cols)
        # Extract metadata for a particular record.
        row1_meta, row1_data = join(sub[1, meta_cols], " & "), ""

        if swap_headers
            # Build the record by the *rows* of the SubDataFrame.
            for row in eachrow(sub)
                data1_formatted = map(col -> string(row[col]), data_cols)
                row1_data = string(row1_data, " & ", join(data1_formatted, " & "))
            end
        else
            # Build the record by the *columns* of the SubDataFrame.
            for col in data_cols
                data_raw = sub[!, col]
                data1_formatted = map(x -> string(x), data_raw)
                row1_data = string(row1_data, " & ", join(data1_formatted, " & "))
            end
        end
        row1_meta = strip(row1_meta)
        row1_data = strip(row1_data)
        output_string *= "\n$(row1_meta) $(row1_data) \\\\"
    end

    return output_string
end

tabular_footer() = string("\n", raw"\bottomrule", "\n", raw"\end{tabular}")

"""
`make_latex_tabular(df::DataFrame; [data], [metadata], [emphasis], [swap_headers=false])`

Represent structured data from a `DataFrame` as a string containing a `tabular` LaTeX environment with nested columns.

This assumes `data` columns have associated `metadata` columns.

# Options

- `data`: Column-label pairs indicating what data goes in the main body of the table. The labels are used to construct nested columns in the main body.
- `metadata`: Column-label pairs indicating what metadata goes on the left of the table.
- `emphasis`: A column, which should appear in the `metadata`, to emphasize in the main body. The levels for `df[!,emphasis]` are used to construct nested columns in the main body.
- `swap_headers`: Indicate whether to nest `emphasis` levels under `data` columns (`false`) or to nest `data` columns under `emphasis` levels (`true`).
"""
function make_latex_tabular(df::DataFrame;
    data::Vector{Pair{Symbol,String}}=Pair{Symbol,String}[],
    metadata::Vector{Pair{Symbol,String}}=Pair{Symbol,String}[],
    emphasis::Symbol=:none,
    swap_headers::Bool=false,
    )
    data_cols, data_labels = map(first, data), map(last, data)
    meta_cols, meta_labels = map(first, metadata), map(last, metadata)
    levels = unique(df[!, emphasis])

    idx = findfirst(isequal(emphasis), meta_cols)
    deleteat!(meta_cols, idx)
    deleteat!(meta_labels, idx)

    number_meta_cols = length(meta_labels)
    number_levels = length(levels)
    blanks = ["" for _ in 1:number_levels]

    output_string = tabular_header(data_labels, meta_labels, levels, swap_headers)
    output_string *= tabular_body(df, data_cols, meta_cols, swap_headers)
    output_string *= tabular_footer()

    return output_string
end

export make_latex_tabular

end # module
