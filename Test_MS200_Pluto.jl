### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 2fb7e5b6-29e1-43ee-9ec0-8ee05daa172d
begin
	using PrettyTables
	using SpecialFunctions
	using Formatting
	using Statistics
	using DataFrames
	using Plots
	using Printf
	using SymPy
	using PyCall
	md"""# MS 120 Test Page"""
end

# ╔═╡ 900cedae-fd4d-4888-80ae-069161471679
html"""
	<style>
		@media screen {
			main {
				margin: 0 auto;
				max-width: 2000px;
	    		padding-left: max(283px, 10%);
	    		padding-right: max(383px, 10%); 
	            # 383px to accomodate TableOfContents(aside=true)
			}
		}
	</style>
	"""

# ╔═╡ 31fdd165-3bb5-48ff-b603-42a9a23d5b7a
begin
	function ingredients(path::String)
		# this is from the Julia source code (evalfile in base/loading.jl)
		# but with the modification that it returns the module instead of the last object
		name = Symbol(basename(path))
		m = Module(name)
		Core.eval(m,
	        Expr(:toplevel,
	             :(eval(x) = $(Expr(:core, :eval))($name, x)),
	             :(include(x) = $(Expr(:top, :include))($name, x)),
	             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
	             :(include($path))))
		m
	end
	N = ingredients("./JSUMS120.jl")
	
	limittable = N.limittable
	lim = N.lim
	criticalpoints = N.criticalpoints
	# getsign = N.getsign #do I need to add this? internal function
	# domain_from_str = N.domain_from_str #do I need to add this? internal function
	# getsigns_aux = N.getsigns_aux #do I need to add this? internal function
	# getsigns = N.getsigns #do I need to add this? internal function
	signchart = N.signchart
	signcharts = N.signcharts
	functionplot = N.functionplot
	plot_function_sign_chart = N.plot_function_sign_chart
	#Do I need to do the intervals, line 625
	# convert_to_interval = N.convert_to_interval #do I need to add this? internal function
	# end_behavior_aux = N.end_behavior_aux #do I need to add this? internal function
	extrema = N.extrema
	inflection_points = N.inflection_points
	# extrema_approx = N.extrema_approx #do I need to add this? internal function
	end_behavior = N.end_behavior
	function_summary = N.function_summary
	int = N.int

	x = Sym("x")
	h = Sym("h")
	C = Sym("C")
	∞ = oo

	md"""Code to load JSUMS120 code and do some setup are hidden in this cell."""
end

# ╔═╡ 6efad1e7-20da-4d7e-8cd7-a76f4266cbc8
md"""Let's define a few of functions:"""

# ╔═╡ 2433e694-ac58-4a25-9dca-14e1f843deff
begin
	fcn_def = md"""
	The functions used in these notes:
	
	``f(x) = (x+2)(x+1)(x-2)``
	
	``g(x) = 2x``
	
	``r(x) = \dfrac{x}{x-1}``
	
	``s(x) = \sqrt{x}``
	
	``l(x) = \log(x)``
	
	``t(x) = \sin(x)``
	"""
	fcn_def
end

# ╔═╡ 93c7ab61-ea82-4b47-b8bd-9b0eafa53447
f(x) = (x+2)*(x+1)*(x-2)

# ╔═╡ 05361557-926d-4335-96af-4b4f10a38ec3
f(x)

# ╔═╡ 4bdc6c67-9d8a-413b-a965-f89b2db4d82f
g(x) = 2x

# ╔═╡ b1e4b373-cde5-476b-9694-e1497985ce07
g(x)

# ╔═╡ 2efa1f12-83a9-4256-b4a7-80700847b4c6
r(x) = x/(x-1)

# ╔═╡ 261d9b3b-eef9-4c5b-a539-adf474c3068e
r(x)

# ╔═╡ 97de6cd5-4121-4aab-a13e-1086b6c82103
s(x) = √x

# ╔═╡ 415911be-1f36-4d92-902c-8ff00e4601a5
s(x)

