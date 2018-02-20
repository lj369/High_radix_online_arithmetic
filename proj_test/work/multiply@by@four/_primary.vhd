library verilog;
use verilog.vl_types.all;
entity multiplyByFour is
    generic(
        no_of_digits    : integer := 4;
        radix_bits      : integer := 3;
        radix           : integer := 4
    );
    port(
        din1            : in     vl_logic_vector;
        din2            : in     vl_logic_vector;
        dout            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
    attribute mti_svvh_generic_type of radix : constant is 1;
end multiplyByFour;
