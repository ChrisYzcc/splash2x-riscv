# RISC-V Splash2x Benchmark

## Command
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

Currently only support `test` and `simdev` inputs.

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
| ocean_ncp | *             | x             |
| radiosity | *             | *             |
| radix     | *             | *             |
| raytrace  | *             | x             |
| volrend   | *             | *             |
| water_ns  | *             | *             |
| water_sp  | *             | *             |

`raytrace` and `ocean_ncp` will cause segmentation fault on qemu-riscv machine.

## Future Work
- [ ] Fix `raytrace`.
- [ ] Fix `ocean_ncp`.
- [ ] Add other inputs package (simsmall, simmedium, simlarge, native) and command.