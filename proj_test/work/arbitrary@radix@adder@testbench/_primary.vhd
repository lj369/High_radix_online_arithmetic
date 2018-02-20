library verilog;
use verilog.vl_types.all;
entity arbitraryRadixAdderTestbench is
    generic(
        no_of_digits    : integer := 8;
        radix_bits      : integer := 2;
        radix           : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
    attribute mti_svvh_generic_type of radix : constant is 1;
end arbitraryRadixAdderTestbench;
