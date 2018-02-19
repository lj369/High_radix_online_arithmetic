library verilog;
use verilog.vl_types.all;
entity onTheFlyConverter is
    generic(
        no_of_digits    : integer := 8
    );
    port(
        q               : in     vl_logic_vector(2 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \Q\             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
end onTheFlyConverter;
