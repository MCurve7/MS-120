using PrettyTables
using SpecialFunctions
using Formatting
using Statistics
using DataFrames
using Plots
using Printf
using SymPy
using PyCall
# using PlotlyJS


begin
	x = Sym("x")
	h = Sym("h")
	C = Sym("C")
	∞ = oo
end

# Test functions #####################################
# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end

"""
    limittable(f, a; rows::Int=5, dir::String="", format="%10.8f")

a: a finite number\n
rows: number of rows to compute (default is 5 rows)\n
dir: a string indicating which side to take the limit from\n
format: a string that specifies c-style printf format for numbers (default is %10.8f)

|dir|meaning|
|---|-------|
|""|approach from both sides (default)|
|"-"|approach from the left|
|"+"|approach from the right|
"""
function limittable(f, a; rows::Int=5, dir::String="", format="%10.8f") # for finite x->a

	# hl_head = HtmlHighlighter((data, i, j) -> (i == 1) , HtmlDecoration(font_weight = "bold"))
    if dir == "+"
        X = a .+ [10.0^(-i) for i in 1:rows-2] # broadcast: a + each elt in array
        X = vcat([a + 1, a + 0.5], X) # add rows at the top of X
        Y = [N(f(z)) for z in X] # make array of outputs f(X)
		hl_right = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "red"))
		# pretty_table(HTML, hcat(X, Y); header = ["x → $(a)⁺", "y"], formatters = ft_printf(format), highlighters = (hl_head, hl_right))	
		pretty_table(HTML, hcat(X, Y); header = ["x → $(a)⁺", "y"], formatters = ft_printf(format), highlighters = (hl_right))	
    elseif dir == "-"
        X = a .- [10.0^(-i) for i in 1:rows-2]
        X = vcat([a - 1, a - 0.5], X)
        Y = [N(f(z)) for z in X]
		hl_left = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "#0041C2"))
    	# pretty_table(HTML, hcat(X, Y); header = ["x → $(a)⁻", "y"], formatters = ft_printf(format), highlighters = (hl_head, hl_left))
		pretty_table(HTML, hcat(X, Y); header = ["x → $(a)⁻", "y"], formatters = ft_printf(format), highlighters = (hl_left))
    else # ?Make seperate functions for left/right limit and hcat them for 2-sided limit below?
        Xr = a .+ [10.0^(-i) for i in 1:rows-2]
        Xr = vcat([a + 1, a + 0.5], Xr)
        Yr = [N(f(z)) for z in Xr]
        Xl = a .- [10.0^(-i) for i in 1:rows-2]
        Xl = vcat([a - 1, a - 0.5], Xl)
        Yl = [N(f(z)) for z in Xl]
    # pretty_table(hcat(Xl, Yl, Xr, Yr), header = ["x → $(a)⁻", "y", "x → $(a)⁺", "y"], formatters = ft_printf(format), backend = Val(:html))
	hl_left = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "#0041C2"))
	hl_right = HtmlHighlighter((data, i, j) -> (j == 4) , HtmlDecoration(color = "red"))
	# pretty_table(HTML, hcat(Xl, Yl, Xr, Yr), header = ["x → $(a)⁻", "y", "x → $(a)⁺", "y"], formatters = ft_printf(format), highlighters = (hl_head, hl_left, hl_right))
	pretty_table(HTML, hcat(Xl, Yl, Xr, Yr), header = ["x → $(a)⁻", "y", "x → $(a)⁺", "y"], formatters = ft_printf(format), highlighters = (hl_left, hl_right))
    end
end

# Test ###################################################
# limittable(f, 3, rows = 10)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
    limittable(f, a::Sym; rows::Int=5, format="%10.2f")

a: is either oo (meaning ∞) or -oo (meaning -∞)\n
rows: number of rows to compute (default is 5 rows)\n
format: a string that specifies c-style printf format for numbers (default is %10.2f)
"""
function limittable(f, a::Sym; rows::Int=5, format="%10.2f") # for infinite x->oo/-oo
	# hl_head = HtmlHighlighter((data, i, j) -> (i == 1) , HtmlDecoration(font_weight = "bold"))
    if a == oo
        X = [10.0^(i+1) for i in 1:rows]
        Y = [N(f(z)) for z in X]
		hl_right = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "red"))
        # pretty_table(HTML, hcat(X, Y); header = ["x → ∞", "y"], formatters = ft_printf(format), highlighters = (hl_head, hl_right))
		pretty_table(HTML, hcat(X, Y); header = ["x → ∞", "y"], formatters = ft_printf(format), highlighters = (hl_right))
    elseif a == -oo
        X = [-1*10.0^(i+1) for i in 1:rows]
        Y = [N(f(z)) for z in X]
		hl_left = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "#0041C2"))
        # pretty_table(HTML, hcat(X, Y); header = ["x → -∞", "y"], formatters = ft_printf(format), highlighters = (hl_head, hl_left))
		pretty_table(HTML, hcat(X, Y); header = ["x → -∞", "y"], formatters = ft_printf(format), highlighters = (hl_left))
    end

end

# Test ###################################################
# limittable(f, oo, rows = 10)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
    lim(f, var, c; dir = "")

``\\lim_{x \\to c} f(x) = L``\n
var: the variable\n
c: the value to approach includeing -∞ (-oo) and ∞ (oo)\n
dir: a string indicating which side to take the limit from. Default is "" which takes the two sided limit, "+" takes the limit from the right, "-" takes the limit from the left
"""
function lim(f, var, c; dir = "")
    lhl = limit(f, var, c, dir="-")
    rhl = limit(f, var, c, dir="+")
	if lhl.is_number && rhl.is_number
		if dir == ""
			rhl == lhl ? rhl : missing # if rhl and lhl are the same return rhl, else return missing
		elseif dir == "+"
			rhl
		else
			lhl
		end
	else
		missing
	end
end

# Test ###################################################
# lim(f, x, 3)
# lim(f, x, oo)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
    criticalpoints(f(x))

Find the critical points of the function f(x).

Returns a pair of vectors with the first vector the values that make ``f(x) = 0`` and the second vector the values that make ``f(x)`` undefined.
"""
function criticalpoints(f)
	crpt_num = solve(f)
	#crpt_num = N.(crpt_num)
	crpt_den = solve(simplify(1/f)) #without simplify failure
	#crpt_den = N.(crpt_den)

	crpt_num = [real(z) for z in N.(crpt_num)] # Get rid of complex (looking) solutions
	crpt_den = [real(z) for z in N.(crpt_den)] # Get rid of complex (looking) solutions
	(zeros = sort(crpt_num), undefined = sort(crpt_den))
end

# Test ###################################################
# criticalpoints(g(x))
# criticalpoints(s(x))
# criticalpoints(g′′(x))

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
    criticalpoints(a::T) where {T <: Real}

Find the critical points for the constant function f(x).

Returns the pair of vectors ([], []).
"""
function criticalpoints(a::T) where {T <: Real}
	(zeros = [], undefined = [])
end

# criticalpoints(c(x))

"""
    getsign(f, val)

Find the sign of the function `f` at the value `val`.

Returns a pair of vectors with the first vector the values that make ``f(x) = 0`` and the second vector the values that make ``f(x)`` undefined.
"""
function getsign(f, val) # get sign of single value for f
    f(val) > 0 ? "+" : "-"
end

# Test ###################################################
# getsign(f, 0)
# getsign(g, .5)
# getsign(g′′, 3)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	domain_from_str(str::String)

Converts a string that represents an interval into the left and right grouping symbols and the left and right endpoints into values.

