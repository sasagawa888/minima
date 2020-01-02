# Minima
Simple formula processing sysytem on Elixir

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
> integra(cos(x),x);
sin(x)
> quit;
goodbye
```

## input
formula;

termination is ; semicolon

## diferential
diff(formula,variable);

## integral
integra(formula,variable);

## quit
quit;



