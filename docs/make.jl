using Documenter, Morana

PAGES = [
    "index.md"
]

makedocs(
    sitename="MORANA.jl",
    authors="Milan R. Rapaić",
    modules=[Morana],
    pages=PAGES)
