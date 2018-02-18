library verilog;
use verilog.vl_types.all;
entity radix4adder_sv is
    generic(
        no_of_digits    : integer := 8;
        radix_bits      : integer := 3;
        radix           : integer := 4
    );
    port(
        din1            : in     vl_logic_vector;
        din2            : in     vl_logic_vector;
        cin             : in     vl_logic;
        dout            : out    vl_logic_vector;
        cout            : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
    attribute mti_svvh_generic_type of radix : constant is 1;
end radix4adder_sv;
