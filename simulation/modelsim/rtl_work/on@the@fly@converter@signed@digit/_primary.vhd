library verilog;
use verilog.vl_types.all;
entity onTheFlyConverterSignedDigit is
    generic(
        no_of_digits    : integer := 4;
        radix_bits      : integer := 3
    );
    port(
        q               : in     vl_logic_vector;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \Q\             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
end onTheFlyConverterSignedDigit;