# ╔═╡ 1603a95d-56ef-462c-a795-5ec50b561875
l(x) = log(x)

# ╔═╡ 0ab63cec-29e8-4964-811d-d9b66d45a623
l(x)

# ╔═╡ fb6a457e-58d6-4c95-96a0-8b5bebe83c5e
t(x) = sin(x)

# ╔═╡ 80984fb8-bf4e-4601-80d3-bf71a6361860
t(x)

# ╔═╡ ea32246f-f92f-48a3-b9cd-0965aeeea62c
md"""
    limittable(f, a; rows::Int=5, dir::String="", format="%10.8f")

`a`: a finite number\
`rows`: number of rows to compute (default is 5 rows)\
`dir`: a string indicating which side to take the limit from\
`format`: a string that specifies c-style printf format for numbers (default is %10.8f)

|dir|meaning|
|---|-------|
|""|approach from both sides (default)|
|"-"|approach from the left|
|"+"|approach from the right|

    limittable(f, a::Sym; rows::Int=5, format="%10.2f")

`a`: is either oo (meaning ∞) or -oo (meaning -∞)\
`rows`: number of rows to compute (default is 5 rows)\
format: a string that specifies c-style printf format for numbers (default is %10.2f)
"""

# ╔═╡ a1ef883a-c976-453a-9f1d-25899767bbc9
limittable(f, 3)

# ╔═╡ 02679fca-fa59-4388-aac3-7326e33d0e0c
limittable(f, ∞)

# ╔═╡ bdb45336-763e-49f5-92f8-03e4624ba534
limittable(f, -∞)

# ╔═╡ 6723b4e3-6346-4fbf-8976-10c20e802b4f
limittable(s, 2, rows=10, dir = "+")

# ╔═╡ 25dbf22a-3fc3-4a5c-9e08-d486e7c7cc20
limittable(s, 2, rows=10, dir = "-")

# ╔═╡ 39039270-e9d2-4c8a-8aa3-07c018982968
md"""
    lim(f, var, c; dir = "")

``\lim_{x \to c} f(x) = L``\
`var`: the variable\
`c`: the value to approach includeing -∞ (-oo) and ∞ (oo)\
`dir`: a string indicating which side to take the limit from. Default is "" which takes the two sided limit, "+" takes the limit from the right, "-" takes the limit from the left
"""

# ╔═╡ 9e554a6d-cad1-42a1-8640-8337a42e4c6b
lim(f, x, 3)

# ╔═╡ 78a10123-7b24-4aad-99a6-fbe872adba62
md"""
    criticalpoints(f(x))

Find the critical points of the function f(x).

Returns a pair of vectors with the first vector the values that make ``f(x) = 0`` and the second vector the values that make ``f(x)`` undefined.
"""

# ╔═╡ 49ff8f16-9074-460d-a029-56176e6da860
criticalpoints(f(x))

# ╔═╡ a59fff27-4a84-430a-b03d-be7ca27e601d
criticalpoints(r(x))

# ╔═╡ 785bc17e-6696-4fed-bcb9-d390ffa41a24
criticalpoints(s(x))

# ╔═╡ 703bffc4-3c97-4474-aed4-f4def600c5be
criticalpoints(l(x))

# ╔═╡ 65019cd7-5958-4f09-93ae-1b7b51df2ab7
fcn_def

# ╔═╡ 53aec3b2-9e3f-4752-b0ca-dafb6a52119a
md"""
    signchart(f(x); label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

`label`: makes label for sign chart along left side\
`domain`: of the funtion the sign chart is being made for\
`horiz_jog`: moves the signchart horizontally\
`size`: of the sign chart\
`dotverticaljog`: moves the dot on the axis vertically\
`marksize`: changes the size of the dot\
`tickfontsize`: changes the font size of the tick labels\
`imageFormat`: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\
`xrange`: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
"""

# ╔═╡ 33d72736-426d-495b-bccb-90339d5f7677
signchart(f(x))

# ╔═╡ 1a944c5a-3b86-4ddf-abcd-47807c990032
signchart(r(x), label = "r") 

