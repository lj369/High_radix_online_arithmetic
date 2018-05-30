
import math


def generateParameter(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency):
    radix_bits = int(1 + math.log(radix,2.0));
    address_width = int(math.floor(math.log(math.floor(5662720/(no_of_digits+1)/radix_bits/burst_index),2)));
    max_ram_address = int(math.pow(2,address_width));
    target_frequency_2 = int(target_frequency/burst_index);
    return (radix_bits, address_width, max_ram_address, target_frequency_2)


    
def generateParameterStr(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency):
    parameter_str = "\tparameter ";
    temp_str = "";
    temp_str += parameter_str;
    temp_str += "LFSR_SIZE = ";
    temp_str += str(LFSR_SIZE);
    temp_str += ",\n";
    temp_str += parameter_str;
    temp_str += "no_of_digits = ";
    temp_str += str(no_of_digits);
    temp_str += ",\n";
    temp_str += parameter_str;
    temp_str += "radix_bits = ";
    radix_bits = int(1 + math.log(radix,2.0));
    temp_str += str(radix_bits);
    temp_str += ", // = 1+log2(radix) \n";   
    temp_str += parameter_str;
    temp_str += "radix = ";
    temp_str += str(radix);
    temp_str += ",\n";   
    temp_str += parameter_str;
    temp_str += "no_of_mem_bits = ";
    temp_str += str(radix_bits);
    temp_str += ",\n";   
    temp_str += parameter_str;
    temp_str += "address_width = ";
    address_width = int(math.floor(math.log(math.floor(5662720/(no_of_digits+1)/radix_bits/burst_index),2)));
    temp_str += str(address_width);
    temp_str += ", // = floor(log2(floor(5662720/(no_of_digits+1)/radix_bits/burst_index))) \n";   
    temp_str += parameter_str;
    temp_str += "max_ram_address = ";
    max_ram_address = int(math.pow(2,address_width));
    temp_str += str(max_ram_address);
    temp_str += ", // = 2^address_width \n";   
    temp_str += parameter_str;
    temp_str += "burst_index = ";
    temp_str += str(burst_index);
    temp_str += ",\n";   
    temp_str += parameter_str;
    temp_str += "target_frequency = \"";
    temp_str += str(target_frequency);
    temp_str += ".000000 MHz\"";
    temp_str += ",\n";   
    temp_str += parameter_str;
    temp_str += "target_frequency_2 = \"";
    temp_str += str(target_frequency/burst_index);
    temp_str += ".000000 MHz\"";
    temp_str += " // = target_frequency/burst_index \n";
    return temp_str;
    
def main():
    
    LFSR_SIZE = 32;
    no_of_digits = 8;
    radix = 4;
    burst_index = 8;
    target_frequency = 400;
    parameter_str = generateParameterStr(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);
    print (parameter_str);

if __name__ == "__main__":
    main();
