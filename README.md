# Memory to Memory Data Transfer

### Abstract:
Sequential logic blocks form a vital role in the transfer of data from one memory block to another memory block in a controlled data path. This project is about design implementation of the data transfer between two memory blocks using various logic blocks. It includes data flow synchronization and generation of timing diagrams.

### Table of Contents
 - [ Introduction ](#intro)
 - [ Objectives and Methodology ](#obj)
 - [ Implementation ](#impl)
 - [ Block Diagram of Memory to Memory Transfer ](#block)
 - [ Timing Diagram ](#time)

<a name="intro"></a>
### Introduction
The design of data path between two memory modules is realized using few major elements of computer architecture and design, like counters, flip- flops, adder etc. In this project, the given problem of data transfer from one 8*8 memory to another 4*8 memory, is implemented with Verilog hardware description language and timing diagrams are generated to check the data path and control path flow.
<a name="obj"></a>
### Objectives and Methodology
The aim of the project is to implement the memory to memory data transfer by understanding the working of individual modules, implementation of the modules and verify the data path and control path with timing diagrams.
At the initial stage, the modules are designed individually and with the help of test benches waveforms are generated for each module. In the next stage, all the blocks are integrated to develop larger functional block. Then after data paths are constructed and control signals are given via a controller.
As shown in the Figure 1, the controller generates WEA, WEB, IncA and IncB control signals based on the input clock frequency. Initially, counter A is set and AddrA[2:0] is generated for Memory A through this counter. WEA is kept high and this accounts for data to be written in to the memory through DataInA[7:0] port. This process happens from clock cycles 1 to 8. Once the data is written to all the address locations, in the next clock cycle, WEA becomes low and counter is reset to 0. Because the WEA is now 0, the data is no more written to the address but is read from the address locations. At clock cycle 9, the first data packet is read through DOut1[7:0] based on address available at AddrA[2:0].
 In clock cycle 10, the read data becomes available at DOut1 and the counter A is incremented by 1. In clock cycle 11, data packet A0 is transferred to DOut2 through a D flip-flop. And also, the DOut1 reads from AddrA=1. Once the values of A0 and A1 are available, before transferring them to memory B, the data is processed based on their respective values. This processing is carried out by a comparator module COMP, an adder and a subtractor. The inputs of COMP module will take the values of A0 and A1 and subtracts A1from A0. If the value of A1 is greater than value of A0 then the result of subtraction will result in a negative number and sign bit, which is the output of comparator, indicates a value of 1. This will select the value of (A0+A1) at ADDOut [7:0] through a 2*1 multiplexer and passes this value to DataInB[7:0]. On the other hand, if the value of A1 is less than value of A0 then the result of subtraction operation will yield a positive number and sign bit indicates a value of 0. This will select the value of (A0-A1) at SUBOut[7:0] through the same 2*1 multiplexer and the result is then passed to DataInB[7:0]. At positive edge of clock cycle 12, the output of DataInB[7:0] is written to the AddrB[1:0].
In clock cycle 12, the value of A1 is read by DOut2[7:0] and value of A2 is read by DOut1[7:0]. These values are compared by the COMP module and based on the value of sign bit either ADDOut[7:0] or SUBOut[7:0] value is fetched by the multiplexer to be passed on to DataInB[7:0]. As the value of A1 was previously used for comparison along with A0, it is unwarranted to use the value of A1 again for comparison with value of A2, because the design requirement states that any data packets should be compared only once in Memory A. Hence WEB is set to 0 on 12, 14, 16 and 18 clock cycles so that neither (A1 + A2) nor (A1 – A2) and the corresponding signals later are written at Memory B. Clock cycles of 13 – 18 compares the values of A2 with A3, A4 with A5 and A6 with A7 and based on the value obtained at sign bit of the COMP module, it writes the added value or subtracted value to Memory B. After clock cycle 19, the counters are reset and all operations in the data path is suspended.
<a name="impl"></a>
### Implementation
Memory transfer block has different modules which are implemented using Verilog programming language. Different modules involved are CounterA, CounterB, MemoryA, MemoryB, D flip-flop, Comparator, Adder, Subtractor, Multiplexer and the Controller decoder. Controller decoder takes reset and clock as input and generates WEA, IncA, WEB, IncB signals as outputs. Controller is implemented by a counter decoder type design. The signals controller generates help in controlling the data flow of the entire block by enabling read/write to the memories and by incrementing the addresses respectively. Counter A takes signal IncA as input and generates address for the Memory A which is 8*8 SRAM. Similarly, Counter B takes signal IncB and generates address for Memory B which is 4*8 SRAM. D flip-flop is used to latch the output of DOut1 for one clock cycle so that the next data in Memory A can come to DOut1 in the meanwhile the previous data goes to the DOut2 (output of D flip-flop). Comparator does the comparing of values at DOut1 and DOut2 and generates output signal to decide whether to carry out addition or subtraction on the data. ADDOut[7:0] and SUBOut[7:0] results then get selected in 2*1 multiplexer depending on the comparator signal (0 or 1). The output from the multiplexer which is either ADDOut or SUBOut is the DataInB for the Memory B. This is how the memory transfer happens from Memory A to Memory B. The individual modules are then instantiated in the top module (memory_transfer) which actually integrates each and every module and their respective signals and enables the memory transfer.
<a name="block"></a>
### Block Diagram of Memory to Memory Transfer
<p align="center">
  <img src="https://github.com/chaitanyakasaraneni/memorytomemorytransfer/blob/master/mem2mem.PNG">
</p>
<a name="time"></a>
### Timing Diagram for Memory to Memory Transfer
<p align="center">
  <img src="https://github.com/chaitanyakasaraneni/memorytomemorytransfer/blob/master/timing.PNG">
</p>

### Reference
- Ahmet Bindal, Fundamentals of Computer Architecture and Design, 2nd Edition, Feb 2019. Pages 89-93
