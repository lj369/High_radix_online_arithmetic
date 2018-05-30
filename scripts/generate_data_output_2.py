import random
import SD_to_decimal as conv
import generate_parameters as param_gen
import math

class LFSRGenerator:
    
    def __init__(self, mask, initial_value, LFSR_BIT):
        self.mask = mask;
        self.value = initial_value;
        self.max_value = 2**LFSR_BIT;
    
    def __parity(self, x):
        k = 0
        d = x
        while d != 0:
            k = k + 1
            d = d & (d - 1)
        return k % 2

    def updateLFSR(self):
        # print (self.value);
        value_after_mask = self.mask & self.value;
        result = 1-self.__parity(value_after_mask); # not (reduction xor)
        temp = self.value*2; # shift left by 1 bit
        # print (self.mask, self.value, value_after_mask, result, temp);
        # print (type(self.mask), type(self.value), type(value_after_mask), type(result), type(temp));
        if (temp>=self.max_value):
            self.value = result+temp-self.max_value;
        else:
            self.value = result+temp;
        # print (self.value);
    def check_content(self):
        return self.value;

    def output(self):
        if (self.value%2):
            return "1";
        else:
            return "0";


class LFSRBlock:
    
    def __init__(self, mask, initial_value, LFSR_BIT, no_of_bits, radix_bits):
        self.LFSRs = [];
        self.radix_bits = radix_bits;
        self.max_neg = "1";
        for i in range(self.radix_bits-1):
            self.max_neg += "0";
        self.max_neg_p_one = self.max_neg[0:self.radix_bits-1];
        self.max_neg_p_one += "1";
        for i in range(no_of_bits):
            self.LFSRs.append(LFSRGenerator(mask, i+1+initial_value, LFSR_BIT));

    def output(self):
        result = "000";
        state = 0;
        for i in range(len(self.LFSRs)):
            # print (len(self.LFSRs));
            if (i%self.radix_bits == 0):
                pre_out = "";
            pre_out += self.LFSRs[len(self.LFSRs)-1-i].output();
            if (i%self.radix_bits == self.radix_bits-1):
                if (pre_out == self.max_neg):
                    pre_out = self.max_neg_p_one;
                result += pre_out;
            self.LFSRs[len(self.LFSRs)-1-i].updateLFSR();
        return result;

    def output_test(self):
        result = "000";
        state = 0;
        i = 0;
        result = self.LFSRs[len(self.LFSRs)-1-i].check_content();
        result = "0"+bin(result)[2:].zfill(32)
        self.LFSRs[len(self.LFSRs)-1-i].updateLFSR();
        return result;

def generateInputData(LFSR_SIZE, no_of_digits, radix_bits, max_ram_address):
    common_mask = "10000000001000000000000000000011";
    common_mask_dec = int(common_mask, 2);
    init_offset = [1451698946, 1537598292];
    no_of_bits = (no_of_digits*2) * radix_bits;
    LFSR_block_1 = LFSRBlock(common_mask_dec, init_offset[0], LFSR_SIZE, no_of_bits, radix_bits);
    LFSR_block_2 = LFSRBlock(common_mask_dec, init_offset[1], LFSR_SIZE, 2, 2);

    file1 = open("../data/input_data_test.txt", "w");


    for i in range(16382):
        # print (LFSR_block_1.output(), int(LFSR_block_1.output(), 2));
        # temp = LFSR_block_2.output();
        # print (temp, int(temp, 2), LFSR_block_3.output());
        CinLFSR_out = LFSR_block_2.output();
        '''
        for j in range(radix_bits-2):
            CinLFSR_out = CinLFSR_out[0]+CinLFSR_out;
        write_str_1 = CinLFSR_out+LFSR_block_1.output()+"\n";
        '''
        # write_str_1 = LFSR_block_1.output()[0:no_of_digits*radix_bits]+"\n";
        write_str_1 = LFSR_block_1.output_test()+"\n";

        # print CinLFSR_out+","+write_str_1
        file1.write(write_str_1);
        
    file1.close();
    print ("input file generated");

def calcAddDiff(din1, din2, cin, dout, radix_bits):
    '''
    This function converts inputs from binary string to decimals and compare if din1+din2 == dout
    
    '''
    data1 = conv.restoreNumberFromSD(din1, radix_bits);
    data2 = conv.restoreNumberFromSD(din2, radix_bits);
    data3 = conv.restoreNumberFromSD(cin, radix_bits);
    ideal_out = data1+data2+data3;
    # data4 = conv.restoreNumberFromSD(dout, radix_bits);
    data4 = dout;
    # print (data1, din1, data2, din2, data3, cin, data4, dout);
    if (ideal_out == 0):
        return 0;
    else:
        return (float(data4-ideal_out)/float(ideal_out))**2;

def compareOutput(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency):
    
    (radix_bits, address_width, max_ram_address, target_frequency_2) = param_gen.generateParameter(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);


    '''
    for j in range(1):
        file_name = "../data/RAM"+str(j+1)+".hex";
        file4 = open(file_name, "r");
        for i in range(16383):
            din1 = file1.readline();
            dout = file4.readline()[10:17];
            dout = bin(int(dout, 16))[2:].zfill(radix_bits*8);
            temp_diff = calcAddDiff(din1, din2, cin, dout, radix_bits);
            if (temp_diff != 0):
                print ("error with diff ", temp_diff, din1, din2, cin, dout);
                print ("current i is" , i);
        file4.close();
    file1.close();
    '''

    file1 = open("../data/input_data1.txt", "r");
    total_diff = 0;

    for j in range(1):
        file_name = "../data/outputs.txt";
        file4 = open(file_name, "r");
        for i in range(16383):
            din1 = file1.readline();
            din2 = din1[radix_bits:radix_bits*(no_of_digits+1)];
            cin = din1[0:radix_bits];
            din1 = din1[radix_bits*(no_of_digits+1):radix_bits*(no_of_digits*2+1)]
            # dout = file4.readline()[10:17];
            # dout = bin(int(dout, 16))[2:].zfill(radix_bits*8);
            dout = int(file4.readline());
            temp_diff = calcAddDiff(din1, din2, cin, dout, radix_bits);
            if (temp_diff != 0):
                print ("error with diff ", temp_diff, din1, din2, cin, dout);
                print ("current i is" , i);
            total_diff += temp_diff;
        file4.close();
    file1.close();
    return total_diff

def main():
    
    LFSR_SIZE = 32;
    no_of_digits = 8;
    radix = 4;
    radix_bits = 3;
    burst_index = 8;
    target_frequency = 200;
    max_ram_address = 16384;
    generateInputData(LFSR_SIZE, no_of_digits, radix_bits, max_ram_address);
    # total_diff = compareOutput(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);
    # print total_diff

if __name__ == "__main__":
    main();
