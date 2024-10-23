# Corrections needed
# limittable: check if a table value is at a discontinuity and add a domain parameter

using PrettyTables
using SpecialFunctions
# using Formatting
using Format
using Statistics
using DataFrames
using Plots
using Printf
using SymPy
using PyCall
using LaTeXStrings
# using PlotlyJS



begin
	x = Sym("x")
	y = symbols("y", real = true) #Need for f = abs
	# x = symbols("x", real = true)
	h = Sym("h")
	C = Sym("C")
	# x = symbols('x')
	# h = symbols("h")
	# C = symbols("C")
	∞ = oo
end

###############################################################################################################################
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
import Base: diff

"""
diff(f::Function)

Extends SymPy's diff function to accept type Function in addtition to type Sym
"""
function diff(f::Function)
	diff(f(x))
end

"""
diff(a::Real)

Extends SymPy's diff function to accept constants and return the constant function y = 0
"""
function diff(a::Real)
	x -> 0
end

###############################################################################################################################
function dashhtmltable(header, Xr, Yr, Xl, Yl, format)
	n = length(Xr)
	return html_table([
		html_thead(
			html_tr([
					html_th(col, style = Dict("border"=>"1px solid black")) for col in header
				])
			),
		html_tbody([
			html_tr([
					html_td(Printf.format(Printf.Format(format), Xl[i]), style = Dict("border"=>"1px solid black", "background-color"=> "#0390fc", "text-align" => "right")), 
					html_td(
						if isinf(Yl[i]) "∞" else Printf.format(Printf.Format(format), Yl[i]) end, 
						style = Dict("border"=>"1px solid black", "background-color"=> "#0390fc", "text-align" => "right")),
					html_td(Printf.format(Printf.Format(format), Xr[i]), style = Dict("border"=>"1px solid black", "background-color"=> "#fc0303", "text-align" => "right")), 
					html_td(
						if isinf(Yl[i]) "∞" else Printf.format(Printf.Format(format), Yr[i]) end, 
						style = Dict("border"=>"1px solid black", "background-color"=> "#fc0303", "text-align" => "right")) 
				]) for i in 1:n
		])			
	],
	style = Dict("border"=>"1px solid black")
	)
end

function dashhtmltable(header, X, Y, color, format)
	n = length(X)
	return html_table([
		html_thead(
			html_tr([
					html_th(col, style = Dict("border"=>"1px solid black")) for col in header
				])
			),
		html_tbody([
			html_tr([
					html_td(Printf.format(Printf.Format(format),X[i]), style = Dict("border"=>"1px solid black", "background-color"=> color, "text-align" => "right")), 
					html_td(
						if isinf(Y[i]) "∞" else Printf.format(Printf.Format(format), Y[i]) end, 
						style = Dict("border"=>"1px solid black", "background-color"=> color, "text-align" => "right"))
				]) for i in 1:n
		])			
	],
	style = Dict("border"=>"1px solid black")
	)
end

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
	# println("f = $f")
    if dir == "+"
        X = a .+ [10.0^(-i) for i in 1:rows-2] # broadcast: a + each elt in array
        X = vcat([a + 1, a + 0.5], X) # add rows at the top of X
        Y = [N(f.subs(x, z)) for z in X] # make array of outputs f(X)
		# hl_right = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "red"))
		
		dashhtmltable(["x → $(a)⁺", "y"], X, Y, "#fc0303", format)
    elseif dir == "-"
        X = a .- [10.0^(-i) for i in 1:rows-2]
        X = vcat([a - 1, a - 0.5], X)
        Y = [N(f.subs(x, z)) for z in X]
		# hl_left = HtmlHighlighter((data, i, j) -> (j == 2) , HtmlDecoration(color = "#0041C2"))
    	
		dashhtmltable(["x → $(a)⁻", "y"], X, Y, "#0390fc", format)
    else 
        Xr = a .+ [10.0^(-i) for i in 1:rows-2]
        Xr = vcat([a + 1, a + 0.5], Xr)
        Yr = [N(f.subs(x, z)) for z in Xr]
        Xl = a .- [10.0^(-i) for i in 1:rows-2]
        Xl = vcat([a - 1, a - 0.5], Xl)
        Yl = [N(f.subs(x, z)) for z in Xl]
		

		dashhtmltable(["x → $(a)⁻", "y", "x → $(a)⁺", "y"], Xr, Yr, Xl, Yl, format)
    end
end

"""
    limittable(f, a::Sym; rows::Int=5, format="%10.2f")

a: is either oo (meaning ∞) or -oo (meaning -∞)\n
rows: number of rows to compute (default is 5 rows)\n
format: a string that specifies c-style printf format for numbers (default is %10.2f)
"""
function limittable(f, a::Sym; rows::Int=5, format="%10.2f") # for infinite x->oo/-oo
    if a == oo
        X = [10.0^(i+1) for i in 1:rows]
        Y = [N(f(z)) for z in X]
		
		dashhtmltable(["x → ∞", "y"], X, Y, "#fc0303", format)
    elseif a == -oo
        X = [-1*10.0^(i+1) for i in 1:rows]
        Y = [N(f(z)) for z in X]
		
		dashhtmltable(["x → -∞", "y"], X, Y, "#0390fc", format)
    end

end

"""
    lim(f(x), var, c; dir = "")

``\\lim_{x \\to c} f(x) = L``\n
var: the variable\n
c: the value to approach including -∞ (-oo) and ∞ (oo)\n
dir: a string indicating which side to take the limit from. Default is "" which takes the two sided limit, "+" takes the limit from the right, "-" takes the limit from the left
"""
function lim(f, var, c; dir = "")
	# lhl = limit(f(x), var => c, dir="-")
    # rhl = limit(f(x), var => c, dir="+")
	lhl = limit(f, var => c, dir="-")
    rhl = limit(f, var => c, dir="+")
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

