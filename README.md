# Minima
Simple formula processing sysytem on Elixir

Now, under construction.

## Installation
make clone and enter "mix minima"

e.g. 

```

$ mix minima
Compiling 1 file (.ex)
Minima ver0.01
> 1+2;
3
> diff(x^3+2*x+3,x);
3*x^2+2
> integrate(cos(x),x);
sin(x)
> quit;
goodbye
```

## input
formula;

termination is ; semicolon

## differential
diff(formula,variable);

## integral
integra(formula,variable);

## matrix
- e.g. matrix([1,2],[3,4])
- + - * operation
- determinant(m)
- transpose(m)
- submatrix(m,i,j)


## quit
quit;



