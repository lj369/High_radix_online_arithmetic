

def main():
    """
    Change dout to be new output; din1 to be input1; din2 to be input2
    """
    dout = [0, 0, 0, 2, -1, 2, 1, 0];
    din1 = [0, -2, 2, 2];
    din2 = [0, -2, 2, 2];
    data1 = SDToDecimal(din1,4);
    data2 = SDToDecimal(din2,4);
    data3 = SDToDecimal(dout,4);
    print data1, data2, data1*data2, data3;

def SDToDecimal(SD,radix):
    """
    This function takes SD inputs 'SD' in form [d, d, ...,] where d is the decimal number in each digit starting from MSD 
    and then convert it to decimal number

    This function is normally used in hand conversion
    """
    SD_len = len(SD);
    output = 0;
    for i in range(SD_len):
        output = SD[i] + output*radix
    return output

def restoreNumberFromSD(input_1, radix_bits):
    """
    This function takes SD inputs 'input_1' in form [b,b,b, b,b,b, ...,] where 'input_1' is a string with its elements as '1' or '0' or 'x' starting form MSB
    and then convert it to decimal number

    This function is normally used in converting binary numbers from a file
    """
    input_digit_length = len(input_1)/radix_bits;
    output = 0;
    for i in range(input_digit_length):
        output_digit = 0;
        for j in range(radix_bits):
            if (j==0):
                output_digit -= int(input_1[i*radix_bits+j])*2**(radix_bits-1-j);
            else:
                output_digit += int(input_1[i*radix_bits+j])*2**(radix_bits-1-j);
        output = output_digit+output*2**(radix_bits-1);
    return output



if __name__=="__main__":
    main();