Returns:
`left_symbol, left_value, right_value, right_symbol`
"""
function domain_from_str(str::String)
	left_symbol = str[1]
	right_symbol = str[end]
	left_value, right_value = strip.(split(str[2:prevind(str, end, 1)], ","))
	if left_value == "-oo" || left_value == "-∞"
		left_value = -∞
	elseif occursin(".", left_value)
		left_value = parse(Float64, left_value)
	else
		left_value = parse(Int64, left_value)
	end
	if right_value == "oo" || right_value == "∞"
		right_value = ∞
	elseif occursin(".", right_value)
		right_value = parse(Float64, right_value)
	else
		right_value = parse(Int64, right_value)
	end
	left_symbol, left_value, right_value, right_symbol
end

# Test ###################################################
# domain_from_str("(-oo, oo)")
# domain_from_str("(-∞, ∞)")
# domain_from_str("(2, 5)")
# domain_from_str("(2.0, 5)")

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

begin
	#summary code
	abstract type Interval end
	struct OpenOpenInterval <: Interval
	    left
	    right
	end
	struct OpenClosedInterval <: Interval
	    left
	    right
	end
	struct ClosedOpenInterval <: Interval
	    left
	    right
	end
	struct ClosedClosedInterval <: Interval
	    left
	    right
	end
end

function convert_to_interval(domain::String)
    pattern = r"\s*(\[|\()\s*(-?[\p{Any}|\d]*)\s*,\s*(-?[\p{Any}|\d]*)\s*(\]|\))\s*"
    re_matched = match(pattern, domain)
	println("re_matched[1] = $(re_matched[1]), re_matched[2] = $(re_matched[2]), re_matched[3] = $(re_matched[3]), re_matched[4] = $(re_matched[4])")
    if re_matched[1] == "["
        if re_matched[4] == "]"
            left = tryparse(Float64, re_matched[2])
            right = tryparse(Float64, re_matched[3])
            domain = ClosedClosedInterval(left, right)
        elseif re_matched[4] == ")"
            left = tryparse(Float64, re_matched[2])
            right = (re_matched[3] == "∞" || re_matched[3] == "oo") ? oo : tryparse(Float64, re_matched[3])
            domain = ClosedOpenInterval(left, right)
        end
    elseif re_matched[1] == "("
        if re_matched[4] == "]"
            left = (re_matched[2] == "-∞" || re_matched[2] == "-oo") ? -oo : tryparse(Float64, re_matched[2])
            right = tryparse(Float64, re_matched[3])
            domain = OpenClosedInterval(left, right)
        elseif re_matched[4] == ")"
            left = (re_matched[2] == "-∞" || re_matched[2] == "-oo") ? -oo : tryparse(Float64, re_matched[2])
            right = (re_matched[3] == "∞" || re_matched[3] == "oo") ? oo : tryparse(Float64, re_matched[3])
            domain = OpenOpenInterval(left, right)
        end
    end
end

# Test ###################################################
# convert_to_interval("(-2, 2π)") # ASk form on hiw to do this!
# tpattern = r"\s*(\[|\()\s*(-?[\p{Any}|\d]*)\s*,\s*(-?[\p{Any}|\d]*)\s*(\]|\))\s*"
# tre_matched = match(tpattern, "(-2, 2π)")
# tre_matched[3]
# if occursin("π", tre_matched[3])
# 	split(tre_matched[3], "π")
# end
# End Test ###################################################

begin
	function end_behavior_aux(f, interval::ClosedClosedInterval)
	    f(interval.left), f(interval.right)
	end
	function end_behavior_aux(f, interval::ClosedOpenInterval)
	    f(interval.left), missing
	end
	function end_behavior_aux(f, interval::OpenClosedInterval)
	    missing, f(interval.right)
	end
	function end_behavior_aux(f, interval::OpenOpenInterval)
	    missing, missing
	end
end




###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
function getsigns_aux(f, domain, crpt; xrange = missing)
	#Can I pull out the test_pt calculations into their own function to also be used in the signcharts function to set xrange so they line up?
	signs = String[]
	test_pt = Real[]
	
	_, left_value, right_value, _ = domain_from_str(domain) # Replaced left_symbol, right_symbol with _.
	# if !ismissing(xrange)
	# 	if 

	if length(crpt) == 0
		if left_value == -∞ && right_value == ∞
			push!(test_pt, 0)
			push!(signs, getsign(f, test_pt[1]))
		elseif left_value == -∞
			push!(test_pt, right_value - 1)
			push!(signs, getsign(f, test_pt[1]))
		elseif right_value == ∞	
			push!(test_pt, left_value + 1)
			push!(signs, getsign(f, test_pt[1]))
		else
			push!(test_pt, mean([left_value, right_value]))
			push!(signs, getsign(f, test_pt[1]))
		end
	elseif length(crpt) == 1
		if left_value < crpt[1]
			if left_value == -∞
				push!(test_pt, crpt[1] - 1)
				push!(signs, getsign(f, test_pt[1]))
			else
				push!(test_pt, mean([left_value, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
			end
			if right_value > crpt[1]
				if right_value == ∞
					push!(test_pt, crpt[1] + 1)
					push!(signs, getsign(f, test_pt[2]))
				else
					push!(test_pt, mean([right_value, crpt[1]]))
					push!(signs, getsign(f, test_pt[2]))
				end
			end
		elseif right_value > crpt[1]
			if right_value == ∞
				push!(test_pt, crpt[1] + 1)
				push!(signs, getsign(f, test_pt[1]))
			else
				push!(test_pt, mean([right_value, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
			end
		end
	else
		d_avg = 0
		for i in 1:length(crpt)-1
			d_avg += crpt[i+1] - crpt[i]
		end
		d_avg = ceil(d_avg/(length(crpt) - 1))

		offset_index = 0
		if left_value < crpt[1]
			if !ismissing(xrange) && xrange[1] < crpt[1]
				temp = ceil(mean([xrange[1], crpt[1]]))
				temp = temp < .25 ? temp -= .5 : temp
				push!(test_pt, temp)
				push!(signs, getsign(f, test_pt[1]))
				offset_index = 1
			else
				push!(test_pt, mean([crpt[1] - d_avg, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
				offset_index = 1
			end
		end

		for i in 2:length(crpt)
			if left_value < crpt[i]
				push!(test_pt,mean([crpt[i-1], crpt[i]]))
				push!(signs, getsign(f, test_pt[i-1+offset_index]))
			end
		end
		
		if crpt[end] < right_value
			if !ismissing(xrange) && crpt[end] < xrange[2]
				temp = ceil(mean([xrange[2], crpt[end]]))
				temp = temp < .25 ? temp += .5 : temp
				push!(test_pt, temp)
				push!(signs, getsign(f, last(test_pt)))
			else
				push!(test_pt, mean([crpt[end] + d_avg, crpt[end]]))
				push!(signs, getsign(f, last(test_pt)))
			end
		end
		
	end
	
	test_pt, signs
end

# Test ###################################################
# cp = convert.(Float64, sort(append!(criticalpoints(p(x))[1], criticalpoints(p(x))[2])))
# getsigns_aux(p(x), "(-∞, ∞)", cp; xrange = (-4, 5))
# getsigns_aux(p(x), "[-4, 5)", cp; xrange = missing)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################


"""
	function getsigns(f, crpt::Vector{T}; domain = "(-∞, ∞)") where {T <: Real}

crpt: vector of numbers\n
domian: the domain of the function if it's not all real numbers. Note you cannot use the unicode infinity symbol "∞" here but must use "oo". (Hope to resolve this. Note it's confusing the substring slice str[2:end-1] in the `domain_from_str` function.)\n
Find the signs of the test values and their signs.

Returns a pair of vectors: vector of test points and a vector of strings.

Example \n
For ``p(x) = (x+2)(x-1)(x-3)``

p(x) = (x+2)*(x-1)*(x-3)
getsigns(p, [-1, 1, 3])

returns
([-2.0, 0.0, 2.0, 4.0], ["-", "+", "-", "+"])
"""
function getsigns(f, crpt::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
	sort!(crpt)
	getsigns_aux(f, domain, crpt; xrange)
end

"""
	function getsigns(f, crpt::Tuple{Vector{Any}, Vector{Any}}; domain = "(-∞, ∞)")

crpt: vector of numbers
Find the signs of the test values and their signs.

Returns a pair of vectors: vector of test points and a vector of strings.
"""
function getsigns(f, crpt::Tuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Any, Sym}}
	crpt = sort(append!(crpt[1], crpt[2]))
# println("getsigns -> crpt: $crpt")	
	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# println("getsigns -> crpt -> N: $crpt")	
	crpt = convert.(Float64, crpt)
	
	getsigns_aux(f, domain, crpt; xrange)
end

# Test ###################################################
# getsigns(p)

# pp_crpt[1]
# pp_crpt[2]
# ncrpt = N(pp_crpt)
# [real(z) for z in ncrpt]
# pp_crpt

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	function getsigns(f, crpt::Tuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)") where {S,T <: Union{Real, Sym}}

crpt: pair of vectors can be from the `criticalpoints` function.
Find the signs of the test values and their signs.

Returns a pair of vectors: vector of test points and a vector of strings.


"""
function getsigns(f, crpt::Tuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Real, Sym}}
	crpt = sort(append!(crpt[1], crpt[2]))
# println("getsigns -> crpt: $crpt")	
	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# println("getsigns -> crpt -> N: $crpt")	
	convert.(Float64, crpt)

	getsigns_aux(f, domain, crpt; xrange)
end


function getsigns(a::T) where {T <: Real}
	if a > 0
		[0], ["+"]
	elseif a < 0
		[0], ["-"]
	else
		[0], [""]
	end
end

