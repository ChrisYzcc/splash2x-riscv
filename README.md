# RISC-V Splash2x Benchmark

## Command
**Get Inputs Command**

`gen_inputs.sh` will download the inputs and extract them to the directories.

```
Usage: ./gen_inputs.sh
```

**Build Command**
```
Usage: ./build.sh [-p program] [-r] [-h]
  -p program : specify the program to build, default: barnes
  -r          : set platform to rv64
  -h          : display this help message
```

**Run Command**
```
Usage: ./run.sh [-p program] [-r] [-v version] [-h]
  -p program   : specify the program to run, default: barnes
  -r           : set platform to rv64
  -n threads   : specify the number of threads, default: 1
  -i input     : specify the input size, default: test
  -h           : display this help message
```

Available inputs size: `test`, `simdev`, `simsmall`, `simmedium`, `simlarge`.

**RISC-V Package**

`gen_rv_pack.sh` will pack all the RISC-V bins and datas with running scripts. You can simply copy that package to the target RISC-V machine.
```
Usage: ./gen_rv_pack.sh
```

## Tests Summay
Native Platform: x86_64, Debian on WSL2

RISC-V Platfrom: QEMU, Kunminghu Config

| Test Name | Native Run    | RISC-V Run    |
| ----      | :----:        | :----:        |
| barnes    | *             | *             |
| cholesky  | *             | *             |
| fft       | *             | *             |
| fmm       | *             | *             |
| lu_cb     | *             | *             |
| lu_ncb    | *             | *             |
| ocean_cp  | *             | *             |
| ocean_ncp | *             | *             |
| radiosity | *             | *             |
| radix     | *             | *             |
| raytrace  | *             | *             |
| volrend   | *             | *             |
| water_ns  | *             | *             |
| water_sp  | *             | *             |

`raytrace` will cause segmentation fault on qemu-riscv machine. - Fix: fix multiple definition.

`ocean_ncp` will cause segmentation fault on qemu-riscv machine. - Fix: we need at least 16GB memory when running test size input.

## Future Work
- [x] Fix `raytrace`.
- [x] Fix `ocean_ncp`.
- [x] Add other inputs package (simsmall, simmedium, simlarge) and command.
- [ ] Add native size inputs package.