###############################################################################################################################
"""
    criticalpoints(f(x))

Find the critical points of the function f(x).

Returns a pair of vectors with the first vector the values that make ``f(x) = 0`` and the second vector the values that make ``f(x)`` undefined.
"""
function criticalpoints(f)
	# println("Calling criticalpoints")
	# println("f = $f")
	# Need to fix for abs(x)
	zeros = Real[]
	undefined = Real[]

	# println("f = ?, f = $f")
	if f == abs(x)
		f = abs(y)
	end
	# crpt_num = solve(f(x))
	# crpt_den = solve(simplify(1/f(x)))

	crpt_num = solve(f, check=false)
	# println("crpt_num: $crpt_num")
	
	# crpt_den = solve(simplify(1/f), check=false) #without simplify results in failure
	crpt_den = solve(1/f, check=false) 
	filter!(e->e!="zoo", crpt_den)
	# println("crpt_den: $crpt_den")
	
	# println("crpt_num = $crpt_num; crpt_den: $crpt_den")
	crpt_hole = intersect(crpt_num, crpt_den)
	crpt_num = setdiff(crpt_num, crpt_hole)

	# println("crpt_num = $crpt_num, crpt_den = $crpt_den, crpt_hole = $crpt_hole")

	# for z in N.(crpt_num)
	# 	println("z = $z, real(z) = $(real(z))")
	# end
	# crpt_num = [real(z) for z in N.(crpt_num)] # Get rid of complex (looking) solutions
	crpt_num = [real(N(x)) for x in crpt_num if isreal(x)]
	# println("crpt_num = $crpt_num")
	filter!(e->!isa(e, Bool),crpt_num) # Was getting booleans and this removes them
	# crpt_den = [real(z) for z in N.(crpt_den) if imag(z) == 0] # Get rid of complex (looking) solutions. Added if statement since some complex were comverting to 0.0 and sneaking through
	crpt_den = [real(N(x)) for x in crpt_den if isreal(x)]
	# println("crpt_den = $crpt_den\n")
	filter!(e->!isa(e, Bool),crpt_den)
	crpt_hole = [real(N(x)) for x in crpt_hole if isreal(x)]
	filter!(e->!isa(e, Bool),crpt_hole)

	# to make sure zeros and undefined remain type Real:
	for x in crpt_num
		append!(zeros, x)
	end
	for x in crpt_den
		append!(undefined, x)
	end

	# println("crpt_hole = $crpt_hole")

	(zeros = zeros, undefined = undefined, holes = crpt_hole)
end

"""
    criticalpoints(a::T) where {T <: Real}

Find the critical points for the constant function f(x).

Returns the pair of vectors ([], []).
"""
function criticalpoints(a::T) where {T <: Real}
	(zeros = Real[], undefined = Real[], holes = Real[])
end

# criticalpoints(c(x))
# criticalpoints(c) #Has ERROR
# criticalpoints(2)

###############################################################################################################################
"""
    getsign(f, val)

Find the sign of the function `f` at the value `val`.

Returns a pair of vectors with the first vector the values that make ``f(x) = 0`` and the second vector the values that make ``f(x)`` undefined.
"""
function getsign(f, val) # get sign of single value for f
    temp_val = f.subs(x, val)
	if sympy.im(temp_val) == 0
		temp_val > 0 ? "+" : "-"
	else
		"undef"
	end
end

###############################################################################################################################
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

###############################################################################################################################
function convert_to_interval(domain::String)
    pattern = r"\s*(\[|\()\s*(-?[\p{Any}|\d]*)\s*,\s*(-?[\p{Any}|\d]*)\s*(\]|\))\s*"
    re_matched = match(pattern, domain)
	# println("re_matched[1] = $(re_matched[1]), re_matched[2] = $(re_matched[2]), re_matched[3] = $(re_matched[3]), re_matched[4] = $(re_matched[4])")
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