# Test ###################################################
# getsigns(p, [-1, 1, 3])
# getsigns(s, [0]; domain = "[0, oo)")
# getsigns(s, [0]; domain = "[0, ∞)")
# getsigns(g, criticalpoints(g(x)))
# getsigns(g, criticalpoints(g(x)), domain="(.1, ∞)")
# getsigns(g′′, criticalpoints(g′′(x)))
# getsigns(s, criticalpoints(s(x)), domain="[0,∞)")
# getsigns(g, criticalpoints(g(x)))
# getsigns(p, ([1], [2]))
# getsigns(c, criticalpoints(c(x)))

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################


"""
    signchart(a::T; label="", domain = "(-oo, oo)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}

label: makes label for sign chart along left side\n
domain: of the funtion the sign chart is being made for\n
horiz_jog: \n
size: of the sign chart\n
dotverticaljog: \n
marksize: \n
tickfontsize: \n
imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
"""
function signchart(a::T; label="", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}
    #If there are no crpts just plot the sign of the function at 0
    # if a = 0 plot an empty string
	if ismissing(xrange)
		interval = convert_to_interval(domain)
		if interval.left == -∞ && interval.right == ∞ || interval.left == -oo && interval.right == oo
			xrange = (-1, 1)
		elseif interval.left == -∞ ||interval.left == -oo
			xrange = (interval.right-1, interval.right)
		elseif interval.right == ∞ || interval.right == oo
			xrange = (interval.left, interval.left+1)
		else
			xrange = (interval.left, interval.right)
		end
	end
	if a ≠ 0
		# mdpts = [0] # rename test_pts?
		mdpts = [mean([xrange[1], xrange[2]])] # rename test_pts?
		signs = a > 0 ? ["+"] : ["-"]
	else
		# mdpts = [0] # rename test_pts?
		mdpts = [mean([xrange[1], xrange[2]])] # rename test_pts?
		signs = [""]
	end
    
    gr()
	# p = Plots.plot(mdpts, 0, yaxis = false, label = label, legend = false, framestyle = :grid, fmt = imageFormat, title = label, titleloc = :left, tickfonthalign = :left)
	p = Plots.plot(mdpts, 0, yaxis = false, legend = false, framestyle = :grid, fmt = imageFormat, ticks = :none)
	p = plot!(title = label, titleloc = :left, tickfonthalign = :left)
    p = yticks!([0],[""])
    p = plot!(size=size)
    p = plot!(ylims=(-.05,.6))
	p = plot!(xlims=(xrange[1], xrange[2]))    
    p = annotate!([(mdpts[i], .5, text(signs[i], :center, 30)) for i in 1:length(mdpts)])
    
    p
end

# Test ###################################################
# signchart(d(x), label = "d")
# dp = diff(d)
# signchart(dp(x), label = "dp")

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################




