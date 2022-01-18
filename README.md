# StructuredLaTeXTables.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/alanderos91/StructuredLaTeXTables.jl.svg?branch=master)](https://travis-ci.com/alanderos91/StructuredLaTeXTables.jl)
[![codecov.io](http://codecov.io/github/alanderos91/StructuredLaTeXTables.jl/coverage.svg?branch=master)](http://codecov.io/github/alanderos91/StructuredLaTeXTables.jl?branch=master)
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://alanderos91.github.io/StructuredLaTeXTables.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://alanderos91.github.io/StructuredLaTeXTables.jl/dev)
-->

This package generates (mostly) publication-ready tables from a structured `DataFrame`.
Specifically, the contents of the table are assumed to have some associated metadata that should also be displayed.

This package has come about as a result of various scripts I wrote at some point for my own work.
[This blog post](https://nhigham.com/2019/11/19/better-latex-tables-with-booktabs/) and this [neat Julia package](https://github.com/korsbo/Latexify.jl) were sources of inspiration.
Hopefully the ideas here will eventually propagate to [Latexify.jl](https://github.com/korsbo/Latexify.jl) or Julia ecosystem in some form.

## Philosophy

1. Leave data transformations to external tools; e.g. from DataFrames.jl.
2. Focus on specifying structure; let the computer do "most" of the formatting.
3. Avoid using lines, cluttered text, and other excessive details to tell a story.