# ╔═╡ 12686233-cf1a-40b3-b2b7-83425d89134a
signchart(s(x), domain = "[0, ∞)") #domain is necessary else get an error

# ╔═╡ fd533f57-0c74-4342-9555-36a832d9cfd9
signchart(l(x), domain = "(0, ∞)")

# ╔═╡ 80be57be-ef47-443f-904f-377269344c0c
signchart(t(x))

# ╔═╡ 43d83a11-b91f-4e0f-8eac-f96453e2c007
md"""
	signcharts(f(x); labels=["f", "f′", "f′′"], domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

`xrange`: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits

Generate stacked sign charts for the given function and its first and second derivative. 
"""

# ╔═╡ 1ed5a63f-d33b-49bd-895e-3dcd481023c6
signcharts(f(x))

# ╔═╡ a18306e4-adc4-46be-8f02-e06cb1416e38
signcharts(r(x), labels = "r")

# ╔═╡ 6bf65277-a48a-4389-9488-0dc2df2797ff
signcharts(s(x), domain = "[0, ∞)")

# ╔═╡ 6462db79-e5ae-4ae8-8a9b-da0dddf18d0a
signcharts(l(x), domain = "(0, ∞)")

# ╔═╡ 8702008e-6784-4d98-ab76-ce72d9d743b7
signcharts(t(x)) # now it's not stacking coreectly!

# ╔═╡ 7c516a72-94d1-4a0b-8ad7-850efa8b8282
signcharts(g(x))

# ╔═╡ eded9a11-2271-49fa-ba93-b4908ac45ed9
f2(x) = x^2

# ╔═╡ 89dd9b84-680d-4206-9f40-c8e1e1822504
signcharts(f2(x))

# ╔═╡ 3ddd4753-0d01-4d74-99d4-7338658de752
fcn_def

# ╔═╡ cc2107ba-cfa1-4d90-b7e6-65ec3cc6d902
md"""
    functionplot(f(x), xrange; label = "", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg)

`xrange`: a pair giving the ``x`` limits of the plot\
`horiz_ticks`: a range giving the horizontal ticks to be displayed\
`vert_ticks`: a range giving the horizontal ticks to be displayed\
`yrange`: a pair giving the ``y`` limits of the plot\
`xsteps`: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`)
"""

# ╔═╡ 76aaadf1-6fe1-434c-b71d-ea1fec20560e
functionplot(f(x), (-3, 3))

# ╔═╡ d5f6fded-ff8d-4ed1-bce2-11d9b5932e31
functionplot(r(x), (-1, 3), yrange=(-10, 10))

# ╔═╡ 0422c4a3-01d1-402c-8ed0-10fa8f926232
functionplot(s(x), (0, 9)) # need to add endpoint dot

# ╔═╡ 7c6d69ea-9b10-4bfa-a44d-5b4ecf55d77e
functionplot(g(x), (-5, 5))

# ╔═╡ 29a75e73-77ca-4a86-ab33-71a467d0f8b9
functionplot(t(x), (0, 2π))

# ╔═╡ 3258674a-4429-4086-ba63-e8ebe089e899
md"""
		plot_function_sign_chart(f, xrange; labels=["f", "f′", "f′′"], domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01)

`xrange`: a pair giving the ``x`` limits of the plot\
`horiz_ticks`: a range giving the horizontal ticks to be displayed\
`vert_ticks`: a range giving the horizontal ticks to be displayed\
`yrange`: a pair giving the ``y`` limits of the plot\
`xsteps`: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`) (default .01)

Plots the function over the sign charts for the function, then its first derivative, and finally its second derivative.
"""

# ╔═╡ 023e20f1-d370-433d-8201-a491f1aebbe4
plot_function_sign_chart(f(x), (-3, 4), yrange = (-10, 20)) #need to get rid of the overlapes of the tick labels and dots

# ╔═╡ 964ccba8-4d30-46d7-85c9-294b1d9169ca
plot_function_sign_chart(r(x), (-1, 3), yrange=(-10, 10))

