# KAIROS

KAIROS: Incremental Verification in High-Level Synthesis through Latency-Insensitive Design


## Dependency

```
sudo apt install berkeley-abc
sudo apt install yosys
```

## Create wrapper

```
python3 ./kairos.py ./gcd_fast_m.v ./gcd_slow_m.v ./gcd_dest_m.v
```
## Change bitvector length

Open a text editor, replace [5:0] to (e.g.) [2:0] in everywhere.

## Simulation

Open eda playground

```
https://www.edaplayground.com/x/kzxN
```

Then click run.

If you want to modify the testbench, please clone to another playground then modify it.

## Synthesis

```
yosys
```
```
read_verilog ./gcd_dest_m.v
synth -top gcd_dest_m
write_verilog gcd.v
```

```
read_verilog ./gcd_dest_m.v
synth -top gcd_dest_m
flatten
aigmap
write_aiger gcd.aig
```

## Model checking

You can try other model checkers, for example, IC3_ref.

The aig file is already a mitered circuit. A model checker will find a counterexample whenever the output signal (nequiv) is 1. If it can never be a 1, the model is safe.
```
berkeley-abc
```
```
read_aiger ./gcd.aig
pdr
```

```
nuXmv
```
```
./nuxmv -int
```
```
read_aiger_model -i ./gcd.aig
flatten_hierarchy
encode_variables
build_boolean_model
check_invar_ic3
```

