import subprocess
import replace_master_level_file as master_file_gen
import recover_data_from_hex as output_regen
import generate_data_output_2 as error_gen
import generate_parameters as param_gen
import time

def compileProject():
    # p = subprocess.check_output(["quartus_sh", "--flow", "compile", "\"C:\Users\J_Lian\Desktop\FYP\High_radix_online_arithmetic\""], shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process = subprocess.Popen(["quartus_sh", "--flow", "compile", "C:\\Users\\J_Lian\\Desktop\\FYP\\High_radix_online_arithmetic"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process.communicate();

def configureFPGA():
    # p = subprocess.check_output(["quartus_pgm", "-c", "\"USB-BlasterII [USB-1]\"", "-m", "JTAG", "-o", "\"P;C:\Users\J_Lian\Desktop\FYP\output_files\High_radix_online_arithmetic.sof@2\""], shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process = subprocess.Popen(["quartus_pgm", "-c", "USB-BlasterII [USB-1]", "-m", "JTAG", "-o", "P;C:\Users\J_Lian\Desktop\FYP\output_files\High_radix_online_arithmetic.sof@2"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process.communicate();

def getMemoryContent():
    # p = subprocess.check_output(["quartus_stp", "-t", "C:\Users\J_Lian\Desktop\FYP\scripts\read_data.tcl"], shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process = subprocess.Popen(["quartus_stp", "-t", "C:\\Users\\J_Lian\\Desktop\\FYP\\scripts\\read_data.tcl"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    process.communicate();

def pathSetup():
    p = subprocess.check_output(["dir", "C:\Users\J_Lian\Desktop\FYP\scripts"], shell=True, cwd="D:\\JLian_temp_ws\\quartus\\quartus\\bin64")
    print p;

def main():

    no_of_test_per_param = 50;
    
    LFSR_SIZE = 32;
    no_of_digits = 8;
    radix = 4;
    burst_index = 8;
    target_frequency = 200;

    (radix_bits, address_width, max_ram_address, target_frequency_2) = param_gen.generateParameter(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);

    # generate master level file
    # master_file_gen.replaceMasterLevelFile(LFSR_SIZE, no_of_digits, radix ,burst_index, target_frequency);
    print ("new master file is generated");

    # compile project
    compileProject();
    print ("project is compiled");

    # configure FPGA
    configureFPGA();
    print ("configured FPGA");

    total_error = 0;
    for i in range(no_of_test_per_param):
        time.sleep(1); # sleep for 1 second such that data can be calculated
        # get memory content
        getMemoryContent();
        output_regen.outputDataRegeneration(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);
        error_gen.generateInputData(LFSR_SIZE, no_of_digits, radix_bits, max_ram_address);
        temp_error = error_gen.outputDataRegeneration(LFSR_SIZE, no_of_digits, radix, burst_index, target_frequency);
        total_error += temp_error;

    print total_error;

if __name__ == "__main__":
    main();
