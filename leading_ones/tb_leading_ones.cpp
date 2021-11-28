#include <stdlib.h>
#include <iostream>
#include <cstdlib>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vleading_ones.h"

#define MAX_SIM_TIME 1000
#define WIDTH 16

vluint64_t sim_time = 0;

class Driver {
    private:
        Vleading_ones *dut;
        uint32_t drive_count;

    public:
        Driver(Vleading_ones *dut) {
            this->dut = dut;
            drive_count = 0;
        }

        void drive() {
            dut->SW = 0;
            if(drive_count < 16) {
                dut->SW = 1 << drive_count;
            } else if(drive_count >= 16 && drive_count < 32) {
                dut->SW = 1 << (rand() % 5) | 1 << (rand() % 5 + 4);
            } else if(drive_count >= 32 && drive_count < 64) {
                dut->SW = rand() % (1 << WIDTH);
            }
            drive_count++;
        }
};

class Checker {
    private:
        Vleading_ones *dut;

    public:
        Checker(Vleading_ones *dut) {
            this->dut = dut;
        }

        void check() {
            if( dut->SW ) {
                for( char i = WIDTH-1; i >= 0;  --i) {
                    if( dut->SW & (1 << i)) {
                        if(dut->LED != (i + 1)) {
                            std::cout << "Error: LED mismatch" << std::endl
                                << "  Expected: "<< i+1 << " Actual: " << +dut->LED << std::endl;
                        }
                        break;
                    }
                }
            } else {
                if(dut->LED != 0) {
                    std::cout << "Error: LED mismatch" << std::endl
                        << "  Expected: 0" << " Actual: " << +dut->LED << std::endl;
                }
            }
        }
};

int main(int argc, char **argv) {
    srand(time(NULL));
    Verilated::commandArgs(argc, argv);

    Vleading_ones *dut = new Vleading_ones;
    Driver *driver = new Driver(dut);
    Checker *checker = new Checker(dut);

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    while(sim_time < MAX_SIM_TIME) {
        driver->drive();

        dut->eval();

        checker->check();

        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);

}
