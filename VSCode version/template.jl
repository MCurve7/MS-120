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

# Make a limit table
limittable(f, 2)

# Want more rows
limittable(f, 2; rows = 10)

# Want more decimal places
limittable(f, 2; format = "%.15f")

# Want more rows and more decimal places
limittable(f, 2; rows = 10, format = "%.15f")

# Want documentation:
# Go to the REPL and type a ?
# then type limittable and hit ENTER
