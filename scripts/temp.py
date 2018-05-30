import SD_to_decimal as conv

radix_bits = 3;
din1 = "011001101110011001101110";
data1 = conv.restoreNumberFromSD(din1, radix_bits);
din2 = "011001101110011001101110";
data2 = conv.restoreNumberFromSD(din2, radix_bits);
cin =  "001";
data3 = conv.restoreNumberFromSD(cin, radix_bits);
print data1,data2, data3, data1+data2+data3;

dout = "111010001101001010011101001";
data4 = conv.restoreNumberFromSD(dout, radix_bits);
print data4
# conv.restoreNumberFromSD(dout, radix_bits);

# print bin(5592149)
