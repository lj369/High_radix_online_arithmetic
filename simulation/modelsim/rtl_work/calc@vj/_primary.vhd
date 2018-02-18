library verilog;
use verilog.vl_types.all;
entity calcVj is
    generic(
        no_of_digits    : integer := 4;
        radix_bits      : integer := 3;
        radix           : integer := 4;
        delta           : integer := 2
    );
    port(
        X_j             : in     vl_logic_vector;
        Y_j             : in     vl_logic_vector;
        x_j_1           : in     vl_logic_vector;
        y_j_1           : in     vl_logic_vector;
        W_j             : in     vl_logic_vector;
        clk             : in     vl_logic;
        p_j             : out    vl_logic_vector;
        V_j             : out    vl_logic_vector;
        reset           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of no_of_digits : constant is 1;
    attribute mti_svvh_generic_type of radix_bits : constant is 1;
    attribute mti_svvh_generic_type of radix : constant is 1;
    attribute mti_svvh_generic_type of delta : constant is 1;
end calcVj;
