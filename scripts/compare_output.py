import csv
import re

def main():
    last_read_f = "start";
    radix_bits = 3;
    with open('./proj_test/output.txt', 'r') as f:
    #    while(last_read_f!=""):
        for i in range(20):
            read_f = f.readline();
            data = re.split('\t', read_f);
            print data[0], data[1], data[2];
            #calc_add(data[0], data[1], data[2], radix_bits);
            calc_mult(data[0], data[1], data[2], radix_bits);
            last_read_f = read_f;

def calc_mult(din1, din2, dout, radix_bits):
    data1 = restore_number_from_sd(din1, radix_bits);
    data2 = restore_number_from_sd(din2, radix_bits);
    data3 = restore_number_from_sd(dout, radix_bits);
    print data1, data2, data3;
    if (data3 != data1 * data2):
        print "error with din1 = ", din1, ", din2 = ", din2, ", dout = ", dout;
    #else:
    #    print "correct"
        

def calc_add(din1, din2, dout, radix_bits):
    data1 = restore_number_from_sd(din1, radix_bits);
    data2 = restore_number_from_sd(din2, radix_bits);
    data3 = restore_number_from_sd(dout, radix_bits);
    print data1, data2, data3;
    if (data3 != data1 + data2):
        print "error with din1 = ", din1, ", din2 = ", din2, ", dout = ", dout;
    #else:
    #    print "correct"
        
def restore_number_from_sd(input_1, radix_bits):
    input_digit_length = len(input_1)/radix_bits;
    output = 0;
    for i in range(input_digit_length):
        output_digit = 0;
        for j in range(radix_bits):
            if (input_1[i*radix_bits+j]=='x'):
                break;
            else:
                if (j==0):
                    output_digit -= int(input_1[i*radix_bits+j])*2**(radix_bits-1-j);
                else:
                    output_digit += int(input_1[i*radix_bits+j])*2**(radix_bits-1-j);
        output = output_digit+output*2**(radix_bits-1);
    return output

if __name__ == "__main__":
    main();
