

def main():
    din1 = 0;
    din2 = 0;
    cin = 0;
    seed = 0b000110010010;
    tap1 = (9, 7, 5, 1);
    tap2 = (9, 3, 1);
    nbits = 9;
    number_of_inputs = 50;
    radix_bits = 3;

    sr1 = lfsr(seed, tap1, nbits, number_of_inputs);
    sr2 = lfsr(seed, tap2, nbits, number_of_inputs);


    #for i in range(len(sr1)):
    #    print (format(sr1[i], '09b'))

    with open('.\proj_test\input_data.txt', 'w') as f:
        for i in range(len(sr1)):
            sr1_str = format(sr1[i], '012b');
            sr2_str = format(sr2[i], '012b')
            sr1_str = check_datavalid(sr1_str, radix_bits);
            sr2_str = check_datavalid(sr2_str, radix_bits);
            data = sr1_str+'\t'+sr2_str+'\n';
            f.write(data);
    

def check_datavalid(data, radix_bits):
    invalid = False
    data_out = ""
    for i in range(len(data)/radix_bits):
        if (data[i*radix_bits]=='1'):
            invalid = True;
        for j in range(radix_bits):
            if (j!=0):
                if (data[i*radix_bits+j]=='1'):
                    invalid = False;
                    break;
        if (invalid):
            for k in range(radix_bits):
                data_out += '0';
        else:
            data_out += data[i*radix_bits:(i+1)*radix_bits];
    return data_out;


def lfsr2(seed, taps, nbits):
    sr = seed;
    while 1:
        xor = 1
        for t in taps:
            if (sr & (1<<(t-1))) != 0:
                xor ^= 1
        sr = (xor << nbits-1) + (sr >> 1)
        yield xor, sr
        if sr == seed:
            break

#for xor, sr in lfsr2(0b110010011, (9,7,6,1)):
#    print xor, bin(2**nbits+sr)[3:]


def lfsr(seed, taps, nbits, number_of_inputs):
    sr = [];
    sr.append(seed);
    counter = 1;
    while 1:
        xor = 1
        for t in taps:
            if (sr[counter-1] & (1<<(t-1))) != 0:
                xor ^= 1
        sr.append((xor << nbits-1) + (sr[counter-1] >> 1))
        counter = counter + 1;
        #yield xor, sr
        if counter >= number_of_inputs:
            return sr;

if __name__=="__main__":
    main();
