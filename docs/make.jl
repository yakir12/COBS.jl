using Documenter, COBS

makedocs(
    modules = [COBS],
    format = Documenter.HTML(),
    checkdocs = :exports,
    sitename = "COBS.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/yakir12/COBS.jl.git",
)