"""
signchart(f(x); label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

label: makes label for sign chart along left side\n
domain: of the funtion the sign chart is being made for\n
horiz_jog: moves the signchart horizontally\n
size: of the sign chart\n
dotverticaljog: moves the dot on the axis vertically\n
marksize: changes the size of the dot\n
tickfontsize: changes the font size of the tick labels\n
imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
"""
function signchart(f; label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 18, imageFormat = :svg, xrange = missing)
	#FIX: Need to stop showing critical points not in the domain
	
	if f.is_number
		a = convert(Real, f)
		p = signchart(a; label=label, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		crpt_num, crpt_den = criticalpoints(f) #get the critical pts
		crpt = sort(vcat(crpt_num, crpt_den)) #put them into a list and sort
		crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
		crpt = convert.(Float64, crpt) #convert to floats

		#If there are no crpts just plot the sign of the function at 0
		if length(crpt) == 0
			mdpts = 0 # rename test_pts?
			signs = f(0) > 0 ? "+" : "-"
		#else get the midpts between crpts and the sign there
		else
			mdpts, signs = getsigns(f, crpt, domain = domain, xrange = xrange)
		end

		y = zeros(length(mdpts)) #make array of zeros of length of mdpts
		gr()
		p = Plots.plot(mdpts, y, yaxis = false, label = label, legend = false, framestyle = :grid, fmt = imageFormat, title = label, titleloc = :left, tickfonthalign = :left)
		# p = yaxis!(label, yguidefontsize=18)
		p = yticks!([0],[""])
		p = plot!(size=size)
		p = plot!(ylims=(-.05,.6))
		if ismissing(xrange)
			p = plot!(xlims=(mdpts[1]-(1+horiz_jog), mdpts[end]+1))
		else
			p = plot!(xlims=(xrange[1], xrange[2]))
		end
		p = hline!([0], linecolor = :black)
		#new
		ticklabels = [ @sprintf("%3.2f",convert(Float64,x)) for x in crpt ]
		crpt_float = [convert(Float64,x) for x in crpt]
		p = Plots.plot!(xticks=(crpt_float, ticklabels), tickfontsize=tickfontsize, legend = false, tickfontvalign = :bottom)
		#new
		#p = plot!(xlims=(values[1]-horiz_jog, values[2]), xticks=crpt, tickfontsize=tickfontsize)
		p = annotate!([(mdpts[i], .5, text(signs[i], :center, 30)) for i in 1:length(mdpts)])
		p = vline!(crpt, line = :dash, linecolor = :red)
		if !isempty(crpt_num)
			p = Plots.plot!(crpt_num, zeros(length(crpt_num)) .+ dotverticaljog, seriestype = :scatter, markercolor = :black, markersize = marksize)
		end
		if !isempty(crpt_den)
			p = Plots.plot!(crpt_den, zeros(length(crpt_den)) .+ dotverticaljog, seriestype = :scatter, markercolor = :white, markersize = marksize)
		end
	end
    p
end

# Test ###################################################
# signchart(p(x), xrange = (-4, 5))
# signchart(p(x), domain = "[-4, 5)")
# signchart(p(x), domain = "[-3, 2)")
# signchart(s(x), domain = "[0, ∞)", label="s")



# signchart(c(x), label="c")

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	signcharts(f(x); labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits

Generate stacked sign charts for the given function and its first and second derivative. 
"""
function signcharts(f; labels="y",  domain = "(-∞, ∞)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)
	labels = [labels, labels*"′", labels*"′′"]

	f′ = diff(f(x))
	f′′ = diff(f′(x))
	
	
	if f′.is_constant()
		f′ = convert(Real, f′)
		f′′ = 0.0
	elseif f′′.is_constant()
		f′′ = convert(Real, f′′)
	end
	
	f_sc = signchart(f; label = labels[1], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	fp_sc = signchart(f′; label = labels[2], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	fpp_sc = signchart(f′′; label = labels[3], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)

	Plots.plot(f_sc, fp_sc, fpp_sc, layout = (3,1))
end

# plot_function_sign_chart(p(x), (-4, 5))
# Test ###################################################
# signcharts(p(x))
# signcharts(p(x), xrange = (-4, 5))
# signchart(q(x); label="q")
# signcharts(l(x), domain = ldomain)

# f(x) = (x+2)*(x+1)*(x-2)

# d(x) = 2x
# d(x) = x^2
# d′ = diff(d(x))
# d′′ = diff(d′(x))
# typeof(d′′)
# d′′ = convert(Real, d′′)
# criticalpoints(d′′)
# getsigns(d′′, criticalpoints(d′′))
# signcharts(d(x))

# signcharts(s(x), domain = "[0,oo)", xrange = (-.25, 2))
# signcharts(p(x), domain = "(-oo,oo)")
# signcharts(g(x))

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	signcharts(a::T; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}

xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits

Generate stacked sign charts for the given function and its first and second derivative. 
"""
function signcharts(a::T; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}
	labels = [labels, labels*"′", labels*"′′"]

	if ismissing(xrange)
		interval = convert_to_interval(domain)
		if interval.left == -∞ && interval.right == ∞
			xrange = (-1, 1)
		elseif interval.left == -∞
			xrange = (interval.right-1, interval.right)
		elseif interval.right == ∞
			xrange = (interval.left, interval.left+1)
		else
			xrange = (interval.left, interval.right)
		end
	end
	
	f_sc = signchart(a; label = labels[1], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	
	fp_sc = signchart(0; label = labels[2], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	
	fpp_sc = signchart(0; label = labels[3], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)

	Plots.plot(f_sc, fp_sc, fpp_sc, layout = (3,1))
end
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################



"""
    functionplot(f(x), xrange; label = "", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg)

xrange: a pair giving the ``x`` limits of the plot\n
horiz_ticks: a range giving the horizontal ticks to be displayed\n
vert_ticks: a range giving the horizontal ticks to be displayed\n
yrange: a pair giving the ``y`` limits of the plot\n
xsteps: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`)
"""
function functionplot(f, xrange; label = "", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20)
    #imageFormat can be :svg, :png, ...
    #p = plot(values, f, legend = :outertopright, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat)
	# println(xrange)
	values = xrange[1]:xsteps:xrange[2]
	if ismissing(horiz_ticks)
		horiz_ticks = xrange[1]:xrange[2]
	end
	
	p = Plots.plot(values, f, legend = false, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat, size=size, tickfontsize=tickfontsize)
	if !ismissing(yrange)
		p = Plots.plot!(ylim = yrange)
	end
	if !ismissing(vert_ticks) 
		p = Plots.plot!(yticks=vert_ticks)
	end
    
	p = yaxis!(label, yguidefontsize=18)
    #Draw vertical asymptotes if they exist
    asymptote_vert = solve(simplify(1/f))
    if length(asymptote_vert) != 0
        p = vline!(asymptote_vert, line = :dash)
    end
    #Draw horizontal asymptote if it exists
    lf_lim=limit(f, x, -oo)
    if lf_lim == -oo || lf_lim == oo || lf_lim == -oo*1im || lf_lim == oo*1im # why did I need oo*1im?
        lf_infty_bool = true
    else
        lf_infty_bool = false
    end
    rt_lim=limit(f, x, oo)
    if rt_lim == -oo || rt_lim == oo || rt_lim == -oo*1im || rt_lim == oo*1im
        rt_infty_bool = true
    else
        rt_infty_bool = false
    end
	# println("lf_lim = $lf_lim, rt_lim = $rt_lim")
	# println("lf_infty_bool = $lf_infty_bool, rt_infty_bool = $rt_infty_bool")

    if !lf_infty_bool && !rt_infty_bool
        if lf_lim == rt_lim && lf_lim.is_number && rt_lim.is_number
            #println("lf_lim = rt_lim")
            p = hline!([lf_lim], line = :dash)
        else
            #println("lf_lim ≠ rt_lim")
			if lf_lim.is_number
            	p = hline!([lf_lim], line = :dash)
			elseif rt_lim.is_number
            	p = hline!([rt_lim],  line = :dash)
			end
        end
    elseif !lf_infty_bool && lf_lim.is_number
        #println("lf_lim = $lf_lim")
        p = hline!([lf_lim], line = :dash)
    elseif !rt_infty_bool && rt_lim.is_number
        #println("rt_lim = $rt_lim")
        p = hline!([rt_lim],  line = :dash)
    end
	
    p
end

# Test ###################################################
# functionplot(t(x), (0, 2π))
# t(x) = sin(x)
# L = lim(t, x, -oo)
# typeof(L)
# L.is_number
# convert(Real, L)
# L = lim(t, x, 2)
# typeof(L)
# L.is_number
# convert(Real, L)

# functionplot(q(x), (1,3))
# functionplot(r(x), (-4,-1); horiz_ticks = -4:.5:-1, size=(1000, 1000))
# functionplot(r1(x), (-1,4); yrange = (-10, 10), vert_ticks = -10:10)

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	plot_function_sign_chart(f, xrange; labels=["f", "f′", "f′′"], domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01)

xrange: a pair giving the ``x`` limits of the plot\n
horiz_ticks: a range giving the horizontal ticks to be displayed\n
vert_ticks: a range giving the horizontal ticks to be displayed\n
yrange: a pair giving the ``y`` limits of the plot\n
xsteps: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`) (default .01)

Plots the function over the sign charts for the function, then its first derivative, and finally its second derivative.
"""
function plot_function_sign_chart(f, arguments; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 1000), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, xrange = missing, yrange = missing, xsteps = .01, stacked::Bool=true, heights=[0.7 ,0.1, 0.1, 0.1])
	# Need to change xrange to "arguments" and add a xrange parameter, then if xrange = missing pass "arguments" to signchart as their xrange
	labels = [labels, labels*"′", labels*"′′"]

	if ismissing(xrange)
		xrange = arguments
	end
	s = signchart(f(x); label=labels[1], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)

	f′ = diff(f(x))
	if f′.is_constant()
		s′ = signchart(f′; label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		s′ = signchart(f′(x); label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	end

	f′′ = diff(f′(x))
	if f′′.is_constant()
		s′′ = signchart(f′′; label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		s′′ = signchart(f′′(x); label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	end

	p = functionplot(f(x), arguments; label = "", horiz_ticks = horiz_ticks, vert_ticks = vert_ticks, yrange = yrange, xsteps = xsteps, size = size, imageFormat = imageFormat)

	if stacked
		lay_out = grid(4,1, heights=heights)
	else
		lay_out = @layout[
			a{0.5w} grid(3,1)
		]
	end
	Plots.plot(p, s, s′, s′′, layout = lay_out, size=size)
end

# Test ###################################################
# plot_function_sign_chart(p(x), (-4, 5))

# plot_function_sign_chart(f(x), (-2,2))
# plot_function_sign_chart(g(x), (-1,4), yrange = (-10, 10))
# plot_function_sign_chart(s(x), (0,9), domain = "[0, ∞)", xrange = (-.25, 9))
# plot_function_sign_chart(p(x), (-3,4))

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
	extrema(f; domain::String = "(-∞, ∞)")

Returns a named tuple where the first element is the the local minima (named minima) and the second element is the local maxima (named maxima).
"""
function extrema(f; domain::String = "(-∞, ∞)") # Check if domain endpoint is an extremum
    f′ = diff(f)
    f′′ = diff(f′)
    crpt_num, crpt_den = criticalpoints(f′)
    second_derivative_at_crpt = []
    for x in crpt_num
        #push!(second_derivative_at_crpt, convert(Float32, f′′(x)))
        push!(second_derivative_at_crpt, (x,f′′(x)))
    end
    #add endpts if they exist
    interval = convert_to_interval(domain)
    left_end, right_end = end_behavior_aux(f, interval)
    max = []
    min = []
    #assuming the derivative is not = 0 at the endpoints, can add code later
	if interval.left ∉ crpt_den && interval.left ≠ -∞
		if f′(interval.left) > 0
			push!(min, (interval.left, left_end))
		elseif f′(interval.left) < 0
			push!(max, (interval.left, left_end))
		elseif f′(interval.left) == 0
			throw(DomainError(0, "extrema function: This can't handle a slope of 0 at the endpoint yet."))
		end
	end
    for (x, x′′) in second_derivative_at_crpt
        if x > interval.left && x < interval.right
            if x′′ < 0
                push!(max, (x,f(x)))
            elseif x′′ > 0
                push!(min, (x,f(x)))
            end
        end
    end
	if interval.right ≠ ∞
		if f′(interval.right) < 0
			push!(min, (interval.right, right_end))
		elseif f′(interval.right) > 0
			push!(max, (interval.right, right_end))
		elseif f′(interval.right) == 0
			throw(DomainError(0, "This can't handle a slope of 0 at the endpoints yet."))
		end
	end
    (minima = min, maxima = max)
end

# Test ###################################################
# s(x) = sqrt(x)
# s′(x) = diff(s(x))
# s′(x)
# extrema(s(x), domain = "[0, ∞)")

# crpt_num, crpt_den = criticalpoints(s′(x))
# crpt_den
# interval.left ∈ crpt_den
# interval = convert_to_interval("[0, ∞)")

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

function inflection_points(f, domain::String = "(-∞, ∞)")
    interval = convert_to_interval(domain)
    f′ = diff(f)
    f′′ = diff(f′)
    f′′′ = diff(f′′)
    crpt_num, crpt_den = criticalpoints(f′′)

    infpt = []
    for x in crpt_num
        if x > interval.left && x < interval.right
            if f′′′ ≠ 0
                push!(infpt, (x,f(x)))
            end
        end
    end

    infpt
end

function extrema_approx(ext, str = false)
    strg = ""
    for m in ext
        if !ismissing(m[2])
            if !str
                @printf("(%.3f, %.3f)", convert(Float64, m[1]), convert(Float64, m[2]))
            else
                strg *= @sprintf("(%.3f, %.3f)", convert(Float64, m[1]), convert(Float64, m[2]))
            end
        end
    end
    if str
        strg
    end
end

begin
	function end_behavior(f, interval::OpenOpenInterval, as_string = false)
	    left_end_val = limit(f(x), x, interval.left)
	    if interval.left == -oo
	        if left_end_val == -oo
	            left_end = "As x → -∞, " * "f(x) → -∞"
	        elseif left_end_val == oo
	            left_end = "As x → -∞, " * "f(x) → ∞"
	        else
	            left_end = "As x → -∞, " * "f(x) → $(left_end_val)"
	        end
	    else
	        left_end = "As x → $(interval.left), " * "f(x) → $(left_end_val)"
	    end
	
	    right_end_val = limit(f(x), x, interval.right)
	    if interval.right == oo
	        if right_end_val == -oo
	            right_end = "As x → ∞, " * "f(x) → -∞"
	        elseif right_end_val == oo
	            right_end = "As x → ∞, " * "f(x) → ∞"
	        else
	            right_end = "As x → ∞, " * "f(x) → $(right_end_val)"
	        end
	    else
	        right_end = "As x → $(interval.right), " * "f(x) → $(right_end_val)"
	    end

		as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
	function end_behavior(f, interval::OpenClosedInterval, as_string = false)
	    if interval.left == -oo
	        left_end_val = limit(f(x), x, -oo)
	        if left_end_val == -oo
	            left_end = "As x → -∞, " * "f(x) → -∞"
	        elseif left_end_val == oo
	            left_end = "As x → -∞, " * "f(x) → ∞"
	        else
	            left_end = "As x → -∞, " * "f(x) → $(left_end_val)"
	        end
	    else
	        left_end = "At endpoint x = $(interval.left), " * "f($(interval.left)) = $(f(interval.left))"
	    end

		right_end_val = f(interval.right)
	    right_end = "At right endpoint x = $(interval.right), " * "f($(interval.right)) = $(right_end_val)"
	
	    as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
	function end_behavior(f, interval::ClosedOpenInterval, as_string = false)
		left_end_val = f(interval.left)
	    left_end = "At left endpoint x = $(interval.left), " * "f($(interval.left)) = $(left_end_val)"
		
	    right_end_val = limit(f(x), x, interval.right)
	    if interval.right == oo
	        if right_end_val == -oo
	            right_end = "As x → ∞, " * "f(x) → -∞"
	        elseif right_end_val == oo
	            right_end = "As x → ∞, " * "f(x) → ∞"
	        else
	            right_end = "As x → ∞, " * "f(x) → $(right_end_val)"
	        end
	    else
	        right_end = "As x → $(interval.right), " * "f(x) → $(right_end_val)"
	    end
		
	    as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
	function end_behavior(f, interval::ClosedClosedInterval, as_string = false)
		left_end_val = f(interval.left)
	    left_end = "At left endpoint x = $(interval.left), " * "f($(interval.left)) = $(left_end_val)"

		right_end_val = f(interval.right)
	    right_end = "At right endpoint x = $(interval.right), " * "f($(interval.right)) = $(right_end_val)"
	
	    as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
end

"""
    function_summary(f; domain::String = "(-∞, ∞)", labels = "y", fig_width = 200, dotverticaljog=0, marksize=8, tickfontsize = 20, format = :side, format_num="%3.2f", horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing)

Takes a function f and outputs the:\n
y-intercept,\n
local max,\n
local min,\n
inflection points,\n
behaviour at infinites/endpoints\n
function sign chart, derivative sign chart, second derivative sign charts
as a named tuple with names (:y_intercept, :max, :min, :inflection, :left_behavior, :right_behavior, :signcharts).


The inputs are:\n
f: is the function to summarize,\n
domain: the domain of the function entered as a string (default "(-∞, ∞)"),\n
labels: is applied to the sign charts (default "y"),\n
dotverticaljog: changes the height of the points on the sign chart (default 0),\n
marksize: changes the diamater of the points on the sign chart (default 8),\n
tickfontsize: changes the font size of the tick marks (default 20),\n
digits: number of digits to round values to,\n
horiz_jog: ?\n
size: size of the signchart (default (1000, 400)),\n
imageFormat: image format for the sign charts (default :svg),\n
xrange: ?
"""
function function_summary(f; domain::String = "(-∞, ∞)", labels = "y", dotverticaljog=0, marksize=8, tickfontsize = 20, digits= 2, horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing)
    #Need to adjust values based on domain
    gr()
    interval = convert_to_interval(domain)
	if interval.left < 0 < interval.right
	    y_intercept = (0, f(0))
		y_intercept = round.(convert.(Float64, y_intercept), digits = digits)
	else
		y_intercept = missing
	end

	sign_chart = signcharts(f; labels=labels, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	    
    f_min, f_max = extrema(f; domain)
	f_min = [simplify.(x) for x in f_min]
	f_max = [simplify.(x) for x in f_max]
	f_max = [round.(pt, digits = digits) for pt in f_max if !ismissing(pt[2])]
	f_min = [round.(pt, digits = digits) for pt in f_min if !ismissing(pt[2])]
	
    infpt = inflection_points(f, domain)
	infpt = [simplify.(x) for x in infpt]
	infpt = [round.(pt, digits = digits) for pt in infpt if !ismissing(pt[2])]

    left_end, right_end = end_behavior(f, interval)
	
	(y_intercept = y_intercept, max = length(f_max) == 0 ? [] : f_max, min = length(f_min) == 0 ? [] : f_min, inflection = length(infpt) == 0 ? [] : infpt, left_behavior = left_end, right_behavior = right_end, signcharts = sign_chart)
end

# Test ###################################################
# f(x) = x^2
# function_summary(f(x))

# p(x) = (x+2)*(x+1)*(x-2)*(x-4)
# p_summary = function_summary(p(x))

# p′ = diff(p(x))
# pp_crpt = criticalpoints(p′(x))

# length(pp_crpt)
# N(pp_crpt[1][1])
# pp_crpt = (collect(pp_crpt[1]))
# imag(pp_crpt[1]) == 0

# p_sum = function_summary(p(x), -3:.01:4)
# p_sum[:y_intercept]
# p_sum[:max]
# p_sum[:min]
# p_sum[:inflection]
# p_sum[:left_behavior]
# p_sum[:right_behavior]
# p_sum[:signcharts]

# f_sum = function_summary(f(x), -3:.01:4; domain = "[-2,1)")

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# End Test ###################################################

"""
    int(f, var)

Find the indefinite integral of function f wrt to the variable var.
"""
function int(f, var)
	integrate(f(x), var)
end

# int(f(x), x)

"""
    int(f, var, a, b)

Find the definite integral of function f from ``a`` to ``b`` wrt to the variable var. 
"""
function int(f, var, a, b)
	integrate(f(x), (var, a, b))
end

# int(f(x), x, 0, 1)

# """
#     graph_f_and_derivative(values, f, horiz_ticks, label = ""; imageFormat = :svg, format=:single, size=(900,800))

# Takes a function f and outputs the:\n
# It's graph and the graph of the derivative of f′.

# The inputs are:\n
# values: values to be plotted (left:inc:right),\n
# f: is the function to plot,\n
# horiz_ticks: horizontal tick values (left:right),\n
# label = "" (name of the function);\n
# imageFormat = :svg (options :svg, :png, etc),\n
# format=:single (:single = for both graphs on a single coordinate system
#                 :dual = side by side of graphs of f and f′),\n
# size=(300,300), but for :dual if size = (x, y) then it will be (2x, y)
# """
# function graph_f_and_derivative(f, xrange; horiz_ticks = missing, label = "", imageFormat = :svg, format=:single, size=(300,300))
#     #imageFormat can be :svg, :png, ...

# 	if ismissing(horiz_ticks)
# 		horiz_ticks = xrange[1]:xrange[2]
# 	end
	
#     f′ = diff(f(x))

#     p = Plots.plot(xrange, f, label=label, legend = false, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat, color = :black)
#     p = yaxis!(label)
#     if format == :single
#         if f.is_polynomial() && degree(f) == 1 #I think it was working before, but now f.is_polynomial() is broken
#             p = hline!([f′], line = :dash)
#         else
#             p = Plots.plot!(xrange, f′, linestyle = :dash)
#         end
#         p
#     # elseif format == :dual
#     #     fst, lst = split(label, "(")
#     #     label = fst*"′("*lst
#     #     if f.is_polynomial() && degree(f) == 1
#     #         #println("f.is_polynomial = $(f.is_polynomial()) and degree(f) = $degree(f)")
#     #         fcn_values = fill(f′, size(values)[1])
#     #         q = Plots.plot(xrange, fcn_values, legend = false, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat, color = :red, linestyle = :dash)
#     #         q = yaxis!(label)
#     #     else
#     #         #println("f.is_polynomial = $(f.is_polynomial()) and degree(f) = $degree(f)")
#     #         q = Plots.plot(xrange, f′, legend = false, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat, color = :red, linestyle = :dash)
#     #         q = yaxis!(label)
#     #     end

#     #     size_dual =(size[1]*2, size[2])
#     #     Plots.plot(p, q, layout = (1,2), size=size_dual)
#     end
# end

function function_summary_latex(summary, name; domain = "(-∞, ∞)")
	interval = convert_to_interval(domain)
	
	y_intercept = string(summary[:y_intercept])
	
	max = ""
	n = length(summary[:max])
	for (i,m) in enumerate(summary[:max])
		max *= string(round.(m, digits = 2))
		max *= i < n ? ", " : ""
	end

	min = ""
	n = length(summary[:min])
	for (i,m) in enumerate(summary[:min])
		min *= string(round.(m, digits = 2))
		min *= i < n ? ", " : ""
	end

	inflection = ""
	n = length(summary[:inflection])
	for (i,m) in enumerate(summary[:inflection])
		inflection *= string(round.(m, digits = 2))
		inflection *= i < n ? ", " : ""
	end

	if summary[:left_behavior] == -∞
		left_behavior = "\\lim_{x \\to -\\infty} f(x) = -\\infty"
	elseif summary[:left_behavior] == ∞
		left_behavior = "\\lim_{x \\to -\\infty} f(x) = \\infty"
	else
		left_behavior = "f($(interval.left)) = $(summary[:left_behavior])"
	end

	if summary[:right_behavior] == -∞
		right_behavior = "\\lim_{x \\to \\infty} f(x) = -\\infty"
	elseif summary[:right_behavior] == ∞
		right_behavior = "\\lim_{x \\to \\infty} f(x) = \\infty"
	else
		right_behavior = "f($(interval.right)) = $(summary[:right_behavior])"
	end
	"""
	\\begin{description}
		\\item[``y``-intercept:] $y_intercept
		\\includegraphics[scale=.7]{$name.pdf}
		\\item[Extrema:]
		\\begin{tabular}{ll}
			Local max: & $max \\\\
			Local min: & $min \\\\
		\\end{tabular}
		\\item[Inflection points:] $inflection	
		\\item[Behavior at infinities:]
		$left_behavior
		$right_behavior
	\\end{description} 
	"""
		
end








###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
# try to fix graphing problem
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
# function getsigns_aux_fix(f, domain, crpt; xrange = missing)
# 	#Can I pull out the test_pt calculations into their own function to also be used in the signcharts function to set xrange so they line up?
# 	signs = String[]
# 	test_pt = Real[]
	
# 	_, left_value, right_value, _ = domain_from_str(domain) # Replaced left_symbol, right_symbol with _.
# 	# if !ismissing(xrange)
# 	# 	if 

# 	if length(crpt) == 0
# 		if left_value == -∞ && right_value == ∞
# 			push!(test_pt, 0)
# 			push!(signs, getsign(f, test_pt[1]))
# 		elseif left_value == -∞
# 			push!(test_pt, right_value - 1)
# 			push!(signs, getsign(f, test_pt[1]))
# 		elseif right_value == ∞	
# 			push!(test_pt, left_value + 1)
# 			push!(signs, getsign(f, test_pt[1]))
# 		else
# 			push!(test_pt, mean([left_value, right_value]))
# 			push!(signs, getsign(f, test_pt[1]))
# 		end
# 	elseif length(crpt) == 1
# 		if left_value < crpt[1]
# 			if left_value == -∞
# 				push!(test_pt, crpt[1] - 1)
# 				push!(signs, getsign(f, test_pt[1]))
# 			else
# 				push!(test_pt, mean([left_value, crpt[1]]))
# 				push!(signs, getsign(f, test_pt[1]))
# 			end
# 			if right_value > crpt[1]
# 				if right_value == ∞
# 					push!(test_pt, crpt[1] + 1)
# 					push!(signs, getsign(f, test_pt[2]))
# 				else
# 					push!(test_pt, mean([right_value, crpt[1]]))
# 					push!(signs, getsign(f, test_pt[2]))
# 				end
# 			end
# 		elseif right_value > crpt[1]
# 			if right_value == ∞
# 				push!(test_pt, crpt[1] + 1)
# 				push!(signs, getsign(f, test_pt[1]))
# 			else
# 				push!(test_pt, mean([right_value, crpt[1]]))
# 				push!(signs, getsign(f, test_pt[1]))
# 			end
# 		end
# 	else
# 		d_avg = 0
# 		for i in 1:length(crpt)-1
# 			d_avg += crpt[i+1] - crpt[i]
# 		end
# 		d_avg = ceil(d_avg/(length(crpt) - 1))

# 		offset_index = 0
# 		if left_value < crpt[1]
# 			if !ismissing(xrange) && xrange[1] < crpt[1]
# 				temp = ceil(mean([xrange[1], crpt[1]]))
# 				temp = temp < .25 ? temp -= .5 : temp
# 				push!(test_pt, temp)
# 				push!(signs, getsign(f, test_pt[1]))
# 				offset_index = 1
# 			else
# 				push!(test_pt, mean([crpt[1] - d_avg, crpt[1]]))
# 				push!(signs, getsign(f, test_pt[1]))
# 				offset_index = 1
# 			end
# 		end

# 		for i in 2:length(crpt)
# 			if left_value < crpt[i]
# 				push!(test_pt,mean([crpt[i-1], crpt[i]]))
# 				push!(signs, getsign(f, test_pt[i-1+offset_index]))
# 			end
# 		end
		
# 		if crpt[end] < right_value
# 			if !ismissing(xrange) && crpt[end] < xrange[2]
# 				temp = ceil(mean([xrange[2], crpt[end]]))
# 				temp = temp < .25 ? temp += .5 : temp
# 				push!(test_pt, temp)
# 				push!(signs, getsign(f, last(test_pt)))
# 			else
# 				push!(test_pt, mean([crpt[end] + d_avg, crpt[end]]))
# 				push!(signs, getsign(f, last(test_pt)))
# 			end
# 		end
		
# 	end
	
# 	test_pt, signs
# end

# # Test ###################################################
# # cp = convert.(Float64, sort(append!(criticalpoints(p(x))[1], criticalpoints(p(x))[2])))
# # getsigns_aux(p(x), "(-∞, ∞)", cp; xrange = (-4, 5))
# # getsigns_aux(p(x), "[-4, 5)", cp; xrange = missing)

# # begin
# # 	c(x) = 2
# # 	d(x) = 2x
# # 	f(x) = x^2
# # 	g(x) = x/(x-1)
# # 	g′ = diff(g(x))
# # 	g′′ = diff(g′(x))
# # 	p(x) = (x+2)*(x-1)*(x-3)
# # 	r(x) = 1/(x+3)
# # 	r1(x) = 1/(x-2)+1
# # 	s(x) = sqrt(x)
# # 	sdomain = "[0, ∞)"
# # 	q(x) = (x-1.5)*(x-2.3)
# # 	l(x) = log(x)
# # 	ldomain = "(0, ∞)"
# #   t(x) = sin(x)
# # end
# # End Test ###################################################




# # Test ###################################################
# # getsigns(p, [-1, 1, 3])
# # getsigns(s, [0]; domain = "[0, oo)")
# # getsigns(s, [0]; domain = "[0, ∞)")
# # getsigns(g, criticalpoints(g(x)))
# # getsigns(g, criticalpoints(g(x)), domain="(.1, ∞)")
# # getsigns(g′′, criticalpoints(g′′(x)))
# # getsigns(s, criticalpoints(s(x)), domain="[0,∞)")
# # getsigns(g, criticalpoints(g(x)))
# # getsigns(p, ([1], [2]))
# # getsigns(c, criticalpoints(c(x)))

# # begin
# # 	c(x) = 2
# # 	d(x) = 2x
# # 	f(x) = x^2
# # 	g(x) = x/(x-1)
# # 	g′ = diff(g(x))
# # 	g′′ = diff(g′(x))
# # 	p(x) = (x+2)*(x-1)*(x-3)
# # 	r(x) = 1/(x+3)
# # 	r1(x) = 1/(x-2)+1
# # 	s(x) = sqrt(x)
# # 	sdomain = "[0, ∞)"
# # 	q(x) = (x-1.5)*(x-2.3)
# # 	l(x) = log(x)
# # 	ldomain = "(0, ∞)"
# #   t(x) = sin(x)
# # end
# # End Test ###################################################


# """
#     signchart(a::T; label="", domain = "(-oo, oo)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}

# label: makes label for sign chart along left side\n
# domain: of the funtion the sign chart is being made for\n
# horiz_jog: \n
# size: of the sign chart\n
# dotverticaljog: \n
# marksize: \n
# tickfontsize: \n
# imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
# xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
# """
# function signchart_fix(a::T; label="", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}
#     #If there are no crpts just plot the sign of the function at 0
#     # if a = 0 plot an empty string
# 	if ismissing(xrange)
# 		interval = convert_to_interval(domain)
# 		if interval.left == -∞ && interval.right == ∞ || interval.left == -oo && interval.right == oo
# 			xrange = (-1, 1)
# 		elseif interval.left == -∞ ||interval.left == -oo
# 			xrange = (interval.right-1, interval.right)
# 		elseif interval.right == ∞ || interval.right == oo
# 			xrange = (interval.left, interval.left+1)
# 		else
# 			xrange = (interval.left, interval.right)
# 		end
# 	end
# 	if a ≠ 0
# 		# mdpts = [0] # rename test_pts?
# 		mdpts = [mean([xrange[1], xrange[2]])] # rename test_pts?
# 		signs = a > 0 ? ["+"] : ["-"]
# 	else
# 		# mdpts = [0] # rename test_pts?
# 		mdpts = [mean([xrange[1], xrange[2]])] # rename test_pts?
# 		signs = [""]
# 	end
    
#     gr()
# 	# p = Plots.plot(mdpts, 0, yaxis = false, label = label, legend = false, framestyle = :grid, fmt = imageFormat, title = label, titleloc = :left, tickfonthalign = :left)
# 	p = Plots.plot(mdpts, 0, yaxis = false, legend = false, framestyle = :grid, fmt = imageFormat, ticks = :none)
# 	p = plot!(title = label, titleloc = :left, tickfonthalign = :left)
#     p = yticks!([0],[""])
#     p = plot!(size=size)
#     p = plot!(ylims=(-.05,.6))
# 	p = plot!(xlims=(xrange[1], xrange[2]))    
#     p = annotate!([(mdpts[i], .5, text(signs[i], :center, 30)) for i in 1:length(mdpts)])
    
#     p
# end

# # Test ###################################################
# # signchart(d(x), label = "d")
# # dp = diff(d)
# # signchart(dp(x), label = "dp")

# # begin
# # 	c(x) = 2
# # 	d(x) = 2x
# # 	f(x) = x^2
# # 	g(x) = x/(x-1)
# # 	g′ = diff(g(x))
# # 	g′′ = diff(g′(x))
# # 	p(x) = (x+2)*(x-1)*(x-3)
# # 	r(x) = 1/(x+3)
# # 	r1(x) = 1/(x-2)+1
# # 	s(x) = sqrt(x)
# # 	sdomain = "[0, ∞)"
# # 	q(x) = (x-1.5)*(x-2.3)
# # 	l(x) = log(x)
# # 	ldomain = "(0, ∞)"
# #   t(x) = sin(x)
# # end
# # End Test ###################################################




# """
# signchart(f(x); label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

# label: makes label for sign chart along left side\n
# domain: of the funtion the sign chart is being made for\n
# horiz_jog: moves the signchart horizontally\n
# size: of the sign chart\n
# dotverticaljog: moves the dot on the axis vertically\n
# marksize: changes the size of the dot\n
# tickfontsize: changes the font size of the tick labels\n
# imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
# xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
# """
# function signchart_fix(f; label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 18, imageFormat = :svg, xrange = missing)
# 	#FIX: Need to stop showing critical points not in the domain
	
# 	if f.is_number
# 		a = convert(Real, f)
# 		p = signchart_fix(a; label=label, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
# 	else
# 		crpt_num, crpt_den = criticalpoints(f) #get the critical pts
# 		crpt = sort(vcat(crpt_num, crpt_den)) #put them into a list and sort
# 		crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# 		crpt = convert.(Float64, crpt) #convert to floats

# 		#If there are no crpts just plot the sign of the function at 0
# 		if length(crpt) == 0
# 			mdpts = 0 # rename test_pts?
# 			signs = f(0) > 0 ? "+" : "-"
# 		#else get the midpts between crpts and the sign there
# 		else
# 			mdpts, signs = getsigns_fix(f, crpt, domain = domain, xrange = xrange)
# 		end

# 		y = zeros(length(mdpts)) #make array of zeros of length of mdpts
# 		gr()
# 		p = Plots.plot(mdpts, y, yaxis = false, label = label, legend = false, framestyle = :grid, fmt = imageFormat, title = label, titleloc = :left, tickfonthalign = :left)
# 		# p = yaxis!(label, yguidefontsize=18)
# 		p = yticks!([0],[""])
# 		p = plot!(size=size)
# 		p = plot!(ylims=(-.05,.6))
# 		if ismissing(xrange)
# 			p = plot!(xlims=(mdpts[1]-(1+horiz_jog), mdpts[end]+1))
# 		else
# 			p = plot!(xlims=(xrange[1], xrange[2]))
# 		end
# 		p = hline!([0], linecolor = :black)
# 		#new
# 		ticklabels = [ @sprintf("%3.2f",convert(Float64,x)) for x in crpt ]
# 		crpt_float = [convert(Float64,x) for x in crpt]
# 		p = Plots.plot!(xticks=(crpt_float, ticklabels), tickfontsize=tickfontsize, legend = false, tickfontvalign = :bottom)
# 		#new
# 		#p = plot!(xlims=(values[1]-horiz_jog, values[2]), xticks=crpt, tickfontsize=tickfontsize)
# 		p = annotate!([(mdpts[i], .5, text(signs[i], :center, 30)) for i in 1:length(mdpts)])
# 		p = vline!(crpt, line = :dash, linecolor = :red)
# 		if !isempty(crpt_num)
# 			p = Plots.plot!(crpt_num, zeros(length(crpt_num)) .+ dotverticaljog, seriestype = :scatter, markercolor = :black, markersize = marksize)
# 		end
# 		if !isempty(crpt_den)
# 			p = Plots.plot!(crpt_den, zeros(length(crpt_den)) .+ dotverticaljog, seriestype = :scatter, markercolor = :white, markersize = marksize)
# 		end
# 	end
#     p
# end

# # Test ###################################################
# # signchart(p(x), xrange = (-4, 5))
# # signchart(p(x), domain = "[-4, 5)")
# # signchart(p(x), domain = "[-3, 2)")
# # signchart(s(x), domain = "[0, ∞)", label="s")



# # signchart(c(x), label="c")

# # begin
# # 	c(x) = 2
# # 	d(x) = 2x
# # 	f(x) = x^2
# # 	g(x) = x/(x-1)
# # 	g′ = diff(g(x))
# # 	g′′ = diff(g′(x))
# # 	p(x) = (x+2)*(x-1)*(x-3)
# # 	r(x) = 1/(x+3)
# # 	r1(x) = 1/(x-2)+1
# # 	s(x) = sqrt(x)
# # 	sdomain = "[0, ∞)"
# # 	q(x) = (x-1.5)*(x-2.3)
# # 	l(x) = log(x)
# # 	ldomain = "(0, ∞)"
# #   t(x) = sin(x)
# # end
# # End Test ###################################################



# """
# 	signcharts(f(x); labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

# xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits

# Generate stacked sign charts for the given function and its first and second derivative. 
# """
# function signcharts_fix(f; labels="y",  domain = "(-∞, ∞)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)
# 	labels = [labels, labels*"′", labels*"′′"]

# 	f′ = diff(f(x))
# 	f′′ = diff(f′(x))
	
	
# 	if f′.is_constant()
# 		f′ = convert(Real, f′)
# 		f′′ = 0.0
# 	elseif f′′.is_constant()
# 		f′′ = convert(Real, f′′)
# 	end

# 	crpts_f = criticalpoints(f)
# 	crpts_f′ = criticalpoints(f′)
# 	crpts_f′′ = criticalpoints(f′′)
# 	println(crpts_f)
# 	println(crpts_f′)
# 	println(crpts_f′′)

# 	crpts_f = append!(crpts_f[1], crpts_f[2])
# 	crpts_f′ = append!(crpts_f′[1], crpts_f′[2])
# 	crpts_f′′ = append!(crpts_f′′[1], crpts_f′′[2])
# 	convert.(Float64, crpts_f)
# 	convert.(Float64, crpts_f′)
# 	convert.(Float64, crpts_f′′)
# 	println(crpts_f)
# 	println(crpts_f′)
# 	println(crpts_f′′)

# 	crpt = sort(append!(crpts_f, crpts_f′, crpts_f′′))
# # println("getsigns -> crpt: $crpt")	
# 	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# # println("getsigns -> crpt -> N: $crpt")	
	
# 	# Get the limits of the x values
# 	testpts_f = test_pt_fix(domain, crpts_f; xrange = xrange)
# 	testpts_f′ = test_pt_fix(domain, crpts_f′; xrange = xrange)
# 	testpts_f′′ = test_pt_fix(domain, crpts_f′′; xrange = xrange)
	
# 	# f_sc = signchart_fix(f; label = labels[1], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
# 	# fp_sc = signchart_fix(f′; label = labels[2], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
# 	# fpp_sc = signchart_fix(f′′; label = labels[3], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)

# 	# Plots.plot(f_sc, fp_sc, fpp_sc, layout = (3,1))
# 	testpts_f, testpts_f′, testpts_f′′
# end

# # plot_function_sign_chart(p(x), (-4, 5))
# # Test ###################################################
# signcharts_fix(p(x))
# # signcharts(p(x), xrange = (-4, 5))
# # signchart(q(x); label="q")
# # signcharts(l(x), domain = ldomain)

# # f(x) = (x+2)*(x+1)*(x-2)

# # d(x) = 2x
# # d(x) = x^2
# # d′ = diff(d(x))
# # d′′ = diff(d′(x))
# # typeof(d′′)
# # d′′ = convert(Real, d′′)
# # criticalpoints(d′′)
# # getsigns(d′′, criticalpoints(d′′))
# # signcharts(d(x))

# # signcharts(s(x), domain = "[0,oo)", xrange = (-.25, 2))
# # signcharts(p(x), domain = "(-oo,oo)")
# # signcharts(g(x))

# begin
# 	c(x) = 2
# 	d(x) = 2x
# 	f(x) = x^2
# 	g(x) = x/(x-1)
# 	g′ = diff(g(x))
# 	g′′ = diff(g′(x))
# 	p(x) = (x+2)*(x-1)*(x-3)
# 	r(x) = 1/(x+3)
# 	r1(x) = 1/(x-2)+1
# 	s(x) = sqrt(x)
# 	sdomain = "[0, ∞)"
# 	q(x) = (x-1.5)*(x-2.3)
# 	l(x) = log(x)
# 	ldomain = "(0, ∞)"
#   t(x) = sin(x)
# end
# # End Test ###################################################










# function test_pt_aux_fix(domain, crpt; xrange = missing)
# 	test_pt = Real[]
	
# 	_, left_value, right_value, _ = domain_from_str(domain) # Replaced left_symbol, right_symbol with _.
# 	# if !ismissing(xrange)
# 	# 	if 

# 	if length(crpt) == 0
# 		if left_value == -∞ && right_value == ∞
# 			push!(test_pt, 0)
# 		elseif left_value == -∞
# 			push!(test_pt, right_value - 1)
# 		elseif right_value == ∞	
# 			push!(test_pt, left_value + 1)
# 		else
# 			push!(test_pt, mean([left_value, right_value]))
# 		end
# 	elseif length(crpt) == 1
# 		if left_value < crpt[1]
# 			if left_value == -∞
# 				push!(test_pt, crpt[1] - 1)
# 			else
# 				push!(test_pt, mean([left_value, crpt[1]]))
# 			end
# 			if right_value > crpt[1]
# 				if right_value == ∞
# 					push!(test_pt, crpt[1] + 1)
# 				else
# 					push!(test_pt, mean([right_value, crpt[1]]))
# 				end
# 			end
# 		elseif right_value > crpt[1]
# 			if right_value == ∞
# 				push!(test_pt, crpt[1] + 1)
# 			else
# 				push!(test_pt, mean([right_value, crpt[1]]))
# 			end
# 		end
# 	else
# 		d_avg = 0
# 		for i in 1:length(crpt)-1
# 			d_avg += crpt[i+1] - crpt[i]
# 		end
# 		d_avg = ceil(d_avg/(length(crpt) - 1))

# 		offset_index = 0
# 		if left_value < crpt[1]
# 			if !ismissing(xrange) && xrange[1] < crpt[1]
# 				temp = ceil(mean([xrange[1], crpt[1]]))
# 				temp = temp < .25 ? temp -= .5 : temp
# 				push!(test_pt, temp)
# 				offset_index = 1
# 			else
# 				push!(test_pt, mean([crpt[1] - d_avg, crpt[1]]))
# 				offset_index = 1
# 			end
# 		end

# 		for i in 2:length(crpt)
# 			if left_value < crpt[i]
# 				push!(test_pt,mean([crpt[i-1], crpt[i]]))
# 			end
# 		end
		
# 		if crpt[end] < right_value
# 			if !ismissing(xrange) && crpt[end] < xrange[2]
# 				temp = ceil(mean([xrange[2], crpt[end]]))
# 				temp = temp < .25 ? temp += .5 : temp
# 				push!(test_pt, temp)
# 			else
# 				push!(test_pt, mean([crpt[end] + d_avg, crpt[end]]))
# 			end
# 		end
		
# 	end
	
# 	test_pt
# end

# """
# 	function getsigns(f, crpt::Vector{T}; domain = "(-∞, ∞)") where {T <: Real}

# crpt: vector of numbers\n
# domian: the domain of the function if it's not all real numbers. Note you cannot use the unicode infinity symbol "∞" here but must use "oo". (Hope to resolve this. Note it's confusing the substring slice str[2:end-1] in the `domain_from_str` function.)\n
# Find the signs of the test values and their signs.

# Returns a pair of vectors: vector of test points and a vector of strings.

# Example \n
# For ``p(x) = (x+2)(x-1)(x-3)``

# p(x) = (x+2)*(x-1)*(x-3)
# getsigns(p, [-1, 1, 3])

# returns
# ([-2.0, 0.0, 2.0, 4.0], ["-", "+", "-", "+"])
# """
# function test_pt_fix(crpt::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
# 	sort!(crpt)
# 	test_pt_aux_fix(domain, crpt; xrange)
# end

# """
# 	function getsigns(f, crpt::Tuple{Vector{Any}, Vector{Any}}; domain = "(-∞, ∞)")

# crpt: vector of numbers
# Find the signs of the test values and their signs.

# Returns a pair of vectors: vector of test points and a vector of strings.
# """
# function test_pt_fix(crpt::NamedTuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Any, Sym}}
# 	crpt = sort(append!(crpt[1], crpt[2]))
# # println("getsigns -> crpt: $crpt")	
# 	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# # println("getsigns -> crpt -> N: $crpt")	
# 	crpt = convert.(Float64, crpt)
	
# 	test_pt_aux_fix(domain, crpt; xrange)
# end

# # Test ###################################################
# # getsigns(p)

# # pp_crpt[1]
# # pp_crpt[2]
# # ncrpt = N(pp_crpt)
# # [real(z) for z in ncrpt]
# # pp_crpt

# # begin
# # 	c(x) = 2
# # 	d(x) = 2x
# # 	f(x) = x^2
# # 	g(x) = x/(x-1)
# # 	g′ = diff(g(x))
# # 	g′′ = diff(g′(x))
# # 	p(x) = (x+2)*(x-1)*(x-3)
# # 	r(x) = 1/(x+3)
# # 	r1(x) = 1/(x-2)+1
# # 	s(x) = sqrt(x)
# # 	sdomain = "[0, ∞)"
# # 	q(x) = (x-1.5)*(x-2.3)
# # 	l(x) = log(x)
# # 	ldomain = "(0, ∞)"
# #   t(x) = sin(x)
# # end
# # End Test ###################################################

# """
# 	function getsigns(f, crpt::Tuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)") where {S,T <: Union{Real, Sym}}

# crpt: pair of vectors can be from the `criticalpoints` function.
# Find the signs of the test values and their signs.

# Returns a pair of vectors: vector of test points and a vector of strings.


# """
# function test_pt_fix(crpt::NamedTuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Real, Sym}}
# 	crpt = sort(append!(crpt[1], crpt[2]))
# # println("getsigns -> crpt: $crpt")	
# 	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
# # println("getsigns -> crpt -> N: $crpt")	
# 	convert.(Float64, crpt)

# 	test_pt_aux_fix(domain, crpt; xrange)
# end


# # function test_pt_fix(a::T; domain = "(-∞, ∞)") where {T <: Real}
# # 	_, left_value, right_value, _ = domain_from_str(domain)
# # 	if left_value == -∞ && right_value == ∞
# # 		[0]
# # 	elseif left_value == -∞
# # 		[right_value - 1]
# # 	elseif right_value == ∞
# # 		[left_value + 1]
# # 	else
# # 		[mean(left_value, right_value)]
# # 	end
# # end








# ###########################################################################################################################################
# function plot_function_sign_chart_fix(f, arguments; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 1000), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, xrange = missing, yrange = missing, xsteps = .01, stacked::Bool=true, heights=[0.7 ,0.1, 0.1, 0.1])
# 	# Need to change xrange to "arguments" and add a xrange parameter, then if xrange = missing pass "arguments" to signchart as their xrange
# 	labels = [labels, labels*"′", labels*"′′"]

# 	if ismissing(xrange)
# 		xrange = arguments
# 	end
# 	s = signchart_fix(f(x); label=labels[1], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)

# 	f′ = diff(f(x))
# 	if f′.is_constant()
# 		s′ = signchart_fix(f′; label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
# 	else
# 		s′ = signchart_fix(f′(x); label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
# 	end

# 	f′′ = diff(f′(x))
# 	if f′′.is_constant()
# 		s′′ = signchart_fix(f′′; label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
# 	else
# 		s′′ = signchart_fix(f′′(x); label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
# 	end

# 	p = functionplot(f(x), arguments; label = "", horiz_ticks = horiz_ticks, vert_ticks = vert_ticks, yrange = yrange, xsteps = xsteps, size = size, imageFormat = imageFormat)

# 	if stacked
# 		lay_out = grid(4,1, heights=heights)
# 	else
# 		lay_out = @layout[
# 			a{0.5w} grid(3,1)
# 		]
# 	end
# 	Plots.plot(p, s, s′, s′′, layout = lay_out, size=size)
# end