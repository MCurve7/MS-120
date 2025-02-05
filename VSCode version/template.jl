include("JSUMS120-vscode.jl")

begin
	x = symbols("x", real = true)
	h = Sym("h")
	C = Sym("C")
	∞ = oo
end

### Your code goes below ########################################################

## Examples
# Make a function
f(x) = x^2

# Make a limit table?
limittable(f, 2)

# Want more rows
limittable(f, 2; rows = 10)

# Want more decimal places?
limittable(f, 2; format = "%.15f")

# Want to change colors? List of colors: https://juliagraphics.github.io/Colors.jl/stable/namedcolors/
limittable(f, 2; colors = [:green, :navy])

# Can use symbols (:green) or strings ("navy)
limittable(f, 2; colors = [:green, "navy"])

# Want more rows and more decimal places?
limittable(f, 2; rows = 10, format = "%.15f")

# Want documentation:
# Go to the REPL and type a ?
# then type limittable and hit ENTER
