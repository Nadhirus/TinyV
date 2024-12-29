# **RV32I Instruction Encoding and Decoding Guide**

## **1. RV32I Instruction Encoding**

Each RV32I instruction is 32 bits wide. The layout depends on the instruction type. Below are the detailed encoding formats:

### **R-Type Instructions (Register-Register Operations)**
```plaintext
| funct7 (7 bits) | rs2 (5 bits) | rs1 (5 bits) | funct3 (3 bits) | rd (5 bits) | opcode (7 bits) |
```

- **funct7**: Further distinguishes instructions within an opcode.
- **rs1, rs2**: Source registers.
- **rd**: Destination register.
- **funct3**: Helps differentiate between instructions under the same opcode.
- **opcode**: Specifies the broad class of instruction.

#### **R-Type Instruction Table**

| **Instruction** | **funct7** | **funct3** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|------------|------------|---------------------|------------------|
| ADD              | 0000000    | 000        | 0110011             | 0x33            |
| SUB              | 0100000    | 000        | 0110011             | 0x33            |
| SLL              | 0000000    | 001        | 0110011             | 0x33            |
| SLT              | 0000000    | 010        | 0110011             | 0x33            |
| SLTU             | 0000000    | 011        | 0110011             | 0x33            |
| XOR              | 0000000    | 100        | 0110011             | 0x33            |
| SRL              | 0000000    | 101        | 0110011             | 0x33            |
| SRA              | 0100000    | 101        | 0110011             | 0x33            |
| OR               | 0000000    | 110        | 0110011             | 0x33            |
| AND              | 0000000    | 111        | 0110011             | 0x33            |

---

### **I-Type Instructions (Immediate Operations)**

```plaintext
| imm[11:0] (12 bits) | rs1 (5 bits) | funct3 (3 bits) | rd (5 bits) | opcode (7 bits) |
```

- **imm[11:0]**: Immediate value (sign-extended).
- **rs1**: Source register.
- **rd**: Destination register.
- **funct3**: Instruction-specific field.
- **opcode**: Class of instruction.

#### **I-Type Instruction Table**

| **Instruction** | **funct3** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|------------|---------------------|------------------|
| ADDI             | 000        | 0010011             | 0x13            |
| SLTI             | 010        | 0010011             | 0x13            |
| SLTIU            | 011        | 0010011             | 0x13            |
| XORI             | 100        | 0010011             | 0x13            |
| ORI              | 110        | 0010011             | 0x13            |
| ANDI             | 111        | 0010011             | 0x13            |
| SLLI             | 001        | 0010011             | 0x13            |
| SRLI             | 101        | 0010011             | 0x13            |
| SRAI             | 101 (imm = 0100000) | 0010011 | 0x13            |

---

### **S-Type Instructions (Store Operations)**

```plaintext
| imm[11:5] (7 bits) | rs2 (5 bits) | rs1 (5 bits) | funct3 (3 bits) | imm[4:0] (5 bits) | opcode (7 bits) |
```


- **imm[11:0]**: Immediate value is split into two fields: `imm[11:5]` and `imm[4:0]`.
- **rs1**: Base address register.
- **rs2**: Source register to store.
- **funct3**: Instruction-specific field.
- **opcode**: Class of instruction.

#### **S-Type Instruction Table**

| **Instruction** | **funct3** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|------------|---------------------|------------------|
| SB               | 000        | 0100011             | 0x23            |
| SH               | 001        | 0100011             | 0x23            |
| SW               | 010        | 0100011             | 0x23            |

---

### **B-Type Instructions (Branch Operations)**
```plaintext
| imm[12] (1 bit) | imm[10:5] (6 bits) | rs2 (5 bits) | rs1 (5 bits) | funct3 (3 bits) | imm[4:1] (4 bits) | imm[11] (1 bit) | opcode (7 bits) |
```

- **imm[12:1]**: Immediate value is split and encoded in multiple fields.
- **rs1, rs2**: Registers to compare.
- **funct3**: Specifies the branch condition.
- **opcode**: Class of instruction.

#### **B-Type Instruction Table**

| **Instruction** | **funct3** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|------------|---------------------|------------------|
| BEQ              | 000        | 1100011             | 0x63            |
| BNE              | 001        | 1100011             | 0x63            |
| BLT              | 100        | 1100011             | 0x63            |
| BGE              | 101        | 1100011             | 0x63            |
| BLTU             | 110        | 1100011             | 0x63            |
| BGEU             | 111        | 1100011             | 0x63            |

---

### **U-Type Instructions (Upper Immediate Operations)**
```plaintext
| imm[31:12] (20 bits) | rd (5 bits) | opcode (7 bits) |
```

- **imm[31:12]**: Immediate value shifted left by 12 bits.
- **rd**: Destination register.
- **opcode**: Class of instruction.

#### **U-Type Instruction Table**

| **Instruction** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|---------------------|------------------|
| LUI              | 0110111             | 0x37            |
| AUIPC            | 0010111             | 0x17            |

---

### **J-Type Instructions (Jump Operations)**
```plaintext
| imm[20] (1 bit) | imm[10:1] (10 bits) | imm[11] (1 bit) | imm[19:12] (8 bits) | rd (5 bits) | opcode (7 bits) |
```

- **imm[20:1]**: Immediate value split into multiple fields.
- **rd**: Destination register.
- **opcode**: Specifies jump instructions.

#### **J-Type Instruction Table**

| **Instruction** | **Opcode (Binary)** | **Opcode (Hex)** |
|------------------|---------------------|------------------|
| JAL              | 1101111             | 0x6F            |

---

### **Special Instructions**

| **Instruction** | **Opcode (Binary)** | **Opcode (Hex)** | **funct3** | **funct7** |
|------------------|---------------------|------------------|------------|------------|
| JALR             | 1100111             | 0x67            | 000        | -          |
| FENCE            | 0001111             | 0x0F            | 000        | -          |
| ECALL            | 1110011             | 0x73            | 000        | 0000000    |
| EBREAK           | 1110011             | 0x73            | 000        | 0000001    |


