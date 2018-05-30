# -*- coding: cp936 -*-
import math
import generate_parameters as param_gen
import generate_hex_file as hex_gen
import SD_to_decimal as conv



def outputDataRegeneration(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency):
    (radix_bits, address_width, max_ram_address, target_frequency_2) = param_gen.generateParameter(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);

    max_ram_address = 1024;
    
    no_of_bytes = int(math.ceil((no_of_digits+1.0)*radix_bits*burst_index/8));
    byte_count = "{0:#0{1}X}".format(no_of_bytes,4)[2:];
    print (byte_count);
    no_of_bits = (no_of_digits+1)*radix_bits;
    data_file = open("../data/RAM0.hex", "r");
    data_file_2 = open("../data/outputs.txt", "w");
    data_file_3 = open("../data/outputs_bin.txt", "w");
    for i in range(max_ram_address):
        mem_data = data_file.readline();
        if (byte_count != mem_data[1:3]):
            print ("error! byte count doesn't match parameters given");
            break;
        checksum = hex_gen.calcChecksum(mem_data);
        if (checksum!="00"):
            print ("error! checksum doesn't match data given");
            print ("error data is: ", mem_data);
        mem_data = mem_data[9:len(mem_data)-3];
        mem_data = bin(int(mem_data, 16))[2:].zfill((no_of_digits+1)*radix_bits*burst_index);
        mem_data = [mem_data[j:j+no_of_bits] for j in range(0, len(mem_data), no_of_bits)];
        for j in range(burst_index):
            data_file_2.write(str(conv.restoreNumberFromSD(mem_data[j], radix_bits))+"\n");
            # data_file_2.write(str(int(mem_data[j], 2))+"\n");
            data_file_3.write(mem_data[j]+"\n");
        # print mem_data;

def main():

    LFSR_SIZE = 32;
    no_of_digits = 10;
    radix = 4;
    burst_index = 5;
    target_frequency = 400;
    outputDataRegeneration(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);

        
if __name__ == "__main__":
    main();
