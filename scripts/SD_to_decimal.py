

def main():
    dout = [0, 0, 0, 2, -1, 2, 1, 0];
    din1 = [0, -2, 2, 2];
    din2 = [0, -2, 2, 2];
    data1 = SD_to_decimal(din1,4);
    data2 = SD_to_decimal(din2,4);
    data3 = SD_to_decimal(dout,4);
    print data1, data2, data1*data2, data3;

def SD_to_decimal(SD,radix):
    SD_len = len(SD);
    output = 0;
    for i in range(SD_len):
        output = SD[i] + output*radix
    return output

def restore_number_from_sd(input_1, radix_bits):
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

