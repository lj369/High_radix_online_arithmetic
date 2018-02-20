library verilog;
use verilog.vl_types.all;
entity radix4MultiplierTestbench is
    generic(
        no_of_digits    : integer := 4;
        radix_bits      : integer := 3;
        radix           : integer := 4;
        delta           : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
    attribute mti_svvh_generic_type of radix : constant is 1;
    attribute mti_svvh_generic_type of delta : constant is 1;
end radix4MultiplierTestbench;