# ╔═╡ 33220e18-eb45-41a3-af12-f1e9210deb47
plot_function_sign_chart(s(x), (0, 9), domain = "[0, ∞)") # and add some space to the left to get the full dots on the figure

# ╔═╡ 410b73a4-05eb-4797-88ac-2c3ec220a984
plot_function_sign_chart(g(x), (-5, 5), domain = "(0, ∞)") 

# ╔═╡ c3b3223b-8302-4fab-90b7-b3fbfa32de24
plot_function_sign_chart(t(x), (0, 2π)) # Need to use xrange/left_value/right_value? to place signs

# ╔═╡ 261af334-e577-4d8d-99f3-91303ecd19fb
plot_function_sign_chart(t(x), (0, 2π), xrange = (-π, 3π))

# ╔═╡ a9445aa3-1d12-4d3b-8330-66f70310a78c
fcn_def

# ╔═╡ d9ed3436-0ca3-4f1f-8080-5ba7a93044be
md"""
	extrema(f; domain::String = "(-∞, ∞)")

Returns a named tuple where the first element is the the local minima (named minima) and the second element is the local maxima (named maxima).
"""

# ╔═╡ 00c188fd-dc29-4e05-a564-eae4305e5420
extrema(f(x)) # need to add the number of digits to round to (and get it to round).

# ╔═╡ a7399b8c-487c-4144-8853-7bd226b14554
extrema(r(x))

# ╔═╡ f1f0b1e7-2ea6-4f36-819e-48a49913d3a7
extrema(s(x), domain = "[0, ∞)")

# ╔═╡ 096ea819-4ca5-4623-9585-4c93a839c653
extrema(g(x), domain = "(0, ∞)")

# ╔═╡ 714b3ed7-22ef-4ff5-acc1-4e8ce892aa90
md"""
	function_summary(f; domain::String = "(-∞, ∞)", labels = ["y", "y′", "y′′"], fig_width = 200, dotverticaljog=0, marksize=8, tickfontsize = 20, format = :side, format_num="%3.2f", horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing)

Takes a function f and outputs the:\
y-intercept,\
local max,\
local min,\
inflection points,\
behaviour at infinites/endpoints\
function sign chart, derivative sign chart, second derivative sign charts
as a named tuple with names (:y_intercept, :max, :min, :inflection, :left_behavior, :right_behavior, :signcharts).


The inputs are:\
f: is the function to summarize,\
domain: the domain of the function entered as a string (default "(-∞, ∞)"),\
labels: is applied to the sign charts (default ["y", "y′", "y′′"]),\
dotverticaljog: changes the height of the points on the sign chart (default 0),\
marksize: changes the diamater of the points on the sign chart (default 8),\
tickfontsize: changes the font size of the tick marks (default 20),\
digits: number of digits to round values to,\
horiz_jog: ?\
size: size of the signchart (default (1000, 400)),\
imageFormat: image format for the sign charts (default :svg),\
xrange: ?
"""

# ╔═╡ 901f9d10-83e6-463c-ac3c-5378084e78ce
f_summary = function_summary(f(x))

# ╔═╡ dcd9944a-1bb3-44af-9c56-eb8767e4a21a
f_summary[:signcharts]

# ╔═╡ a6a91f19-10ec-4014-a5ef-8509034bd218
r_summary = function_summary(r(x))

# ╔═╡ fd9b7e58-c035-421d-9aa9-495ce988b39c
r_summary[:signcharts]

# ╔═╡ 8edabb2a-02f3-4ba8-9d45-5c68c998ef17
s_summary = function_summary(s(x), domain = "[0, ∞)")

# ╔═╡ edb3d320-5546-4c5d-8be1-4b27fe74abfd
s_summary[:signcharts]

# ╔═╡ 9f87a416-7b99-412a-95d2-0b151c00ff81
g_summary = function_summary(g(x), domain = "(0, ∞)")

# ╔═╡ 2e99f3ed-831f-4e98-9a03-0e00fe83f57f
g_summary[:signcharts]

