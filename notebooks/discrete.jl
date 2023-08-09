### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 5b9b0a7c-368e-11ee-0b27-d58728921899
let
	import Pkg
	Pkg.activate("..")
end

# ╔═╡ b477f5cc-972c-4a82-bbf5-08ca5c038f38
md"# `Morana.Discrete`"

# ╔═╡ 1bde7285-0517-4928-bf9d-9bc4ac975c43
let
	import Morana
	import Morana.Discrete
end

# ╔═╡ f2c684cc-54e7-4a3e-9abf-c972545970e0
journal = Morana.Discrete.Journal{Int, Float64}()

# ╔═╡ Cell order:
# ╟─b477f5cc-972c-4a82-bbf5-08ca5c038f38
# ╠═5b9b0a7c-368e-11ee-0b27-d58728921899
# ╠═1bde7285-0517-4928-bf9d-9bc4ac975c43
# ╠═f2c684cc-54e7-4a3e-9abf-c972545970e0
