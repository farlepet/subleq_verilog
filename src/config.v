/* config.v
 * Contains global configuration constants. */

`timescale 1ns/10ps

`define DATAWIDTH 16
`define CTRLWIDTH 14

/*
 * Control lines
 *
 *   0:   WR_REQ    Peripheral write request
 *   1:   WR_DONE   Peripheral write done
 *   2:   RD_REQ    Peripheral read request
 *   3:   RD_READY  Peripheral read result ready
 *   5:4: REG_WR    Register write
 *   7:6: REG_RD    Register read
 *   9:8: ALU_LD    ALU load register
 *   10:  ALU_MODE  ALU mode (0: INC->ADDR, 1: SUB->DATA)
 *   11:  ALU_DONE  ALU operation complete
 *   12:  ALU_READ  ALU output enable
 *   13:  ALU_LEZ   ALU result less than or equal to zero
 */
`define CTRL_WR_REQ     0
`define CTRL_WR_DONE    1
`define CTRL_RD_REQ     2
`define CTRL_RD_READY   3
`define CTRL_REG_WR     4
`define CTRL_REG_RD     6
`define CTRL_ALU_LD     8
`define CTRL_ALU_MODE  10
`define CTRL_ALU_DONE  11
`define CTRL_ALU_READ  12
`define CTRL_ALU_LEZ   13

`define REG_NONE 0
`define REG_PC   1
`define REG_A    2
`define REG_B    3