# ╔═╡ e470ef9e-b136-48be-a7b7-826613aa045c
t_summary = function_summary(t(x), domain = "(0, $(2π))") #need to make it process the 2π without having to use interpolation  (the $).

# ╔═╡ c3c0dccb-e02f-4015-809b-edc53427df7b
t_summary[:signcharts]

# ╔═╡ 7d217ba6-272b-422a-a446-ec6dfdc8daf6
fcn_def

# ╔═╡ 265298de-79b2-4af6-98eb-108178928931
md"""
    int(f, var)

Find the indefinite integral of function f wrt to the variable var.
"""

# ╔═╡ ee4a7fc0-7a80-45e7-99ba-d7e0745a3a02
int(f, x)

# ╔═╡ 294f3fa8-bcea-428f-ad96-6f40a088ac2f
int(r, x)

# ╔═╡ 38deaf05-8ec1-4ec1-ba45-783f5bd45666
int(s, x)

# ╔═╡ 9eba9071-9360-4898-8c81-5a6a14c624cc
int(l, x)

# ╔═╡ 5b33bc2d-e967-4e3b-8040-1960c0f6eaf7
int(t, x)

# ╔═╡ aa6d90bc-27d0-45b9-9b69-5a4eae96e0f1
md"""
    int(f, var, a, b)

Find the definite integral of function f from ``a`` to ``b`` wrt to the variable var. 
"""

# ╔═╡ 8e67590f-81da-4b13-aa8b-ecabeebfa3a9
int(f, x, 0 , 1)

# ╔═╡ 6e54e5ab-33a0-4a23-a39f-d93e930a8356
int(r, x, 2, 3)

# ╔═╡ 28391375-3498-43b1-b9f3-c846a7d1fb3b
int(s, x, 0, 1)

# ╔═╡ 296672d1-d979-4642-8da7-3653091309a3
int(l, x, 1, 2)

# ╔═╡ b06a76e3-47e1-4f27-a6a7-19270b4a3701
int(t, x, 0, π)

# ╔═╡ 9b69c361-496a-4e23-b18c-9c80d7a2969a
ft(x) = x/(x+1)

# ╔═╡ 4f4cd176-848c-407b-aa48-55e02698e654
ft_sum = function_summary(ft(x))

# ╔═╡ 75be8067-f565-4957-b229-9516de03ec13
ft_sum[:signcharts] # find all test points first, use to set width of charts, then make it.

# ╔═╡ 485f4811-b74a-47f7-a87e-715445b10526
functionplot(ft(x), (-3, 2), yrange = (-10, 10))

# ╔═╡ 56e68162-edb3-4f9a-a8b8-ee4976aa7cf1
ft2(x) = x^3 - 9x

# ╔═╡ 8db86315-b77c-42ab-8224-fb8ebd8a0f19
ft2_sum = function_summary(ft2(x))

# ╔═╡ a26cb57d-ace4-40ee-a69c-57d3517ddb09
ft2_sum[:signcharts]

