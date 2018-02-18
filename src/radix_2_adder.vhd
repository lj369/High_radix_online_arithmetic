entity radix_2_adder is
	port(
		din1p, din1n, din2p, din2n, cin, clk: in std_logic;
		doutp, doutn, cout: out std_logic;
	);
	
architecture struct of radix_2_adder is
begin
	
	
	P1: process()
		variable fa1c, fa1s, fa2c, fa2s: std_logic;
	begin
		{fa1c[0], fa1s[0]} <= din1p[0] + ~din1n[0] + din2p[0];
		{fa2c[0], fa2s[0]} <= fa1s[0] + cin + ~din2n[0];

		for (i=1; i<no_of_digits; i=i+1)

		begin
			{fa1c[i], fa1s[i]} <= din1p[i] + ~din1n[i] + din2p[i];
			{fa2c[i], fa2s[i]} <= fa1s[i] + fa1c[i-1] + ~din2n[i-1];

		end
	end process P1;

end