###############################################################################################################################
function getsigns_aux(f, domain, crpt; xrange = missing)
	#Can I pull out the test_pt calculations into their own function to also be used in the signcharts function to set xrange so they line up?
	# println("CAlled me!, domain = $domain, crpt = $crpt, xrange = $xrange")
	signs = String[]
	test_pt = Real[]
	
	_, left_domain_value, right_domain_value, _ = domain_from_str(domain) # Replaced left_symbol, right_symbol with _.

	if length(crpt) == 0
		if left_domain_value == -∞ && right_domain_value == ∞
			push!(test_pt, 0)
			push!(signs, getsign(f, test_pt[1]))
		elseif left_domain_value == -∞
			push!(test_pt, right_domain_value - 1)
			push!(signs, getsign(f, test_pt[1]))
		elseif right_domain_value == ∞	
			push!(test_pt, left_domain_value + 1)
			push!(signs, getsign(f, test_pt[1]))
		else
			push!(test_pt, mean([left_domain_value, right_domain_value]))
			push!(signs, getsign(f, test_pt[1]))
		end
	elseif length(crpt) == 1
		if (left_domain_value == -oo) || (left_domain_value < crpt[1])
			if left_domain_value == -∞
				push!(test_pt, crpt[1] - 1)
				push!(signs, getsign(f, test_pt[1]))
			else
				push!(test_pt, mean([left_domain_value, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
			end
			if (right_domain_value == oo) || (right_domain_value > crpt[1])
				if right_domain_value == ∞
					push!(test_pt, crpt[1] + 1)
					push!(signs, getsign(f, test_pt[2]))
				else
					push!(test_pt, mean([right_domain_value, crpt[1]]))
					push!(signs, getsign(f, test_pt[2]))
				end
			end
		elseif (right_domain_value == oo) || (right_domain_value > crpt[1])
			if right_domain_value == ∞
				push!(test_pt, crpt[1] + 1)
				push!(signs, getsign(f, test_pt[1]))
			else
				push!(test_pt, mean([right_domain_value, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
			end
		end
	else
		crpt_distance_average = 0
		for i in 1:length(crpt)-1
			crpt_distance_average += crpt[i+1] - crpt[i]
		end
		crpt_distance_average = ceil(crpt_distance_average/(length(crpt) - 1))

		offset_index = 0
		if (left_domain_value == -oo) || (left_domain_value < crpt[1])
			if !ismissing(xrange) && xrange[1] < crpt[1]
				temp = ceil(mean([xrange[1], crpt[1]]))
				temp = temp < .25 ? temp -= .5 : temp
				push!(test_pt, temp)
				push!(signs, getsign(f, test_pt[1]))
				offset_index = 1
			else
				push!(test_pt, mean([crpt[1] - crpt_distance_average, crpt[1]]))
				push!(signs, getsign(f, test_pt[1]))
				offset_index = 1
			end
		end

		for i in 2:length(crpt)
			if (left_domain_value == -oo) || (left_domain_value < crpt[i])
				push!(test_pt,mean([crpt[i-1], crpt[i]]))
				push!(signs, getsign(f, test_pt[i-1+offset_index]))
			end
		end
		
		if (right_domain_value == oo) || (crpt[end] < right_domain_value)
			if !ismissing(xrange) && crpt[end] < xrange[2]
				temp = ceil(mean([xrange[2], crpt[end]]))
				temp = temp < .25 ? temp += .5 : temp
				push!(test_pt, temp)
				push!(signs, getsign(f, last(test_pt)))
			else
				push!(test_pt, mean([crpt[end] + crpt_distance_average, crpt[end]]))
				push!(signs, getsign(f, last(test_pt)))
			end
		end
		
	end
	
	test_pt, signs
end

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
	# println("""getsigns(f, crpt::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}""")
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
	# println("""getsigns(f, crpt::Tuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Any, Sym}}""")
	crpt = sort(append!(crpt[1], crpt[2]))
	crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions	
	crpt = convert.(Float64, crpt)
	
	getsigns_aux(f, domain, crpt; xrange)
end

function getsigns(f, crpt::NamedTuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Real, Sym}}
	# println("""getsigns(f, crpt::NamedTuple{Vector{S}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {S,T <: Union{Real, Sym}}""")
	getsigns(f, (crpt.zeros, crpt.undefined); domain, xrange)
end

"""
	function getsigns(a::T) where {T <: Real}
	
a: any real value
Find the signs of the test value and their sign if a ≠ 0.

Returns a pair of vectors: vector of the test point and a vector of the string.
"""
function getsigns(a::T; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
	# println("getsigns(a::T) where {T <: Real}")
	if a > 0
		[0], ["+"]
	elseif a < 0
		[0], ["-"]
	else
		[0], [""]
	end
end

"""
	function getsigns(a::T, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
	
a: any real value
Find the signs of the test value and their sign if a ≠ 0.

Returns a pair of vectors: vector of the test point and a vector of the string.
"""
function getsigns(a::T, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
	# println("getsigns(a::T) where {T <: Real}")
	if a > 0
		[0], ["+"]
	elseif a < 0
		[0], ["-"]
	else
		[0], [""]
	end
end

"""
	getsigns(f, zeros::Vector{T}, undefined::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}

e.g.
getsigns(g, criticalpoints(g(x))..., domain="(.1, ∞)")
NOTE the splat after criticalpoints(g(x))...
"""
function getsigns(f, zeros::Vector{T}, undefined::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}
	# println("""getsigns(f, zeros::Vector{T}, undefined::Vector{T}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}""")
	crpt = vcat(zeros, undefined)
	sort!(crpt)
	getsigns_aux(f, domain, crpt; xrange)
end

"""
getsigns(f::T, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Union{Function, Sym}}

EXPERIMENTAL function
"""
function getsigns(f::T, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Union{Function, Sym}}
# function getsigns(f, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing)
# function getsigns(f::T, crpt::@NamedTuple{zeros::Vector{Real}, undefined::Vector{Real}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Union{Function, Sym{PyObject}}}
	# println("""getsigns(f::Sym{PyObject}, crpt::NamedTuple{Vector{T}, Vector{T}}; domain = "(-∞, ∞)", xrange = missing) where {T <: Real}""")
	getsigns(f, (crpt.zeros, crpt.undefined); domain, xrange)
end

###############################################################################################################################
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
	
	# println("signcharts: f = $a, typeof: $(typeof(a))")

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
	test_pts = [mean([xrange[1], xrange[2]])]
	if a ≠ 0
		signs = a > 0 ? ["+"] : ["-"]
	else
		signs = [""]
	end
    
    gr()
	p = Plots.plot(test_pts, 0, yaxis = false, legend = false, framestyle = :grid, fmt = imageFormat, ticks = :none)
	p = plot!(title = label, titleloc = :left, tickfonthalign = :left)
    p = yticks!([0],[""])
    p = plot!(size=size)
    p = plot!(ylims=(-.05,.6))
	p = plot!(xlims=(xrange[1], xrange[2]))
	p = annotate!([(test_pts[i], .5, text(signs[i], :center, 30)) for i in eachindex(test_pts)])
    
    p
end

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
	
	# println("signchart: f = $f, typeof: $(typeof(f)), label = $label")

	# if f(x).is_number
	if f.is_number
		a = convert(Real, f)
		p = signchart(a; label=label, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		crpt_num, crpt_den, crpt_hole = criticalpoints(f) #get the critical pts
		crpt = sort(vcat(crpt_num, crpt_den)) #put them into a list and sort
		crpt = [real(z) for z in N.(crpt)] # Get rid of complex (looking) solutions
		crpt = convert.(Float64, crpt) #convert to floats
		# println("crpt = $crpt")

		#If there are no crpts just plot the sign of the function at 0
		if length(crpt) == 0
			test_pts = [0] # rename test_pts?
			# signs = f(0) > 0 ? "+" : "-"
			signs = f.subs(x, 0) > 0 ? "+" : "-"
		#else get the midpts between crpts and the sign there
		else
			test_pts, signs = getsigns(f, crpt, domain = domain, xrange = xrange)
		end
		# println("test_pts = $test_pts, signs = $signs")

		y = zeros(length(test_pts)) #make array of zeros of length of test_pts
		gr()
		p = Plots.plot(test_pts, y, yaxis = false, label = label, legend = false, framestyle = :grid, fmt = imageFormat, title = label, titleloc = :left, tickfonthalign = :left)
		# p = yaxis!(label, yguidefontsize=18)
		p = yticks!([0],[""])
		p = plot!(size=size)
		p = plot!(ylims=(-.05,.6))
		if ismissing(xrange)
			p = plot!(xlims=(test_pts[1]-(1+horiz_jog), test_pts[end]+1))
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
		# p = annotate!([(test_pts[i], .5, text(signs[i], :center, 30)) for i in 1:length(test_pts)])
		p = annotate!([(test_pts[i], .5, text(signs[i], :center, 30)) for i in eachindex(test_pts)])
		p = vline!(crpt, line = :dash, linecolor = :red)
		if !isempty(crpt_num)
			p = Plots.plot!(crpt_num, zeros(length(crpt_num)) .+ dotverticaljog, seriestype = :scatter, markercolor = :black, markersize = marksize) #closed dots?
		end
		if !isempty(crpt_den)
			p = Plots.plot!(crpt_den, zeros(length(crpt_den)) .+ dotverticaljog, seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
		end
	end
    p
end

"""
	signcharts(f(x); labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)

xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits

Generate stacked sign charts for the given function and its first and second derivative. 
"""
function signcharts(f; labels="y",  domain = "(-∞, ∞)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)
	labels = [labels, labels*"′", labels*"′′"]

	# println("signcharts: f = $f, typeof: $(typeof(f)), sympy.srepr(f): $(typeof(sympy.srepr(f)))")
	# println("signcharts: typeof(sympy.parse_expr(exp)): $(typeof(sympy.parse_expr("exp")))")
	# if sympy.srepr(f) == sympy.srepr(sympy.parse_expr("exp(x)"))
	# f′ = diff(f(x))
	# f′′ = diff(f′(x))
	f′ = diff(f)
	f′′ = diff(f′)
	# f′ = diff(f, x)
	# f′′ = diff(f′, x)
	# println("f = $(f), typeof: $(typeof(f))")
	# println("f′ = $(f′), typeof: $(typeof(f′))")
	# println("f′′ = $(f′′), typeof: $(typeof(f′′))")
		
	f′_is_constant = isa(f′.is_constant(), Sym{Nothing}) ? false : f′.is_constant() # had to catch the None boolean type from sympy
	# if N(f′.is_constant())
	if N(f′_is_constant)
		f′ = convert(Real, f′)
		f′′ = 0.0
	elseif N(f′′.is_constant())
		# f′′ = convert(Real, f′′)
		f′′ = convert(Real, simplify(f′′)) # had to simplify the expression to convert it
	end
	
	f_sc = signchart(f; label = labels[1], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	# println("Made f_sc")
	fp_sc = signchart(f′; label = labels[2], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	# println("Made fp_sc")
	fpp_sc = signchart(f′′; label = labels[3], domain = domain, horiz_jog = horiz_jog, size = size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange=xrange)
	# println("Made fpp_sc")

	Plots.plot(f_sc, fp_sc, fpp_sc, layout = (3,1))
end

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
"""
	functionplot(f, xrange; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)

Required:\n
f(x): the function to be ploted
xrange: a pair giving the ``x`` limits of the plot\n
Optional:\n
label: a string usually the name of the function\n
domain: an interval whritten as a string, e.g. "(-∞, 10]". It overrides xrange.\n
horiz_ticks: a range giving the horizontal ticks to be displayed\n
vert_ticks: a range giving the horizontal ticks to be displayed\n
yrange: a pair giving the ``y`` limits of the plot\n
xsteps: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`). Defaults to 0.01.\n
size: size of the graph as an ordered pair. Defaults to (1000, 500)\n
imageFormat: Only :svg and :png have any effect for now. Choices are :pdf, :png, :ps, :svg.\n
tickfontsize: \n
marksize: \n
"""
function functionplot(f, xrange; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)
    #imageFormat can be :svg, :png, ... MAKE save image option for pdf and ps?
	# Need to check if any holes coincide with the ends of the domain and adjust graph if necessary e.g. hole at x = 2 and domain = [2, 5] needs open dot
	# Having problems when hole and domain endpoint coinciding.

	# println("f=$f")
	crpt_num, crpt_denom, crpt_hole = criticalpoints(f)
	# println("crpt_num=$crpt_num, crpt_denom=$crpt_denom, crpt_hole=$crpt_hole")
	asymptote_vert = setdiff(crpt_denom, crpt_hole)

    #p = plot(values, f, legend = :outertopright, framestyle = :origin, xticks=horiz_ticks, fmt = imageFormat)
	interval = convert_to_interval(domain)
	# if xrange is bigger than the domain reset to the size of the domain
	xrange_left, xrange_right = xrange
	
	#Have the xrange agree with the domain when the domain is smaller
	xrange_left = xrange[1] < interval.left ? interval.left : xrange[1]
	xrange_right = interval.right < xrange[2] ? interval.right : xrange[2]
	xrange = (xrange_left, xrange_right)
	
	# Set the values to evaluate the function at.
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
    # asymptote_vert = solve(simplify(1/f))
	# filter!(e->isa(e, Real),asymptote_vert) # Was getting complex values and this removes them
    if length(asymptote_vert) != 0
        p = vline!(asymptote_vert, line = :dash)
    end
    #Determine if function goes to infinity on the left and right
	lf_lim = lim(f, x, -oo)
    if ismissing(lf_lim) || (lf_lim == -oo || lf_lim == oo || lf_lim == -oo*1im || lf_lim == oo*1im) # why did I need oo*1im?
        lf_infty_bool = true
    else
        lf_infty_bool = false
    end
	rt_lim = lim(f, x, oo)
    if ismissing(rt_lim) || (rt_lim == -oo || rt_lim == oo || rt_lim == -oo*1im || rt_lim == oo*1im)
        rt_infty_bool = true
    else
        rt_infty_bool = false
    end
	
    if !lf_infty_bool && !rt_infty_bool
		# Draw horizontal asymptote
        if lf_lim == rt_lim && lf_lim.is_number && rt_lim.is_number
            p = hline!([lf_lim], line = :dash)
        else
			if lf_lim.is_number
            	p = hline!([lf_lim], line = :dash)
			elseif rt_lim.is_number
            	p = hline!([rt_lim],  line = :dash)
			end
        end
    elseif !lf_infty_bool && lf_lim.is_number
        p = hline!([lf_lim], line = :dash)
    elseif !rt_infty_bool && rt_lim.is_number
        p = hline!([rt_lim],  line = :dash)
    end
	
	#Draw any holes that exists
	if !isempty(crpt_hole)
		# println("I see holes")
		y_holes = []
		for c in crpt_hole
			if xrange[1] < c < xrange[2]
				push!(y_holes, lim(f, x, c))
			end
		end
		p = Plots.plot!(crpt_hole, y_holes, seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
	end

	# if either end of the domain is finite ifnd the end point and plot it.
	left_endpoint_value = missing
	right_endpoint_value = missing
	if interval.left != -∞
		left_endpoint_value = f(interval.left)
	end
	if interval.right != ∞
		right_endpoint_value = f(interval.right)
	end
	if typeof(interval) == OpenOpenInterval
		# println("OpenOpenInterval")
		if !ismissing(left_endpoint_value)
			p = Plots.plot!([interval.left], [left_endpoint_value], seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
		end
		if !ismissing(right_endpoint_value)
			p = Plots.plot!([interval.right], [right_endpoint_value], seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
		end
	elseif typeof(interval) == OpenClosedInterval
		# println("OpenClosedInterval")
		if !ismissing(left_endpoint_value)
			p = Plots.plot!([interval.left], [left_endpoint_value], seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
		end
		if !ismissing(right_endpoint_value)
			p = Plots.plot!([interval.right], [right_endpoint_value], seriestype = :scatter, markercolor = :black, markersize = marksize) #closed dots?
		end
	elseif typeof(interval) == ClosedOpenInterval
		# println("ClosedOpenInterval")
		if !ismissing(left_endpoint_value)
			p = Plots.plot!([interval.left], [left_endpoint_value], seriestype = :scatter, markercolor = :black, markersize = marksize) #closed dots?
		end
		if !ismissing(right_endpoint_value)
			p = Plots.plot!([interval.right], [right_endpoint_value], seriestype = :scatter, markercolor = :white, markersize = marksize) # open dots
		end
	else
		# println("ClosedClosedInterval")
		if !ismissing(left_endpoint_value)
			p = Plots.plot!([interval.left], [left_endpoint_value], seriestype = :scatter, markercolor = :black, markersize = marksize) #closed dots?
		end
		if !ismissing(right_endpoint_value)
			p = Plots.plot!([interval.right], [right_endpoint_value], seriestype = :scatter, markercolor = :black, markersize = marksize) #closed dots?
		end
	end

    p
end

###############################################################################################################################
"""
	plot_function_sign_chart(f, xrange; labels=["f", "f′", "f′′"], domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01)

xrange: a pair giving the ``x`` limits of the plot\n
horiz_ticks: a range giving the horizontal ticks to be displayed\n
vert_ticks: a range giving the horizontal ticks to be displayed\n
yrange: a pair giving the ``y`` limits of the plot\n
xsteps: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`) (default .01)

Plots the function over the sign charts for the function, then its first derivative, and finally its second derivative.
"""
function plot_function_sign_chart(f, xrange; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(1000, 1000), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, stacked::Bool=true, heights=[0.7 ,0.1, 0.1, 0.1])
	# Need to change xrange to "arguments" and add a xrange parameter, then if xrange = missing pass "arguments" to signchart as their xrange ??Why??? I think letting domain take over control of the width of the graph will do whatever I was thinking arguments would do
	labels = [labels, labels*"′", labels*"′′"]

	# if ismissing(xrange)
	# 	xrange = arguments
	# end
	s = signchart(f(x); label=labels[1], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)

	f′ = diff(f(x))
	if N(f′.is_constant())
		s′ = signchart(f′; label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		s′ = signchart(f′(x); label=labels[2], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	end

	f′′ = diff(f′(x))
	if N(f′′.is_constant())
		s′′ = signchart(f′′; label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	else
		s′′ = signchart(f′′(x); label=labels[3], domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	end

	p = functionplot(f(x), xrange; label = "", domain = domain, horiz_ticks = horiz_ticks, vert_ticks = vert_ticks, yrange = yrange, xsteps = xsteps, size = size, imageFormat = imageFormat, marksize = marksize)

	if stacked
		lay_out = grid(4,1, heights=heights)
	else
		lay_out = @layout[
			a{0.5w} grid(3,1)
		]
	end
	Plots.plot(p, s, s′, s′′, layout = lay_out, size=size)
end


###############################################################################################################################
"""
	extrema(f::Sym{PyObject}; domain::String = "(-∞, ∞)")

Returns a named tuple where the first element is the the local minima (named minima) and the second element is the local maxima (named maxima).
"""
function extrema(f::T; domain::String = "(-∞, ∞)")  where {T <: Union{Function, Sym}}
# function extrema(f::Function; domain::String = "(-∞, ∞)") # Until I get Sym{PyObject} types to work in Pluto have to pass functions (f) and not Sym{PyObject} (f(x))!
# function extrema(f::Sym{PyObject}; domain::String = "(-∞, ∞)") # Check if domain endpoint is an extremum. If endpoint open not an extrema.
	# Take derivatives
    # f′ = diff(f(x))
    # f′′ = diff(f′(x))
	f′ = diff(f)
    f′′ = diff(f′)

	# find critical points
	if f′.is_number
		crpt_num, crpt_den, crpt_hole = criticalpoints(f′) # added since it was missing when f′ was constant
	else
    	crpt_num, crpt_den, crpt_hole = criticalpoints(f′(x))
	end

	# use the 2nd derivative test to find max/mins
    second_derivative_at_crpt = []
    for a in crpt_num
        #push!(second_derivative_at_crpt, convert(Float32, f′′(x)))
        push!(second_derivative_at_crpt, (a,f′′.subs(x, a)))
    end

    # add endpts if they exist
    interval = convert_to_interval(domain)
    left_end, right_end = end_behavior_aux(f, interval)
    max = NTuple{2, Real}[]
    min = NTuple{2, Real}[]
    # assuming the derivative is not = 0 at the endpoints, can add code later
	# if the left endpoint is a point where f isn't undefined and also isn't -∞ and not open
	if interval.left ∉ crpt_den && interval.left ≠ -∞ && !ismissing(left_end)
		# if the slope at the left endpoint is positive then it's a min
		if f′(interval.left) > 0
			push!(min, (interval.left, left_end))
		# if it's negative then it's a max
		elseif f′(interval.left) < 0
			push!(max, (interval.left, left_end))
		# if it's 0 then need to think about what this means
		elseif f′(interval.left) == 0
			throw(DomainError(0, "extrema function: This can't handle a slope of 0 at the endpoint yet."))
		end
	end
	# for each x value and its concavity at x
    for (a, a′′) in second_derivative_at_crpt
		# if we are between the left and right endpoints of the domain
        if interval.left == -∞ || (a > interval.left && a < interval.right)
            if a′′ < 0 # if the second derivative is negative then we have a max
                push!(max, (a,f.subs(x, a)))
            elseif a′′ > 0 # if the second derivative is positive then we have a min
                push!(min, (a,f.subs(x, a)))
            end
        end
    end
	
	if interval.right ≠ ∞ && !ismissing(right_end) # if the right endpoint is finite and not open
		if f′(interval.right) < 0 # and the slope there is negative, we have a min
			push!(min, (interval.right, right_end))
		elseif f′(interval.right) > 0 # else if the slope is positive, we have a max
			push!(max, (interval.right, right_end))
		elseif f′(interval.right) == 0 # if it's 0 then need to think about what this means
			throw(DomainError(0, "This can't handle a slope of 0 at the endpoints yet."))
		end
	end
    (minima = min, maxima = max)
end

# """
# 	extrema(f::Function; domain::String = "(-∞, ∞)")

# Returns a named tuple where the first element is the the local minima (named minima) and the second element is the local maxima (named maxima).
# """
# function extrema(f::Function; domain::String = "(-∞, ∞)") # Check if domain endpoint is an extremum
# 	extrema(f(x); domain = domain)
# end

"""
	extrema(a::Real; domain::String = "(-∞, ∞)")

Returns a named tuple where the first element is the the local minima (named minima) and the second element is the local maxima (named maxima).
"""
function extrema(a::Real; domain::String = "(-∞, ∞)") # Check if domain endpoint is an extremum
	(minima = Real[], maxima = Real[])
end

###############################################################################################################################
"""
	inflection_points(f::Union{Function, Sym}; domain::String = "(-∞, ∞)")

Takes a function `f` and  optionally a domain and returns a vector of the critical points in the domain.
f: Can be entered as `f` or `f(x)`. 
domain: the domain of the function entered as a string (default "(-∞, ∞)"),\n
"""
function inflection_points(f::Union{Function, Sym}; domain::String = "(-∞, ∞)")
	infpt = []

	interval = convert_to_interval(domain)
	f′ = diff(f)
	f′′ = diff(f′)
	f′′′ = diff(f′′)
	# crpt_num, crpt_den = criticalpoints(f′′)
	crpt_num, _, _ = criticalpoints(f′′)
	crpt_num = unique(crpt_num)
# println("crpt_num = $crpt_num")
	for a in crpt_num
		if a > interval.left && a < interval.right
			if f′′′ ≠ 0
				push!(infpt, (a, f.subs(x, a)))
			end
		end
	end

    infpt
end

"""
inflection_points(a::Int; domain::String = "(-∞, ∞)")

Takes a constant `a` and  optionally a domain and returns an empty vector.
a: Is an integer.
domain: the domain of the function entered as a string (default "(-∞, ∞)"),\n
"""
function inflection_points(a::Int; domain::String = "(-∞, ∞)")
    []
end

###############################################################################################################################
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

###############################################################################################################################
begin
	function end_behavior(f, interval::OpenOpenInterval; as_string = false)
	    # left_end_val = lim(f(x), x, interval.left)
		left_end_val = lim(f, x, interval.left)
	    if interval.left == -oo
			if ismissing(left_end_val)
				left_end = "As x → -∞, " * "DNE"
			elseif left_end_val == -oo
	            left_end = "As x → -∞, " * "f(x) → -∞"
	        elseif left_end_val == oo
	            left_end = "As x → -∞, " * "f(x) → ∞"
	        else
	            left_end = "As x → -∞, " * "f(x) → $(left_end_val)"
	        end
	    else
	        left_end = "As x → $(interval.left), " * "f(x) → $(left_end_val)"
	    end
	
	    right_end_val = lim(f, x, interval.right)
	    if interval.right == oo
			if ismissing(right_end_val)
				left_end = "As x → ∞, " * "DNE"
	        elseif right_end_val == -oo
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
	function end_behavior(f, interval::OpenClosedInterval; as_string = false)
		left_end_val = lim(f, x, interval.left)
	    if interval.left == -oo
	        left_end_val = lim(f, x, -oo)
			if ismissing(left_end_val)
				left_end = "As x → -∞, " * "DNE"
	        elseif left_end_val == -oo
	            left_end = "As x → -∞, " * "f(x) → -∞"
	        elseif left_end_val == oo
	            left_end = "As x → -∞, " * "f(x) → ∞"
	        else
	            left_end = "As x → -∞, " * "f(x) → $(left_end_val)"
	        end
	    else
	        left_end = "At endpoint x = $(interval.left), " * "f($(interval.left)) = $(f(interval.left))"
	    end

		right_end_val = f.subs(x, interval.right)
	    right_end = "At right endpoint x = $(interval.right), " * "f($(interval.right)) = $(right_end_val)"
	
	    as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
	function end_behavior(f, interval::ClosedOpenInterval; as_string = false)
		left_end_val = f.subs(x, interval.left)
	    left_end = "At left endpoint x = $(interval.left), " * "f($(interval.left)) = $(left_end_val)"
		
	    right_end_val = lim(f, x, interval.right)
	    if interval.right == oo
	        if ismissing(right_end_val)
				left_end = "As x → ∞, " * "DNE"
			elseif right_end_val == -oo
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
	function end_behavior(f, interval::ClosedClosedInterval; as_string = false)
		left_end_val = f.subs(x, interval.left)
	    left_end = "At left endpoint x = $(interval.left), " * "f($(interval.left)) = $(left_end_val)"

		right_end_val = f.subs(x, interval.right)
	    right_end = "At right endpoint x = $(interval.right), " * "f($(interval.right)) = $(right_end_val)"
	
	    as_string ? (left_end, right_end) : (left_end_val, right_end_val)
	end
end

###############################################################################################################################
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
function function_summary(f::T; domain::String = "(-∞, ∞)", labels = "y", dotverticaljog=0, marksize=8, tickfontsize = 20, digits= 2, horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing) where {T <: Union{Function, Sym}}
	# println("fcn summary: f = $f")
    #Need to adjust values based on domain
	# Fix for abs(x), exp(x^2)
	
	_, _, crpt_hole = criticalpoints(f)

	if f == abs(x)
		# println("f is |x|")
		f = abs(y)
	end

    gr()
    interval = convert_to_interval(domain)
	if isa(interval, OpenOpenInterval)
		if interval.left < 0.0 < interval.right
			# println("OpenOpenInterval, $(interval.left) < 0.0 < $(interval.right); $(interval.left < 0.0), $(0.0 < interval.right)")
			y_intercept = x in f.free_symbols ? (0, f.subs(x, 0)) : (0, f.subs(y, 0))
			y_intercept = round.(convert.(Float64, y_intercept), digits = digits)
		else
			# println("OpenOpenInterval, missing, $(interval.left) < 0.0 < $(interval.right); $(interval.left < 0.0), $(0.0 < interval.right)")
			y_intercept = missing
		end
	elseif isa(interval, OpenClosedInterval)
		# println("OpenClosedInterval, $(interval.left) < 0.0 < $(interval.right)")
		if interval.left < 0.0 <= interval.right
			y_intercept = x in f.free_symbols ? (0, f.subs(x, 0)) : (0, f.subs(y, 0))
			y_intercept = round.(convert.(Float64, y_intercept), digits = digits)
		else
			println("OpenClosedInterval, missing")
			y_intercept = missing
		end
	elseif isa(interval, ClosedOpenInterval)
		# println("ClosedOpenInterval, $(interval.left) < 0.0 < $(interval.right)")
		if interval.left <= 0.0 < interval.right
			y_intercept = x in f.free_symbols ? (0, f.subs(x, 0)) : (0, f.subs(y, 0))
			y_intercept = round.(convert.(Float64, y_intercept), digits = digits)
		else
			println("ClosedOpenInterval, missing")
			y_intercept = missing
		end
	else
		if interval.left <= 0.0 <= interval.right
			# println("ClosedClosedInterval, $(interval.left) < 0.0 < $(interval.right)")
			y_intercept = x in f.free_symbols ? (0, f.subs(x, 0)) : (0, f.subs(y, 0))
			y_intercept = round.(convert.(Float64, y_intercept), digits = digits)
		else
			println("ClosedClosedInterval, missing")
			y_intercept = missing
		end
	end

	#vvv
	# sign_chart = signcharts(f(x); labels=labels, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	# println("f = $f")
	sign_chart = signcharts(f; labels=labels, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	# println("Found sign charts")
	    
    f_min, f_max = extrema(f; domain)
	f_min = [simplify.(x) for x in f_min]
	f_max = [simplify.(x) for x in f_max]
	f_max = [round.(pt, digits = digits) for pt in f_max if !ismissing(pt[2])]
	f_min = [round.(pt, digits = digits) for pt in f_min if !ismissing(pt[2])]
	
    infpt = inflection_points(f; domain)
	infpt = [simplify.(x) for x in infpt]
	infpt = convert.(Tuple{Float64, Float64}, infpt)
	# infpt = [round.(pt, digits = digits) for pt in infpt if !ismissing(pt[2])]
	for (i, pt) in enumerate(infpt)
		if isa(pt[1], Float64)
			coord1 = round(pt[1], digits = digits)
		else
			coord1 = pt[1]
		end
		if isa(pt[2], Float64)
			coord2 = round(pt[2], digits = digits)
		else
			coord2 = pt[2]
		end
		infpt[i] = (coord1, coord2) 
	end

    left_end, right_end = end_behavior(f, interval)
	# println("left_end = $left_end, right_end = $right_end")

	# new lines ###################################
	
	#Draw any holes that exists
	f_holes = []
	if !isempty(crpt_hole)		
		for c in crpt_hole
			# if xrange[1] < c < xrange[2]
				push!(f_holes, (c, lim(f, x, c)))
			# end
		end
	end
	###############################################
	
	(
		y_intercept = y_intercept, 
		max = length(f_max) == 0 ? [] : f_max, 
		min = length(f_min) == 0 ? [] : f_min, 
		inflection = isempty(infpt) ? [] : infpt,
		holes = isempty(f_holes) ? [] : f_holes, # new line
		# inflection = length(infpt) == 0 ? [] : infpt,
		left_behavior = left_end, 
		right_behavior = right_end, 
		signcharts = sign_chart
	)
end

"""
function_summary(a::Real; domain::String = "(-∞, ∞)", labels = "y", dotverticaljog=0, marksize=8, tickfontsize = 20, digits= 2, horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing)

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
function function_summary(a::T; domain::String = "(-∞, ∞)", labels = "y", dotverticaljog=0, marksize=8, tickfontsize = 20, digits= 2, horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing) where {T <: Union{Real, Int64}}
	# println("Constant fcn.")
	sign_chart = signcharts(a; labels=labels, domain = domain, horiz_jog = horiz_jog, size=size, dotverticaljog = dotverticaljog, marksize = marksize, tickfontsize = tickfontsize, imageFormat = imageFormat, xrange = xrange)
	(y_intercept = a, max = [], min = [], inflection = [], left_behavior = a, right_behavior = a, signcharts = sign_chart)
end

###############################################################################################################################
"""
    int(f, var)

Find the indefinite integral of function f wrt to the variable var.
"""
function int(f, var)
	# integrate(f(x), var)
	integrate(f, var)
end

"""
    int(f, var, a, b)

Find the definite integral of function f from ``a`` to ``b`` wrt to the variable var. 
"""
function int(f, var, a, b)
	# integrate(f(x), (var, a, b))
	integrate(f, (var, a, b))
end

function distance(p1::Tuple{Real, Real}, p2::Tuple{Real, Real})
	sqrt((p2[2] - p1[2])^2 + (p2[1] - p1[1])^2)
end

# function function_derivative_plot(f, xrange, xval; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)
# 	values = xrange[1]:xsteps:xrange[2]
# 	if ismissing(horiz_ticks)
# 		horiz_ticks = xrange[1]:xrange[2]
# 	end
	
#     f′ = diff(f(x))
# 	m = f′(xval)
# 	l(x) = m*(x - xval) + f(xval)
# 	l_inv(x) = 1/m*(x - f(xval)) + xval # find the x coordinates given the y

# 	f_extrema = extrema(f(x); domain = "[$(xrange[1]), $(xrange[2])]")
# 	println("f_extrema: $f_extrema")
# 	fmin = f_extrema.minima[1][2]
# 	xmin = l_inv(fmin)
# 	fmax = f_extrema.maxima[1][2]
# 	xmax = l_inv(fmax)
# 	# need to check if distance from tangent point to line endpoint is less/more than some min/max value and extend/compress x_left and x_right
# 	x_left = minimum(xmin, xmax)
# 	l_left = l(x_left)
# 	x_right = maximum(xmin, xmax)
# 	l_right = l(x_right)
# 	println("(x_left, l_left) = ($x_left, $l_left), (x_right, l_right) = ($x_right, $l_right)")
# 	dleft = distance((N(x_left), N(l_left)), (N(xval), N(f(xval))))
# 	if dleft < 1
# 		println("left distance = $dleft")
# 		x_left -=  1
# 		l_left = l(x_left)
# 	end
# 	dright = distance((N(x_right), N(l_right)), (N(xval), N(f(xval))))
# 	if dright < 1
# 		println("right distance = $dright")
# 		x_right +=  1
# 		l_right = l(x_right)
# 	end
# 	if dright > 3
# 		x_right = minimum([xrange[2], xval + 3])
# 		l_right = l(x_right)
# 	end
# 	println("(x_left, l_left) = ($x_left, $l_left), (x_right, l_right) = ($x_right, $l_right)")

#     p = functionplot(f(x), xrange; label = "", domain = domain, horiz_ticks = horiz_ticks, vert_ticks = vert_ticks, yrange = yrange, xsteps = xsteps, size = size, imageFormat = imageFormat, marksize = marksize)
# 	p = Plots.plot!([x_left, x_right], [l_left, l_right], linewidth=2)
# 	p = Plots.plot!([xval], [f(xval)], seriestype = :scatter, markercolor = :black, markersize = marksize)
#     p = yaxis!(label)

# 	p
# end

###############################################################################################################################
# """
#     graph_f_and_derivative(f, xrange; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)

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
# function graph_f_and_derivative(f, xrange; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)
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