# ╔═╡ cb9401e2-1568-471c-b440-97f987981ca7
functionplot(ft2(x), (-4, 4))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Formatting = "59287772-0a20-5a39-b81b-1366585eb4c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
DataFrames = "~1.5.0"
Formatting = "~0.4.2"
Plots = "~1.38.9"
PrettyTables = "~2.2.3"
PyCall = "~1.95.1"
SpecialFunctions = "~2.2.0"
SymPy = "~1.1.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "01f086cb4ee61e299435e073c6b1ced5976bb084"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[deps.CommonSolve]]
git-tree-sha1 = "9441451ee712d1aec22edad62db1a9af3dc8d852"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.3"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "e32a90da027ca45d84678b826fffd3110bb3fc90"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.8.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "0635807d28a496bb60bc15f465da0107fb29649c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "99e248f643b052a77d2766fe1a16fb32b661afd4"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.0+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "186d38ea29d5c4f238b2d9fe6e1653264101944b"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.9"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "548793c7859e28ef026dba514752275ee871169f"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "62f417f6ad727987c755549e9cd88c46578da562"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.95.1"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "77d3c4726515dca71f6d80fbb5e251088defe305"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.18"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "fcb24df16e451cfa8e1e1217edfd92054f75d49d"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.8"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─900cedae-fd4d-4888-80ae-069161471679
# ╟─2fb7e5b6-29e1-43ee-9ec0-8ee05daa172d
# ╟─31fdd165-3bb5-48ff-b603-42a9a23d5b7a
# ╟─6efad1e7-20da-4d7e-8cd7-a76f4266cbc8
# ╟─2433e694-ac58-4a25-9dca-14e1f843deff
# ╠═93c7ab61-ea82-4b47-b8bd-9b0eafa53447
# ╠═05361557-926d-4335-96af-4b4f10a38ec3
# ╠═4bdc6c67-9d8a-413b-a965-f89b2db4d82f
# ╠═b1e4b373-cde5-476b-9694-e1497985ce07
# ╠═2efa1f12-83a9-4256-b4a7-80700847b4c6
# ╠═261d9b3b-eef9-4c5b-a539-adf474c3068e
# ╠═97de6cd5-4121-4aab-a13e-1086b6c82103
# ╠═415911be-1f36-4d92-902c-8ff00e4601a5
# ╠═1603a95d-56ef-462c-a795-5ec50b561875
# ╠═0ab63cec-29e8-4964-811d-d9b66d45a623
# ╠═fb6a457e-58d6-4c95-96a0-8b5bebe83c5e
# ╠═80984fb8-bf4e-4601-80d3-bf71a6361860
# ╟─ea32246f-f92f-48a3-b9cd-0965aeeea62c
# ╠═a1ef883a-c976-453a-9f1d-25899767bbc9
# ╠═02679fca-fa59-4388-aac3-7326e33d0e0c
# ╠═bdb45336-763e-49f5-92f8-03e4624ba534
# ╠═6723b4e3-6346-4fbf-8976-10c20e802b4f
# ╠═25dbf22a-3fc3-4a5c-9e08-d486e7c7cc20
# ╟─39039270-e9d2-4c8a-8aa3-07c018982968
# ╠═9e554a6d-cad1-42a1-8640-8337a42e4c6b
# ╟─78a10123-7b24-4aad-99a6-fbe872adba62
# ╠═49ff8f16-9074-460d-a029-56176e6da860
# ╠═a59fff27-4a84-430a-b03d-be7ca27e601d
# ╠═785bc17e-6696-4fed-bcb9-d390ffa41a24
# ╠═703bffc4-3c97-4474-aed4-f4def600c5be
# ╟─65019cd7-5958-4f09-93ae-1b7b51df2ab7
# ╟─53aec3b2-9e3f-4752-b0ca-dafb6a52119a
# ╠═33d72736-426d-495b-bccb-90339d5f7677
# ╠═1a944c5a-3b86-4ddf-abcd-47807c990032
# ╠═12686233-cf1a-40b3-b2b7-83425d89134a
# ╠═fd533f57-0c74-4342-9555-36a832d9cfd9
# ╠═80be57be-ef47-443f-904f-377269344c0c
# ╟─43d83a11-b91f-4e0f-8eac-f96453e2c007
# ╠═1ed5a63f-d33b-49bd-895e-3dcd481023c6
# ╠═a18306e4-adc4-46be-8f02-e06cb1416e38
# ╠═6bf65277-a48a-4389-9488-0dc2df2797ff
# ╠═6462db79-e5ae-4ae8-8a9b-da0dddf18d0a
# ╠═8702008e-6784-4d98-ab76-ce72d9d743b7
# ╠═7c516a72-94d1-4a0b-8ad7-850efa8b8282
# ╠═eded9a11-2271-49fa-ba93-b4908ac45ed9
# ╠═89dd9b84-680d-4206-9f40-c8e1e1822504
# ╟─3ddd4753-0d01-4d74-99d4-7338658de752
# ╟─cc2107ba-cfa1-4d90-b7e6-65ec3cc6d902
# ╠═76aaadf1-6fe1-434c-b71d-ea1fec20560e
# ╠═d5f6fded-ff8d-4ed1-bce2-11d9b5932e31
# ╠═0422c4a3-01d1-402c-8ed0-10fa8f926232
# ╠═7c6d69ea-9b10-4bfa-a44d-5b4ecf55d77e
# ╠═29a75e73-77ca-4a86-ab33-71a467d0f8b9
# ╟─3258674a-4429-4086-ba63-e8ebe089e899
# ╠═023e20f1-d370-433d-8201-a491f1aebbe4
# ╠═964ccba8-4d30-46d7-85c9-294b1d9169ca
# ╠═33220e18-eb45-41a3-af12-f1e9210deb47
# ╠═410b73a4-05eb-4797-88ac-2c3ec220a984
# ╠═c3b3223b-8302-4fab-90b7-b3fbfa32de24
# ╠═261af334-e577-4d8d-99f3-91303ecd19fb
# ╟─a9445aa3-1d12-4d3b-8330-66f70310a78c
# ╟─d9ed3436-0ca3-4f1f-8080-5ba7a93044be
# ╠═00c188fd-dc29-4e05-a564-eae4305e5420
# ╠═a7399b8c-487c-4144-8853-7bd226b14554
# ╠═f1f0b1e7-2ea6-4f36-819e-48a49913d3a7
# ╠═096ea819-4ca5-4623-9585-4c93a839c653
# ╟─714b3ed7-22ef-4ff5-acc1-4e8ce892aa90
# ╠═901f9d10-83e6-463c-ac3c-5378084e78ce
# ╠═dcd9944a-1bb3-44af-9c56-eb8767e4a21a
# ╠═a6a91f19-10ec-4014-a5ef-8509034bd218
# ╠═fd9b7e58-c035-421d-9aa9-495ce988b39c
# ╠═8edabb2a-02f3-4ba8-9d45-5c68c998ef17
# ╠═edb3d320-5546-4c5d-8be1-4b27fe74abfd
# ╠═9f87a416-7b99-412a-95d2-0b151c00ff81
# ╠═2e99f3ed-831f-4e98-9a03-0e00fe83f57f
# ╠═e470ef9e-b136-48be-a7b7-826613aa045c
# ╠═c3c0dccb-e02f-4015-809b-edc53427df7b
# ╟─7d217ba6-272b-422a-a446-ec6dfdc8daf6
# ╟─265298de-79b2-4af6-98eb-108178928931
# ╠═ee4a7fc0-7a80-45e7-99ba-d7e0745a3a02
# ╠═294f3fa8-bcea-428f-ad96-6f40a088ac2f
# ╠═38deaf05-8ec1-4ec1-ba45-783f5bd45666
# ╠═9eba9071-9360-4898-8c81-5a6a14c624cc
# ╠═5b33bc2d-e967-4e3b-8040-1960c0f6eaf7
# ╠═aa6d90bc-27d0-45b9-9b69-5a4eae96e0f1
# ╠═8e67590f-81da-4b13-aa8b-ecabeebfa3a9
# ╠═6e54e5ab-33a0-4a23-a39f-d93e930a8356
# ╠═28391375-3498-43b1-b9f3-c846a7d1fb3b
# ╠═296672d1-d979-4642-8da7-3653091309a3
# ╠═b06a76e3-47e1-4f27-a6a7-19270b4a3701
# ╠═9b69c361-496a-4e23-b18c-9c80d7a2969a
# ╠═4f4cd176-848c-407b-aa48-55e02698e654
# ╠═75be8067-f565-4957-b229-9516de03ec13
# ╠═485f4811-b74a-47f7-a87e-715445b10526
# ╠═56e68162-edb3-4f9a-a8b8-ee4976aa7cf1
# ╠═8db86315-b77c-42ab-8224-fb8ebd8a0f19
# ╠═a26cb57d-ace4-40ee-a69c-57d3517ddb09
# ╠═cb9401e2-1568-471c-b440-97f987981ca7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
