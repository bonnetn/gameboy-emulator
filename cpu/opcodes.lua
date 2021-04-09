--@name Opcodes
--@include gameboy/util.txt
--@include gameboy/memory/mmu.txt

require("gameboy/util.txt")
require("gameboy/memory/mmu.txt")
function register_opcodes(mem, reg)
local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift, inv8, inv16, add8to8, add8to16, add16to16, sub8to8, sub16to16, mmu_set, mmu_get, next16, register_a, register_af, register_b, register_bc, register_c, register_d, register_de, register_e, register_f, register_flag_cy, register_flag_h, register_flag_halt, register_flag_ime, register_flag_n, register_flag_zf, register_h, register_hl, register_l, register_pc, register_set_a, register_set_af, register_set_b, register_set_bc, register_set_c, register_set_d, register_set_de, register_set_e, register_set_f, register_set_flag_cy, register_set_flag_h, register_set_flag_halt, register_set_flag_ime, register_set_flag_n, register_set_flag_zf, register_set_h, register_set_hl, register_set_l, register_set_pc, register_set_sp, register_sp, register_unset_flag_cy, register_unset_flag_h, register_unset_flag_halt, register_unset_flag_ime, register_unset_flag_n, register_unset_flag_zf = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift, inv8, inv16, add8to8, add8to16, add16to16, sub8to8, sub16to16, mmu_set, mmu_get, next16, register_a, register_af, register_b, register_bc, register_c, register_d, register_de, register_e, register_f, register_flag_cy, register_flag_h, register_flag_halt, register_flag_ime, register_flag_n, register_flag_zf, register_h, register_hl, register_l, register_pc, register_set_a, register_set_af, register_set_b, register_set_bc, register_set_c, register_set_d, register_set_de, register_set_e, register_set_f, register_set_flag_cy, register_set_flag_h, register_set_flag_halt, register_set_flag_ime, register_set_flag_n, register_set_flag_zf, register_set_h, register_set_hl, register_set_l, register_set_pc, register_set_sp, register_sp, register_unset_flag_cy, register_unset_flag_h, register_unset_flag_halt, register_unset_flag_ime, register_unset_flag_n, register_unset_flag_zf
opcodes, opcodes_names = {
}, {
}
opcodes_names[1] = 'NOP'
opcodes[1] = function (reader_pos)
    -- NOP
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[2] = 'LD BC, d16'
opcodes[2] = function (reader_pos)
    -- LD BC, d16
    local var_1 = next16(mem, reader_pos)
    register_set_bc(reg, var_1)
    register_set_pc(reg, register_pc(reg) + 3)
    return 12
end
opcodes_names[3] = 'LD (BC), A'
opcodes[3] = function (reader_pos)
    -- LD (BC), A
    local var_2 = register_a(reg)
    mmu_set(mem, register_bc(reg), var_2)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[4] = 'INC BC'
opcodes[4] = function (reader_pos)
    -- INC BC
    local var_3 = register_bc(reg)
    local var_4 = add16to16(var_3, 1, reg, false, false)
    register_set_bc(reg, var_4)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[5] = 'INC B'
opcodes[5] = function (reader_pos)
    -- INC B
    local var_5 = register_b(reg)
    local var_6 = add8to8(var_5, 1, reg, true, false)
    register_set_b(reg, var_6)
    if var_6 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[6] = 'DEC B'
opcodes[6] = function (reader_pos)
    -- DEC B
    local var_7 = register_b(reg)
    local var_8 = sub8to8(var_7, 1, reg, true, false)
    register_set_b(reg, var_8)
    if var_8 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[7] = 'LD B, d8'
opcodes[7] = function (reader_pos)
    -- LD B, d8
    local var_9 = mmu_get(mem, reader_pos)
    register_set_b(reg, var_9)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[8] = 'RLCA'
opcodes[8] = function (reader_pos)
    -- RLCA
    local var_a = register_a(reg)
    local var_b = bit_lshift(var_a, 1)
    local var_c = bit_band(var_b, 255)
    if bit_band(var_b, 256) ~= 0 then
            var_c = bit_bor(var_c, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_c)
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[9] = 'LD (a16), SP'
opcodes[9] = function (reader_pos)
    -- LD (a16), SP
    local var_d = next16(mem, reader_pos)
    local var_e = register_sp(reg)
    mmu_set(mem, var_d, bit_band(var_e, 255))
    mmu_set(mem, var_d + 1, bit_rshift(var_e, 8))
    register_set_pc(reg, register_pc(reg) + 3)
    return 20
end
opcodes_names[10] = 'ADD HL, BC'
opcodes[10] = function (reader_pos)
    -- ADD HL, BC
    local var_f = register_bc(reg)
    local var_10 = register_hl(reg)
    local var_11 = add16to16(var_10, var_f, reg, true, true)
    register_set_hl(reg, var_11)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[11] = 'LD A, (BC)'
opcodes[11] = function (reader_pos)
    -- LD A, (BC)
    local var_12 = mmu_get(mem, register_bc(reg))
    register_set_a(reg, var_12)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[12] = 'DEC BC'
opcodes[12] = function (reader_pos)
    -- DEC BC
    local var_13 = register_bc(reg)
    local var_14 = sub16to16(var_13, 1, reg, false, false)
    register_set_bc(reg, var_14)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[13] = 'INC C'
opcodes[13] = function (reader_pos)
    -- INC C
    local var_15 = register_c(reg)
    local var_16 = add8to8(var_15, 1, reg, true, false)
    register_set_c(reg, var_16)
    if var_16 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[14] = 'DEC C'
opcodes[14] = function (reader_pos)
    -- DEC C
    local var_17 = register_c(reg)
    local var_18 = sub8to8(var_17, 1, reg, true, false)
    register_set_c(reg, var_18)
    if var_18 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[15] = 'LD C, d8'
opcodes[15] = function (reader_pos)
    -- LD C, d8
    local var_19 = mmu_get(mem, reader_pos)
    register_set_c(reg, var_19)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[16] = 'RRCA'
opcodes[16] = function (reader_pos)
    -- RRCA
    local var_1a = register_a(reg)
    local var_1b = bit_rshift(var_1a, 1)
    if bit_band(var_1a, 1) ~= 0 then
            var_1b = bit_bor(var_1b, 128)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_1b)
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[17] = 'STOP 0'
opcodes[17] = function (reader_pos)
    -- STOP 0
    error('STOP' .. reg:tostring())
    register_set_pc(reg, register_pc(reg) + 2)
    return 4
end
opcodes_names[18] = 'LD DE, d16'
opcodes[18] = function (reader_pos)
    -- LD DE, d16
    local var_1c = next16(mem, reader_pos)
    register_set_de(reg, var_1c)
    register_set_pc(reg, register_pc(reg) + 3)
    return 12
end
opcodes_names[19] = 'LD (DE), A'
opcodes[19] = function (reader_pos)
    -- LD (DE), A
    local var_1d = register_a(reg)
    mmu_set(mem, register_de(reg), var_1d)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[20] = 'INC DE'
opcodes[20] = function (reader_pos)
    -- INC DE
    local var_1e = register_de(reg)
    local var_1f = add16to16(var_1e, 1, reg, false, false)
    register_set_de(reg, var_1f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[21] = 'INC D'
opcodes[21] = function (reader_pos)
    -- INC D
    local var_20 = register_d(reg)
    local var_21 = add8to8(var_20, 1, reg, true, false)
    register_set_d(reg, var_21)
    if var_21 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[22] = 'DEC D'
opcodes[22] = function (reader_pos)
    -- DEC D
    local var_22 = register_d(reg)
    local var_23 = sub8to8(var_22, 1, reg, true, false)
    register_set_d(reg, var_23)
    if var_23 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[23] = 'LD D, d8'
opcodes[23] = function (reader_pos)
    -- LD D, d8
    local var_24 = mmu_get(mem, reader_pos)
    register_set_d(reg, var_24)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[24] = 'RLA'
opcodes[24] = function (reader_pos)
    -- RLA
    local var_25 = register_a(reg)
    local var_26 = bit_lshift(var_25, 1)
    if register_flag_cy(reg) then
            var_26 = bit_bor(var_26, 1)
    else

    end
    if bit_band(var_26, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, bit_band(var_26, 255))
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[25] = 'JR r8'
opcodes[25] = function (reader_pos)
    -- JR r8
    if false then
            register_set_pc(reg, register_pc(reg) + 2)
            return 12
    else

    end
    local var_27 = mmu_get(mem, reader_pos)
    register_set_pc(reg, add8to16(var_27, register_pc(reg), reg, false, false))
    register_set_pc(reg, register_pc(reg) + 2)
    return 12
end
opcodes_names[26] = 'ADD HL, DE'
opcodes[26] = function (reader_pos)
    -- ADD HL, DE
    local var_28 = register_de(reg)
    local var_29 = register_hl(reg)
    local var_2a = add16to16(var_29, var_28, reg, true, true)
    register_set_hl(reg, var_2a)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[27] = 'LD A, (DE)'
opcodes[27] = function (reader_pos)
    -- LD A, (DE)
    local var_2b = mmu_get(mem, register_de(reg))
    register_set_a(reg, var_2b)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[28] = 'DEC DE'
opcodes[28] = function (reader_pos)
    -- DEC DE
    local var_2c = register_de(reg)
    local var_2d = sub16to16(var_2c, 1, reg, false, false)
    register_set_de(reg, var_2d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[29] = 'INC E'
opcodes[29] = function (reader_pos)
    -- INC E
    local var_2e = register_e(reg)
    local var_2f = add8to8(var_2e, 1, reg, true, false)
    register_set_e(reg, var_2f)
    if var_2f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[30] = 'DEC E'
opcodes[30] = function (reader_pos)
    -- DEC E
    local var_30 = register_e(reg)
    local var_31 = sub8to8(var_30, 1, reg, true, false)
    register_set_e(reg, var_31)
    if var_31 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[31] = 'LD E, d8'
opcodes[31] = function (reader_pos)
    -- LD E, d8
    local var_32 = mmu_get(mem, reader_pos)
    register_set_e(reg, var_32)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[32] = 'RRA'
opcodes[32] = function (reader_pos)
    -- RRA
    local var_33 = register_a(reg)
    local var_34 = bit_rshift(var_33, 1)
    if register_flag_cy(reg) then
            var_34 = bit_bor(var_34, 128)
    else

    end
    if bit_band(var_33, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_34)
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[33] = 'JR NZ, r8'
opcodes[33] = function (reader_pos)
    -- JR NZ, r8
    if register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 2)
            return 12
    else

    end
    local var_35 = mmu_get(mem, reader_pos)
    register_set_pc(reg, add8to16(var_35, register_pc(reg), reg, false, false))
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[34] = 'LD HL, d16'
opcodes[34] = function (reader_pos)
    -- LD HL, d16
    local var_36 = next16(mem, reader_pos)
    register_set_hl(reg, var_36)
    register_set_pc(reg, register_pc(reg) + 3)
    return 12
end
opcodes_names[35] = 'LD (HL+), A'
opcodes[35] = function (reader_pos)
    -- LD (HL+), A
    local var_37 = register_a(reg)
    mmu_set(mem, register_hl(reg), var_37)
    register_set_hl(reg, bit_band(register_hl(reg) + 1, 65535))
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[36] = 'INC HL'
opcodes[36] = function (reader_pos)
    -- INC HL
    local var_38 = register_hl(reg)
    local var_39 = add16to16(var_38, 1, reg, false, false)
    register_set_hl(reg, var_39)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[37] = 'INC H'
opcodes[37] = function (reader_pos)
    -- INC H
    local var_3a = register_h(reg)
    local var_3b = add8to8(var_3a, 1, reg, true, false)
    register_set_h(reg, var_3b)
    if var_3b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[38] = 'DEC H'
opcodes[38] = function (reader_pos)
    -- DEC H
    local var_3c = register_h(reg)
    local var_3d = sub8to8(var_3c, 1, reg, true, false)
    register_set_h(reg, var_3d)
    if var_3d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[39] = 'LD H, d8'
opcodes[39] = function (reader_pos)
    -- LD H, d8
    local var_3e = mmu_get(mem, reader_pos)
    register_set_h(reg, var_3e)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[40] = 'DAA'
opcodes[40] = function (reader_pos)
    -- DAA
    if not register_flag_n(reg) then
            if register_flag_cy(reg) or register_a(reg) > 153 then
                        register_set_a(reg, bit_band(255, register_a(reg) + 96))
                        register_set_flag_cy(reg)
            else

            end
            if register_flag_h(reg) or bit_band(register_a(reg), 15) > 9 then
                        register_set_a(reg, bit_band(255, register_a(reg) + 6))
            else

            end
    else
            if register_flag_cy(reg) then
                        register_set_a(reg, bit_band(255, register_a(reg) + 160))
            else

            end
            if register_flag_h(reg) then
                        register_set_a(reg, bit_band(255, register_a(reg) + 250))
            else

            end
    end
    if register_a(reg) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_unset_flag_h(reg)
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[41] = 'JR Z, r8'
opcodes[41] = function (reader_pos)
    -- JR Z, r8
    if not register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 2)
            return 12
    else

    end
    local var_3f = mmu_get(mem, reader_pos)
    register_set_pc(reg, add8to16(var_3f, register_pc(reg), reg, false, false))
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[42] = 'ADD HL, HL'
opcodes[42] = function (reader_pos)
    -- ADD HL, HL
    local var_40 = register_hl(reg)
    local var_41 = register_hl(reg)
    local var_42 = add16to16(var_41, var_40, reg, true, true)
    register_set_hl(reg, var_42)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[43] = 'LD A, (HL+)'
opcodes[43] = function (reader_pos)
    -- LD A, (HL+)
    local var_43 = mmu_get(mem, register_hl(reg))
    register_set_a(reg, var_43)
    register_set_hl(reg, bit_band(register_hl(reg) + 1, 65535))
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[44] = 'DEC HL'
opcodes[44] = function (reader_pos)
    -- DEC HL
    local var_44 = register_hl(reg)
    local var_45 = sub16to16(var_44, 1, reg, false, false)
    register_set_hl(reg, var_45)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[45] = 'INC L'
opcodes[45] = function (reader_pos)
    -- INC L
    local var_46 = register_l(reg)
    local var_47 = add8to8(var_46, 1, reg, true, false)
    register_set_l(reg, var_47)
    if var_47 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[46] = 'DEC L'
opcodes[46] = function (reader_pos)
    -- DEC L
    local var_48 = register_l(reg)
    local var_49 = sub8to8(var_48, 1, reg, true, false)
    register_set_l(reg, var_49)
    if var_49 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[47] = 'LD L, d8'
opcodes[47] = function (reader_pos)
    -- LD L, d8
    local var_4a = mmu_get(mem, reader_pos)
    register_set_l(reg, var_4a)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[48] = 'CPL'
opcodes[48] = function (reader_pos)
    -- CPL
    local var_4b = register_a(reg)
    register_set_a(reg, bit_bxor(var_4b, 255))
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    register_set_flag_h(reg)
    return 4
end
opcodes_names[49] = 'JR NC, r8'
opcodes[49] = function (reader_pos)
    -- JR NC, r8
    if register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 2)
            return 12
    else

    end
    local var_4c = mmu_get(mem, reader_pos)
    register_set_pc(reg, add8to16(var_4c, register_pc(reg), reg, false, false))
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[50] = 'LD SP, d16'
opcodes[50] = function (reader_pos)
    -- LD SP, d16
    local var_4d = next16(mem, reader_pos)
    register_set_sp(reg, var_4d)
    register_set_pc(reg, register_pc(reg) + 3)
    return 12
end
opcodes_names[51] = 'LD (HL-), A'
opcodes[51] = function (reader_pos)
    -- LD (HL-), A
    local var_4e = register_a(reg)
    mmu_set(mem, register_hl(reg), var_4e)
    register_set_hl(reg, bit_band(register_hl(reg) - 1, 65535))
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[52] = 'INC SP'
opcodes[52] = function (reader_pos)
    -- INC SP
    local var_4f = register_sp(reg)
    local var_50 = add16to16(var_4f, 1, reg, false, false)
    register_set_sp(reg, var_50)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[53] = 'INC (HL)'
opcodes[53] = function (reader_pos)
    -- INC (HL)
    local var_51 = mmu_get(mem, register_hl(reg))
    local var_52 = add8to8(var_51, 1, reg, true, false)
    mmu_set(mem, register_hl(reg), var_52)
    if var_52 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 12
end
opcodes_names[54] = 'DEC (HL)'
opcodes[54] = function (reader_pos)
    -- DEC (HL)
    local var_53 = mmu_get(mem, register_hl(reg))
    local var_54 = sub8to8(var_53, 1, reg, true, false)
    mmu_set(mem, register_hl(reg), var_54)
    if var_54 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 12
end
opcodes_names[55] = 'LD (HL), d8'
opcodes[55] = function (reader_pos)
    -- LD (HL), d8
    local var_55 = mmu_get(mem, reader_pos)
    mmu_set(mem, register_hl(reg), var_55)
    register_set_pc(reg, register_pc(reg) + 2)
    return 12
end
opcodes_names[56] = 'SCF'
opcodes[56] = function (reader_pos)
    -- SCF
    register_unset_flag_cy(reg)
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_set_flag_cy(reg)
    return 4
end
opcodes_names[57] = 'JR C, r8'
opcodes[57] = function (reader_pos)
    -- JR C, r8
    if not register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 2)
            return 12
    else

    end
    local var_56 = mmu_get(mem, reader_pos)
    register_set_pc(reg, add8to16(var_56, register_pc(reg), reg, false, false))
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[58] = 'ADD HL, SP'
opcodes[58] = function (reader_pos)
    -- ADD HL, SP
    local var_57 = register_sp(reg)
    local var_58 = register_hl(reg)
    local var_59 = add16to16(var_58, var_57, reg, true, true)
    register_set_hl(reg, var_59)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[59] = 'LD A, (HL-)'
opcodes[59] = function (reader_pos)
    -- LD A, (HL-)
    local var_5a = mmu_get(mem, register_hl(reg))
    register_set_a(reg, var_5a)
    register_set_hl(reg, bit_band(register_hl(reg) - 1, 65535))
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[60] = 'DEC SP'
opcodes[60] = function (reader_pos)
    -- DEC SP
    local var_5b = register_sp(reg)
    local var_5c = sub16to16(var_5b, 1, reg, false, false)
    register_set_sp(reg, var_5c)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[61] = 'INC A'
opcodes[61] = function (reader_pos)
    -- INC A
    local var_5d = register_a(reg)
    local var_5e = add8to8(var_5d, 1, reg, true, false)
    register_set_a(reg, var_5e)
    if var_5e == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[62] = 'DEC A'
opcodes[62] = function (reader_pos)
    -- DEC A
    local var_5f = register_a(reg)
    local var_60 = sub8to8(var_5f, 1, reg, true, false)
    register_set_a(reg, var_60)
    if var_60 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[63] = 'LD A, d8'
opcodes[63] = function (reader_pos)
    -- LD A, d8
    local var_61 = mmu_get(mem, reader_pos)
    register_set_a(reg, var_61)
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes_names[64] = 'CCF'
opcodes[64] = function (reader_pos)
    -- CCF
    if register_flag_cy(reg) then
            register_unset_flag_cy(reg)
    else
            register_set_flag_cy(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 4
end
opcodes_names[65] = 'LD B, B'
opcodes[65] = function (reader_pos)
    -- LD B, B
    local var_62 = register_b(reg)
    register_set_b(reg, var_62)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[66] = 'LD B, C'
opcodes[66] = function (reader_pos)
    -- LD B, C
    local var_63 = register_c(reg)
    register_set_b(reg, var_63)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[67] = 'LD B, D'
opcodes[67] = function (reader_pos)
    -- LD B, D
    local var_64 = register_d(reg)
    register_set_b(reg, var_64)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[68] = 'LD B, E'
opcodes[68] = function (reader_pos)
    -- LD B, E
    local var_65 = register_e(reg)
    register_set_b(reg, var_65)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[69] = 'LD B, H'
opcodes[69] = function (reader_pos)
    -- LD B, H
    local var_66 = register_h(reg)
    register_set_b(reg, var_66)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[70] = 'LD B, L'
opcodes[70] = function (reader_pos)
    -- LD B, L
    local var_67 = register_l(reg)
    register_set_b(reg, var_67)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[71] = 'LD B, (HL)'
opcodes[71] = function (reader_pos)
    -- LD B, (HL)
    local var_68 = mmu_get(mem, register_hl(reg))
    register_set_b(reg, var_68)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[72] = 'LD B, A'
opcodes[72] = function (reader_pos)
    -- LD B, A
    local var_69 = register_a(reg)
    register_set_b(reg, var_69)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[73] = 'LD C, B'
opcodes[73] = function (reader_pos)
    -- LD C, B
    local var_6a = register_b(reg)
    register_set_c(reg, var_6a)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[74] = 'LD C, C'
opcodes[74] = function (reader_pos)
    -- LD C, C
    local var_6b = register_c(reg)
    register_set_c(reg, var_6b)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[75] = 'LD C, D'
opcodes[75] = function (reader_pos)
    -- LD C, D
    local var_6c = register_d(reg)
    register_set_c(reg, var_6c)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[76] = 'LD C, E'
opcodes[76] = function (reader_pos)
    -- LD C, E
    local var_6d = register_e(reg)
    register_set_c(reg, var_6d)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[77] = 'LD C, H'
opcodes[77] = function (reader_pos)
    -- LD C, H
    local var_6e = register_h(reg)
    register_set_c(reg, var_6e)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[78] = 'LD C, L'
opcodes[78] = function (reader_pos)
    -- LD C, L
    local var_6f = register_l(reg)
    register_set_c(reg, var_6f)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[79] = 'LD C, (HL)'
opcodes[79] = function (reader_pos)
    -- LD C, (HL)
    local var_70 = mmu_get(mem, register_hl(reg))
    register_set_c(reg, var_70)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[80] = 'LD C, A'
opcodes[80] = function (reader_pos)
    -- LD C, A
    local var_71 = register_a(reg)
    register_set_c(reg, var_71)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[81] = 'LD D, B'
opcodes[81] = function (reader_pos)
    -- LD D, B
    local var_72 = register_b(reg)
    register_set_d(reg, var_72)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[82] = 'LD D, C'
opcodes[82] = function (reader_pos)
    -- LD D, C
    local var_73 = register_c(reg)
    register_set_d(reg, var_73)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[83] = 'LD D, D'
opcodes[83] = function (reader_pos)
    -- LD D, D
    local var_74 = register_d(reg)
    register_set_d(reg, var_74)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[84] = 'LD D, E'
opcodes[84] = function (reader_pos)
    -- LD D, E
    local var_75 = register_e(reg)
    register_set_d(reg, var_75)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[85] = 'LD D, H'
opcodes[85] = function (reader_pos)
    -- LD D, H
    local var_76 = register_h(reg)
    register_set_d(reg, var_76)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[86] = 'LD D, L'
opcodes[86] = function (reader_pos)
    -- LD D, L
    local var_77 = register_l(reg)
    register_set_d(reg, var_77)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[87] = 'LD D, (HL)'
opcodes[87] = function (reader_pos)
    -- LD D, (HL)
    local var_78 = mmu_get(mem, register_hl(reg))
    register_set_d(reg, var_78)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[88] = 'LD D, A'
opcodes[88] = function (reader_pos)
    -- LD D, A
    local var_79 = register_a(reg)
    register_set_d(reg, var_79)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[89] = 'LD E, B'
opcodes[89] = function (reader_pos)
    -- LD E, B
    local var_7a = register_b(reg)
    register_set_e(reg, var_7a)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[90] = 'LD E, C'
opcodes[90] = function (reader_pos)
    -- LD E, C
    local var_7b = register_c(reg)
    register_set_e(reg, var_7b)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[91] = 'LD E, D'
opcodes[91] = function (reader_pos)
    -- LD E, D
    local var_7c = register_d(reg)
    register_set_e(reg, var_7c)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[92] = 'LD E, E'
opcodes[92] = function (reader_pos)
    -- LD E, E
    local var_7d = register_e(reg)
    register_set_e(reg, var_7d)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[93] = 'LD E, H'
opcodes[93] = function (reader_pos)
    -- LD E, H
    local var_7e = register_h(reg)
    register_set_e(reg, var_7e)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[94] = 'LD E, L'
opcodes[94] = function (reader_pos)
    -- LD E, L
    local var_7f = register_l(reg)
    register_set_e(reg, var_7f)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[95] = 'LD E, (HL)'
opcodes[95] = function (reader_pos)
    -- LD E, (HL)
    local var_80 = mmu_get(mem, register_hl(reg))
    register_set_e(reg, var_80)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[96] = 'LD E, A'
opcodes[96] = function (reader_pos)
    -- LD E, A
    local var_81 = register_a(reg)
    register_set_e(reg, var_81)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[97] = 'LD H, B'
opcodes[97] = function (reader_pos)
    -- LD H, B
    local var_82 = register_b(reg)
    register_set_h(reg, var_82)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[98] = 'LD H, C'
opcodes[98] = function (reader_pos)
    -- LD H, C
    local var_83 = register_c(reg)
    register_set_h(reg, var_83)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[99] = 'LD H, D'
opcodes[99] = function (reader_pos)
    -- LD H, D
    local var_84 = register_d(reg)
    register_set_h(reg, var_84)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[100] = 'LD H, E'
opcodes[100] = function (reader_pos)
    -- LD H, E
    local var_85 = register_e(reg)
    register_set_h(reg, var_85)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[101] = 'LD H, H'
opcodes[101] = function (reader_pos)
    -- LD H, H
    local var_86 = register_h(reg)
    register_set_h(reg, var_86)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[102] = 'LD H, L'
opcodes[102] = function (reader_pos)
    -- LD H, L
    local var_87 = register_l(reg)
    register_set_h(reg, var_87)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[103] = 'LD H, (HL)'
opcodes[103] = function (reader_pos)
    -- LD H, (HL)
    local var_88 = mmu_get(mem, register_hl(reg))
    register_set_h(reg, var_88)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[104] = 'LD H, A'
opcodes[104] = function (reader_pos)
    -- LD H, A
    local var_89 = register_a(reg)
    register_set_h(reg, var_89)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[105] = 'LD L, B'
opcodes[105] = function (reader_pos)
    -- LD L, B
    local var_8a = register_b(reg)
    register_set_l(reg, var_8a)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[106] = 'LD L, C'
opcodes[106] = function (reader_pos)
    -- LD L, C
    local var_8b = register_c(reg)
    register_set_l(reg, var_8b)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[107] = 'LD L, D'
opcodes[107] = function (reader_pos)
    -- LD L, D
    local var_8c = register_d(reg)
    register_set_l(reg, var_8c)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[108] = 'LD L, E'
opcodes[108] = function (reader_pos)
    -- LD L, E
    local var_8d = register_e(reg)
    register_set_l(reg, var_8d)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[109] = 'LD L, H'
opcodes[109] = function (reader_pos)
    -- LD L, H
    local var_8e = register_h(reg)
    register_set_l(reg, var_8e)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[110] = 'LD L, L'
opcodes[110] = function (reader_pos)
    -- LD L, L
    local var_8f = register_l(reg)
    register_set_l(reg, var_8f)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[111] = 'LD L, (HL)'
opcodes[111] = function (reader_pos)
    -- LD L, (HL)
    local var_90 = mmu_get(mem, register_hl(reg))
    register_set_l(reg, var_90)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[112] = 'LD L, A'
opcodes[112] = function (reader_pos)
    -- LD L, A
    local var_91 = register_a(reg)
    register_set_l(reg, var_91)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[113] = 'LD (HL), B'
opcodes[113] = function (reader_pos)
    -- LD (HL), B
    local var_92 = register_b(reg)
    mmu_set(mem, register_hl(reg), var_92)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[114] = 'LD (HL), C'
opcodes[114] = function (reader_pos)
    -- LD (HL), C
    local var_93 = register_c(reg)
    mmu_set(mem, register_hl(reg), var_93)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[115] = 'LD (HL), D'
opcodes[115] = function (reader_pos)
    -- LD (HL), D
    local var_94 = register_d(reg)
    mmu_set(mem, register_hl(reg), var_94)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[116] = 'LD (HL), E'
opcodes[116] = function (reader_pos)
    -- LD (HL), E
    local var_95 = register_e(reg)
    mmu_set(mem, register_hl(reg), var_95)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[117] = 'LD (HL), H'
opcodes[117] = function (reader_pos)
    -- LD (HL), H
    local var_96 = register_h(reg)
    mmu_set(mem, register_hl(reg), var_96)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[118] = 'LD (HL), L'
opcodes[118] = function (reader_pos)
    -- LD (HL), L
    local var_97 = register_l(reg)
    mmu_set(mem, register_hl(reg), var_97)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[119] = 'HALT'
opcodes[119] = function (reader_pos)
    -- HALT
    register_set_flag_halt(reg)
    return 4
end
opcodes_names[120] = 'LD (HL), A'
opcodes[120] = function (reader_pos)
    -- LD (HL), A
    local var_98 = register_a(reg)
    mmu_set(mem, register_hl(reg), var_98)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[121] = 'LD A, B'
opcodes[121] = function (reader_pos)
    -- LD A, B
    local var_99 = register_b(reg)
    register_set_a(reg, var_99)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[122] = 'LD A, C'
opcodes[122] = function (reader_pos)
    -- LD A, C
    local var_9a = register_c(reg)
    register_set_a(reg, var_9a)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[123] = 'LD A, D'
opcodes[123] = function (reader_pos)
    -- LD A, D
    local var_9b = register_d(reg)
    register_set_a(reg, var_9b)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[124] = 'LD A, E'
opcodes[124] = function (reader_pos)
    -- LD A, E
    local var_9c = register_e(reg)
    register_set_a(reg, var_9c)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[125] = 'LD A, H'
opcodes[125] = function (reader_pos)
    -- LD A, H
    local var_9d = register_h(reg)
    register_set_a(reg, var_9d)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[126] = 'LD A, L'
opcodes[126] = function (reader_pos)
    -- LD A, L
    local var_9e = register_l(reg)
    register_set_a(reg, var_9e)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[127] = 'LD A, (HL)'
opcodes[127] = function (reader_pos)
    -- LD A, (HL)
    local var_9f = mmu_get(mem, register_hl(reg))
    register_set_a(reg, var_9f)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[128] = 'LD A, A'
opcodes[128] = function (reader_pos)
    -- LD A, A
    local var_a0 = register_a(reg)
    register_set_a(reg, var_a0)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[129] = 'ADD A, B'
opcodes[129] = function (reader_pos)
    -- ADD A, B
    local var_a1 = register_b(reg)
    local var_a2 = register_a(reg)
    local var_a3 = add8to8(var_a2, var_a1, reg, true, true)
    register_set_a(reg, var_a3)
    if var_a3 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[130] = 'ADD A, C'
opcodes[130] = function (reader_pos)
    -- ADD A, C
    local var_a4 = register_c(reg)
    local var_a5 = register_a(reg)
    local var_a6 = add8to8(var_a5, var_a4, reg, true, true)
    register_set_a(reg, var_a6)
    if var_a6 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[131] = 'ADD A, D'
opcodes[131] = function (reader_pos)
    -- ADD A, D
    local var_a7 = register_d(reg)
    local var_a8 = register_a(reg)
    local var_a9 = add8to8(var_a8, var_a7, reg, true, true)
    register_set_a(reg, var_a9)
    if var_a9 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[132] = 'ADD A, E'
opcodes[132] = function (reader_pos)
    -- ADD A, E
    local var_aa = register_e(reg)
    local var_ab = register_a(reg)
    local var_ac = add8to8(var_ab, var_aa, reg, true, true)
    register_set_a(reg, var_ac)
    if var_ac == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[133] = 'ADD A, H'
opcodes[133] = function (reader_pos)
    -- ADD A, H
    local var_ad = register_h(reg)
    local var_ae = register_a(reg)
    local var_af = add8to8(var_ae, var_ad, reg, true, true)
    register_set_a(reg, var_af)
    if var_af == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[134] = 'ADD A, L'
opcodes[134] = function (reader_pos)
    -- ADD A, L
    local var_b0 = register_l(reg)
    local var_b1 = register_a(reg)
    local var_b2 = add8to8(var_b1, var_b0, reg, true, true)
    register_set_a(reg, var_b2)
    if var_b2 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[135] = 'ADD A, (HL)'
opcodes[135] = function (reader_pos)
    -- ADD A, (HL)
    local var_b3 = mmu_get(mem, register_hl(reg))
    local var_b4 = register_a(reg)
    local var_b5 = add8to8(var_b4, var_b3, reg, true, true)
    register_set_a(reg, var_b5)
    if var_b5 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[136] = 'ADD A, A'
opcodes[136] = function (reader_pos)
    -- ADD A, A
    local var_b6 = register_a(reg)
    local var_b7 = register_a(reg)
    local var_b8 = add8to8(var_b7, var_b6, reg, true, true)
    register_set_a(reg, var_b8)
    if var_b8 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[137] = 'ADC A, B'
opcodes[137] = function (reader_pos)
    -- ADC A, B
    local var_b9 = register_b(reg)
    local var_ba = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_bb = add8to8(var_ba, var_b9, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_bb = add8to8(var_bb, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_bb)
    if var_bb == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[138] = 'ADC A, C'
opcodes[138] = function (reader_pos)
    -- ADC A, C
    local var_bc = register_c(reg)
    local var_bd = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_be = add8to8(var_bd, var_bc, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_be = add8to8(var_be, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_be)
    if var_be == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[139] = 'ADC A, D'
opcodes[139] = function (reader_pos)
    -- ADC A, D
    local var_bf = register_d(reg)
    local var_c0 = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_c1 = add8to8(var_c0, var_bf, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_c1 = add8to8(var_c1, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_c1)
    if var_c1 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[140] = 'ADC A, E'
opcodes[140] = function (reader_pos)
    -- ADC A, E
    local var_c2 = register_e(reg)
    local var_c3 = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_c4 = add8to8(var_c3, var_c2, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_c4 = add8to8(var_c4, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_c4)
    if var_c4 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[141] = 'ADC A, H'
opcodes[141] = function (reader_pos)
    -- ADC A, H
    local var_c5 = register_h(reg)
    local var_c6 = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_c7 = add8to8(var_c6, var_c5, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_c7 = add8to8(var_c7, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_c7)
    if var_c7 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[142] = 'ADC A, L'
opcodes[142] = function (reader_pos)
    -- ADC A, L
    local var_c8 = register_l(reg)
    local var_c9 = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_ca = add8to8(var_c9, var_c8, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_ca = add8to8(var_ca, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_ca)
    if var_ca == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[143] = 'ADC A, (HL)'
opcodes[143] = function (reader_pos)
    -- ADC A, (HL)
    local var_cb = mmu_get(mem, register_hl(reg))
    local var_cc = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_cd = add8to8(var_cc, var_cb, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_cd = add8to8(var_cd, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_cd)
    if var_cd == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[144] = 'ADC A, A'
opcodes[144] = function (reader_pos)
    -- ADC A, A
    local var_ce = register_a(reg)
    local var_cf = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_d0 = add8to8(var_cf, var_ce, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_d0 = add8to8(var_d0, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_d0)
    if var_d0 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    return 4
end
opcodes_names[145] = 'SUB B'
opcodes[145] = function (reader_pos)
    -- SUB B
    local var_d1 = register_b(reg)
    local var_d2 = register_a(reg)
    local var_d3 = sub8to8(var_d2, var_d1, reg, true, true)
    register_set_a(reg, var_d3)
    if var_d3 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[146] = 'SUB C'
opcodes[146] = function (reader_pos)
    -- SUB C
    local var_d4 = register_c(reg)
    local var_d5 = register_a(reg)
    local var_d6 = sub8to8(var_d5, var_d4, reg, true, true)
    register_set_a(reg, var_d6)
    if var_d6 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[147] = 'SUB D'
opcodes[147] = function (reader_pos)
    -- SUB D
    local var_d7 = register_d(reg)
    local var_d8 = register_a(reg)
    local var_d9 = sub8to8(var_d8, var_d7, reg, true, true)
    register_set_a(reg, var_d9)
    if var_d9 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[148] = 'SUB E'
opcodes[148] = function (reader_pos)
    -- SUB E
    local var_da = register_e(reg)
    local var_db = register_a(reg)
    local var_dc = sub8to8(var_db, var_da, reg, true, true)
    register_set_a(reg, var_dc)
    if var_dc == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[149] = 'SUB H'
opcodes[149] = function (reader_pos)
    -- SUB H
    local var_dd = register_h(reg)
    local var_de = register_a(reg)
    local var_df = sub8to8(var_de, var_dd, reg, true, true)
    register_set_a(reg, var_df)
    if var_df == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[150] = 'SUB L'
opcodes[150] = function (reader_pos)
    -- SUB L
    local var_e0 = register_l(reg)
    local var_e1 = register_a(reg)
    local var_e2 = sub8to8(var_e1, var_e0, reg, true, true)
    register_set_a(reg, var_e2)
    if var_e2 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[151] = 'SUB (HL)'
opcodes[151] = function (reader_pos)
    -- SUB (HL)
    local var_e3 = mmu_get(mem, register_hl(reg))
    local var_e4 = register_a(reg)
    local var_e5 = sub8to8(var_e4, var_e3, reg, true, true)
    register_set_a(reg, var_e5)
    if var_e5 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[152] = 'SUB A'
opcodes[152] = function (reader_pos)
    -- SUB A
    local var_e6 = register_a(reg)
    local var_e7 = register_a(reg)
    local var_e8 = sub8to8(var_e7, var_e6, reg, true, true)
    register_set_a(reg, var_e8)
    if var_e8 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[153] = 'SBC A, B'
opcodes[153] = function (reader_pos)
    -- SBC A, B
    local var_e9 = register_a(reg)
    local var_ea = register_b(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_eb = sub8to8(var_e9, var_ea, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_eb = sub8to8(var_eb, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_eb)
    if var_eb == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[154] = 'SBC A, C'
opcodes[154] = function (reader_pos)
    -- SBC A, C
    local var_ec = register_a(reg)
    local var_ed = register_c(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_ee = sub8to8(var_ec, var_ed, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_ee = sub8to8(var_ee, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_ee)
    if var_ee == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[155] = 'SBC A, D'
opcodes[155] = function (reader_pos)
    -- SBC A, D
    local var_ef = register_a(reg)
    local var_f0 = register_d(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_f1 = sub8to8(var_ef, var_f0, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_f1 = sub8to8(var_f1, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_f1)
    if var_f1 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[156] = 'SBC A, E'
opcodes[156] = function (reader_pos)
    -- SBC A, E
    local var_f2 = register_a(reg)
    local var_f3 = register_e(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_f4 = sub8to8(var_f2, var_f3, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_f4 = sub8to8(var_f4, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_f4)
    if var_f4 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[157] = 'SBC A, H'
opcodes[157] = function (reader_pos)
    -- SBC A, H
    local var_f5 = register_a(reg)
    local var_f6 = register_h(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_f7 = sub8to8(var_f5, var_f6, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_f7 = sub8to8(var_f7, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_f7)
    if var_f7 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[158] = 'SBC A, L'
opcodes[158] = function (reader_pos)
    -- SBC A, L
    local var_f8 = register_a(reg)
    local var_f9 = register_l(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_fa = sub8to8(var_f8, var_f9, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_fa = sub8to8(var_fa, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_fa)
    if var_fa == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[159] = 'SBC A, (HL)'
opcodes[159] = function (reader_pos)
    -- SBC A, (HL)
    local var_fb = register_a(reg)
    local var_fc = mmu_get(mem, register_hl(reg))
    local should_add_carry = register_flag_cy(reg)
    local var_fd = sub8to8(var_fb, var_fc, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_fd = sub8to8(var_fd, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_fd)
    if var_fd == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[160] = 'SBC A, A'
opcodes[160] = function (reader_pos)
    -- SBC A, A
    local var_fe = register_a(reg)
    local var_ff = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_100 = sub8to8(var_fe, var_ff, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_100 = sub8to8(var_100, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_100)
    if var_100 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[161] = 'AND B'
opcodes[161] = function (reader_pos)
    -- AND B
    local var_101 = register_b(reg)
    local var_102 = register_a(reg)
    local var_103 = bit_band(var_101, var_102)
    register_set_a(reg, var_103)
    if var_103 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[162] = 'AND C'
opcodes[162] = function (reader_pos)
    -- AND C
    local var_104 = register_c(reg)
    local var_105 = register_a(reg)
    local var_106 = bit_band(var_104, var_105)
    register_set_a(reg, var_106)
    if var_106 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[163] = 'AND D'
opcodes[163] = function (reader_pos)
    -- AND D
    local var_107 = register_d(reg)
    local var_108 = register_a(reg)
    local var_109 = bit_band(var_107, var_108)
    register_set_a(reg, var_109)
    if var_109 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[164] = 'AND E'
opcodes[164] = function (reader_pos)
    -- AND E
    local var_10a = register_e(reg)
    local var_10b = register_a(reg)
    local var_10c = bit_band(var_10a, var_10b)
    register_set_a(reg, var_10c)
    if var_10c == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[165] = 'AND H'
opcodes[165] = function (reader_pos)
    -- AND H
    local var_10d = register_h(reg)
    local var_10e = register_a(reg)
    local var_10f = bit_band(var_10d, var_10e)
    register_set_a(reg, var_10f)
    if var_10f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[166] = 'AND L'
opcodes[166] = function (reader_pos)
    -- AND L
    local var_110 = register_l(reg)
    local var_111 = register_a(reg)
    local var_112 = bit_band(var_110, var_111)
    register_set_a(reg, var_112)
    if var_112 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[167] = 'AND (HL)'
opcodes[167] = function (reader_pos)
    -- AND (HL)
    local var_113 = mmu_get(mem, register_hl(reg))
    local var_114 = register_a(reg)
    local var_115 = bit_band(var_113, var_114)
    register_set_a(reg, var_115)
    if var_115 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[168] = 'AND A'
opcodes[168] = function (reader_pos)
    -- AND A
    local var_116 = register_a(reg)
    local var_117 = register_a(reg)
    local var_118 = bit_band(var_116, var_117)
    register_set_a(reg, var_118)
    if var_118 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[169] = 'XOR B'
opcodes[169] = function (reader_pos)
    -- XOR B
    local var_119 = register_b(reg)
    local var_11a = register_a(reg)
    local var_11b = bit_bxor(var_119, var_11a)
    register_set_a(reg, var_11b)
    if var_11b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[170] = 'XOR C'
opcodes[170] = function (reader_pos)
    -- XOR C
    local var_11c = register_c(reg)
    local var_11d = register_a(reg)
    local var_11e = bit_bxor(var_11c, var_11d)
    register_set_a(reg, var_11e)
    if var_11e == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[171] = 'XOR D'
opcodes[171] = function (reader_pos)
    -- XOR D
    local var_11f = register_d(reg)
    local var_120 = register_a(reg)
    local var_121 = bit_bxor(var_11f, var_120)
    register_set_a(reg, var_121)
    if var_121 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[172] = 'XOR E'
opcodes[172] = function (reader_pos)
    -- XOR E
    local var_122 = register_e(reg)
    local var_123 = register_a(reg)
    local var_124 = bit_bxor(var_122, var_123)
    register_set_a(reg, var_124)
    if var_124 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[173] = 'XOR H'
opcodes[173] = function (reader_pos)
    -- XOR H
    local var_125 = register_h(reg)
    local var_126 = register_a(reg)
    local var_127 = bit_bxor(var_125, var_126)
    register_set_a(reg, var_127)
    if var_127 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[174] = 'XOR L'
opcodes[174] = function (reader_pos)
    -- XOR L
    local var_128 = register_l(reg)
    local var_129 = register_a(reg)
    local var_12a = bit_bxor(var_128, var_129)
    register_set_a(reg, var_12a)
    if var_12a == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[175] = 'XOR (HL)'
opcodes[175] = function (reader_pos)
    -- XOR (HL)
    local var_12b = mmu_get(mem, register_hl(reg))
    local var_12c = register_a(reg)
    local var_12d = bit_bxor(var_12b, var_12c)
    register_set_a(reg, var_12d)
    if var_12d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[176] = 'XOR A'
opcodes[176] = function (reader_pos)
    -- XOR A
    local var_12e = register_a(reg)
    local var_12f = register_a(reg)
    local var_130 = bit_bxor(var_12e, var_12f)
    register_set_a(reg, var_130)
    if var_130 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[177] = 'OR B'
opcodes[177] = function (reader_pos)
    -- OR B
    local var_131 = register_b(reg)
    local var_132 = register_a(reg)
    local var_133 = bit_bor(var_131, var_132)
    register_set_a(reg, var_133)
    if var_133 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[178] = 'OR C'
opcodes[178] = function (reader_pos)
    -- OR C
    local var_134 = register_c(reg)
    local var_135 = register_a(reg)
    local var_136 = bit_bor(var_134, var_135)
    register_set_a(reg, var_136)
    if var_136 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[179] = 'OR D'
opcodes[179] = function (reader_pos)
    -- OR D
    local var_137 = register_d(reg)
    local var_138 = register_a(reg)
    local var_139 = bit_bor(var_137, var_138)
    register_set_a(reg, var_139)
    if var_139 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[180] = 'OR E'
opcodes[180] = function (reader_pos)
    -- OR E
    local var_13a = register_e(reg)
    local var_13b = register_a(reg)
    local var_13c = bit_bor(var_13a, var_13b)
    register_set_a(reg, var_13c)
    if var_13c == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[181] = 'OR H'
opcodes[181] = function (reader_pos)
    -- OR H
    local var_13d = register_h(reg)
    local var_13e = register_a(reg)
    local var_13f = bit_bor(var_13d, var_13e)
    register_set_a(reg, var_13f)
    if var_13f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[182] = 'OR L'
opcodes[182] = function (reader_pos)
    -- OR L
    local var_140 = register_l(reg)
    local var_141 = register_a(reg)
    local var_142 = bit_bor(var_140, var_141)
    register_set_a(reg, var_142)
    if var_142 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[183] = 'OR (HL)'
opcodes[183] = function (reader_pos)
    -- OR (HL)
    local var_143 = mmu_get(mem, register_hl(reg))
    local var_144 = register_a(reg)
    local var_145 = bit_bor(var_143, var_144)
    register_set_a(reg, var_145)
    if var_145 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[184] = 'OR A'
opcodes[184] = function (reader_pos)
    -- OR A
    local var_146 = register_a(reg)
    local var_147 = register_a(reg)
    local var_148 = bit_bor(var_146, var_147)
    register_set_a(reg, var_148)
    if var_148 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 4
end
opcodes_names[185] = 'CP B'
opcodes[185] = function (reader_pos)
    -- CP B
    local var_149 = register_b(reg)
    local var_14a = register_a(reg)
    sub8to8(var_14a, var_149, reg, true, true)
    if var_14a == var_149 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[186] = 'CP C'
opcodes[186] = function (reader_pos)
    -- CP C
    local var_14b = register_c(reg)
    local var_14c = register_a(reg)
    sub8to8(var_14c, var_14b, reg, true, true)
    if var_14c == var_14b then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[187] = 'CP D'
opcodes[187] = function (reader_pos)
    -- CP D
    local var_14d = register_d(reg)
    local var_14e = register_a(reg)
    sub8to8(var_14e, var_14d, reg, true, true)
    if var_14e == var_14d then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[188] = 'CP E'
opcodes[188] = function (reader_pos)
    -- CP E
    local var_14f = register_e(reg)
    local var_150 = register_a(reg)
    sub8to8(var_150, var_14f, reg, true, true)
    if var_150 == var_14f then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[189] = 'CP H'
opcodes[189] = function (reader_pos)
    -- CP H
    local var_151 = register_h(reg)
    local var_152 = register_a(reg)
    sub8to8(var_152, var_151, reg, true, true)
    if var_152 == var_151 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[190] = 'CP L'
opcodes[190] = function (reader_pos)
    -- CP L
    local var_153 = register_l(reg)
    local var_154 = register_a(reg)
    sub8to8(var_154, var_153, reg, true, true)
    if var_154 == var_153 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[191] = 'CP (HL)'
opcodes[191] = function (reader_pos)
    -- CP (HL)
    local var_155 = mmu_get(mem, register_hl(reg))
    local var_156 = register_a(reg)
    sub8to8(var_156, var_155, reg, true, true)
    if var_156 == var_155 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[192] = 'CP A'
opcodes[192] = function (reader_pos)
    -- CP A
    local var_157 = register_a(reg)
    local var_158 = register_a(reg)
    sub8to8(var_158, var_157, reg, true, true)
    if var_158 == var_157 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 1)
    register_set_flag_n(reg)
    return 4
end
opcodes_names[193] = 'RET NZ'
opcodes[193] = function (reader_pos)
    -- RET NZ
    if register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 1)
            return 20
    else

    end
    local var_159 = register_sp(reg)
    local var_15a = mmu_get(mem, var_159)
    local var_15b = var_159 + 1
    local var_15c = mmu_get(mem, var_15b)
    local var_15d = var_15b + 1
    local var_15e = bit_bor(var_15a, bit_lshift(var_15c, 8))
    register_set_sp(reg, var_15d)
    register_set_pc(reg, var_15e)
    return 8
end
opcodes_names[194] = 'POP BC'
opcodes[194] = function (reader_pos)
    -- POP BC
    local var_15f = register_sp(reg)
    local var_160 = mmu_get(mem, var_15f)
    local var_161 = var_15f + 1
    local var_162 = mmu_get(mem, var_161)
    local var_163 = var_161 + 1
    local var_164 = bit_bor(var_160, bit_lshift(var_162, 8))
    register_set_sp(reg, var_163)
    register_set_bc(reg, var_164)
    register_set_pc(reg, register_pc(reg) + 1)
    return 12
end
opcodes_names[195] = 'JP NZ, a16'
opcodes[195] = function (reader_pos)
    -- JP NZ, a16
    if register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 16
    else

    end
    local var_165 = next16(mem, reader_pos)
    register_set_pc(reg, var_165)
    return 12
end
opcodes_names[196] = 'JP a16'
opcodes[196] = function (reader_pos)
    -- JP a16
    if false then
            register_set_pc(reg, register_pc(reg) + 3)
            return 16
    else

    end
    local var_166 = next16(mem, reader_pos)
    register_set_pc(reg, var_166)
    return 16
end
opcodes_names[197] = 'CALL NZ, a16'
opcodes[197] = function (reader_pos)
    -- CALL NZ, a16
    if register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 24
    else

    end
    local var_167 = register_pc(reg)
    local var_168 = register_sp(reg)
    local var_169 = var_168 - 1
    local var_16a = var_167 + 3
    mmu_set(mem, var_169, bit_rshift(var_16a, 8))
    local var_16b = var_169 - 1
    mmu_set(mem, var_16b, bit_band(var_16a, 255))
    register_set_sp(reg, var_16b)
    local var_16c = next16(mem, reader_pos)
    register_set_pc(reg, var_16c)
    return 12
end
opcodes_names[198] = 'PUSH BC'
opcodes[198] = function (reader_pos)
    -- PUSH BC
    local var_16d = register_bc(reg)
    local var_16e = register_sp(reg)
    local var_16f = var_16e - 1
    local var_170 = var_16d
    mmu_set(mem, var_16f, bit_rshift(var_170, 8))
    local var_171 = var_16f - 1
    mmu_set(mem, var_171, bit_band(var_170, 255))
    register_set_sp(reg, var_171)
    register_set_pc(reg, register_pc(reg) + 1)
    return 16
end
opcodes_names[199] = 'ADD A, d8'
opcodes[199] = function (reader_pos)
    -- ADD A, d8
    local var_172 = mmu_get(mem, reader_pos)
    local var_173 = register_a(reg)
    local var_174 = add8to8(var_173, var_172, reg, true, true)
    register_set_a(reg, var_174)
    if var_174 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[200] = 'RST 00H'
opcodes[200] = function (reader_pos)
    -- RST 00H
    local var_175 = register_pc(reg)
    local var_176 = register_sp(reg)
    local var_177 = var_176 - 1
    local var_178 = var_175 + 1
    mmu_set(mem, var_177, bit_rshift(var_178, 8))
    local var_179 = var_177 - 1
    mmu_set(mem, var_179, bit_band(var_178, 255))
    register_set_sp(reg, var_179)
    register_set_pc(reg, 0)
    return 16
end
opcodes_names[201] = 'RET Z'
opcodes[201] = function (reader_pos)
    -- RET Z
    if not register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 1)
            return 20
    else

    end
    local var_17a = register_sp(reg)
    local var_17b = mmu_get(mem, var_17a)
    local var_17c = var_17a + 1
    local var_17d = mmu_get(mem, var_17c)
    local var_17e = var_17c + 1
    local var_17f = bit_bor(var_17b, bit_lshift(var_17d, 8))
    register_set_sp(reg, var_17e)
    register_set_pc(reg, var_17f)
    return 8
end
opcodes_names[202] = 'RET'
opcodes[202] = function (reader_pos)
    -- RET
    if false then
            register_set_pc(reg, register_pc(reg) + 1)
            return 16
    else

    end
    local var_180 = register_sp(reg)
    local var_181 = mmu_get(mem, var_180)
    local var_182 = var_180 + 1
    local var_183 = mmu_get(mem, var_182)
    local var_184 = var_182 + 1
    local var_185 = bit_bor(var_181, bit_lshift(var_183, 8))
    register_set_sp(reg, var_184)
    register_set_pc(reg, var_185)
    return 16
end
opcodes_names[203] = 'JP Z, a16'
opcodes[203] = function (reader_pos)
    -- JP Z, a16
    if not register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 16
    else

    end
    local var_186 = next16(mem, reader_pos)
    register_set_pc(reg, var_186)
    return 12
end
opcodes_names[205] = 'CALL Z, a16'
opcodes[205] = function (reader_pos)
    -- CALL Z, a16
    if not register_flag_zf(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 24
    else

    end
    local var_187 = register_pc(reg)
    local var_188 = register_sp(reg)
    local var_189 = var_188 - 1
    local var_18a = var_187 + 3
    mmu_set(mem, var_189, bit_rshift(var_18a, 8))
    local var_18b = var_189 - 1
    mmu_set(mem, var_18b, bit_band(var_18a, 255))
    register_set_sp(reg, var_18b)
    local var_18c = next16(mem, reader_pos)
    register_set_pc(reg, var_18c)
    return 12
end
opcodes_names[206] = 'CALL a16'
opcodes[206] = function (reader_pos)
    -- CALL a16
    if false then
            register_set_pc(reg, register_pc(reg) + 3)
            return 24
    else

    end
    local var_18d = register_pc(reg)
    local var_18e = register_sp(reg)
    local var_18f = var_18e - 1
    local var_190 = var_18d + 3
    mmu_set(mem, var_18f, bit_rshift(var_190, 8))
    local var_191 = var_18f - 1
    mmu_set(mem, var_191, bit_band(var_190, 255))
    register_set_sp(reg, var_191)
    local var_192 = next16(mem, reader_pos)
    register_set_pc(reg, var_192)
    return 24
end
opcodes_names[207] = 'ADC A, d8'
opcodes[207] = function (reader_pos)
    -- ADC A, d8
    local var_193 = mmu_get(mem, reader_pos)
    local var_194 = register_a(reg)
    local should_add_carry = register_flag_cy(reg)
    local var_195 = add8to8(var_194, var_193, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_195 = add8to8(var_195, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_195)
    if var_195 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    return 8
end
opcodes_names[208] = 'RST 08H'
opcodes[208] = function (reader_pos)
    -- RST 08H
    local var_196 = register_pc(reg)
    local var_197 = register_sp(reg)
    local var_198 = var_197 - 1
    local var_199 = var_196 + 1
    mmu_set(mem, var_198, bit_rshift(var_199, 8))
    local var_19a = var_198 - 1
    mmu_set(mem, var_19a, bit_band(var_199, 255))
    register_set_sp(reg, var_19a)
    register_set_pc(reg, 8)
    return 16
end
opcodes_names[209] = 'RET NC'
opcodes[209] = function (reader_pos)
    -- RET NC
    if register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 1)
            return 20
    else

    end
    local var_19b = register_sp(reg)
    local var_19c = mmu_get(mem, var_19b)
    local var_19d = var_19b + 1
    local var_19e = mmu_get(mem, var_19d)
    local var_19f = var_19d + 1
    local var_1a0 = bit_bor(var_19c, bit_lshift(var_19e, 8))
    register_set_sp(reg, var_19f)
    register_set_pc(reg, var_1a0)
    return 8
end
opcodes_names[210] = 'POP DE'
opcodes[210] = function (reader_pos)
    -- POP DE
    local var_1a1 = register_sp(reg)
    local var_1a2 = mmu_get(mem, var_1a1)
    local var_1a3 = var_1a1 + 1
    local var_1a4 = mmu_get(mem, var_1a3)
    local var_1a5 = var_1a3 + 1
    local var_1a6 = bit_bor(var_1a2, bit_lshift(var_1a4, 8))
    register_set_sp(reg, var_1a5)
    register_set_de(reg, var_1a6)
    register_set_pc(reg, register_pc(reg) + 1)
    return 12
end
opcodes_names[211] = 'JP NC, a16'
opcodes[211] = function (reader_pos)
    -- JP NC, a16
    if register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 16
    else

    end
    local var_1a7 = next16(mem, reader_pos)
    register_set_pc(reg, var_1a7)
    return 12
end
opcodes_names[213] = 'CALL NC, a16'
opcodes[213] = function (reader_pos)
    -- CALL NC, a16
    if register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 24
    else

    end
    local var_1a8 = register_pc(reg)
    local var_1a9 = register_sp(reg)
    local var_1aa = var_1a9 - 1
    local var_1ab = var_1a8 + 3
    mmu_set(mem, var_1aa, bit_rshift(var_1ab, 8))
    local var_1ac = var_1aa - 1
    mmu_set(mem, var_1ac, bit_band(var_1ab, 255))
    register_set_sp(reg, var_1ac)
    local var_1ad = next16(mem, reader_pos)
    register_set_pc(reg, var_1ad)
    return 12
end
opcodes_names[214] = 'PUSH DE'
opcodes[214] = function (reader_pos)
    -- PUSH DE
    local var_1ae = register_de(reg)
    local var_1af = register_sp(reg)
    local var_1b0 = var_1af - 1
    local var_1b1 = var_1ae
    mmu_set(mem, var_1b0, bit_rshift(var_1b1, 8))
    local var_1b2 = var_1b0 - 1
    mmu_set(mem, var_1b2, bit_band(var_1b1, 255))
    register_set_sp(reg, var_1b2)
    register_set_pc(reg, register_pc(reg) + 1)
    return 16
end
opcodes_names[215] = 'SUB d8'
opcodes[215] = function (reader_pos)
    -- SUB d8
    local var_1b3 = mmu_get(mem, reader_pos)
    local var_1b4 = register_a(reg)
    local var_1b5 = sub8to8(var_1b4, var_1b3, reg, true, true)
    register_set_a(reg, var_1b5)
    if var_1b5 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[216] = 'RST 10H'
opcodes[216] = function (reader_pos)
    -- RST 10H
    local var_1b6 = register_pc(reg)
    local var_1b7 = register_sp(reg)
    local var_1b8 = var_1b7 - 1
    local var_1b9 = var_1b6 + 1
    mmu_set(mem, var_1b8, bit_rshift(var_1b9, 8))
    local var_1ba = var_1b8 - 1
    mmu_set(mem, var_1ba, bit_band(var_1b9, 255))
    register_set_sp(reg, var_1ba)
    register_set_pc(reg, 16)
    return 16
end
opcodes_names[217] = 'RET C'
opcodes[217] = function (reader_pos)
    -- RET C
    if not register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 1)
            return 20
    else

    end
    local var_1bb = register_sp(reg)
    local var_1bc = mmu_get(mem, var_1bb)
    local var_1bd = var_1bb + 1
    local var_1be = mmu_get(mem, var_1bd)
    local var_1bf = var_1bd + 1
    local var_1c0 = bit_bor(var_1bc, bit_lshift(var_1be, 8))
    register_set_sp(reg, var_1bf)
    register_set_pc(reg, var_1c0)
    return 8
end
opcodes_names[218] = 'RETI'
opcodes[218] = function (reader_pos)
    -- RETI
    local var_1c1 = register_sp(reg)
    local var_1c2 = mmu_get(mem, var_1c1)
    local var_1c3 = var_1c1 + 1
    local var_1c4 = mmu_get(mem, var_1c3)
    local var_1c5 = var_1c3 + 1
    local var_1c6 = bit_bor(var_1c2, bit_lshift(var_1c4, 8))
    register_set_sp(reg, var_1c5)
    register_set_pc(reg, var_1c6)
    register_set_flag_ime(reg)
    return 16
end
opcodes_names[219] = 'JP C, a16'
opcodes[219] = function (reader_pos)
    -- JP C, a16
    if not register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 16
    else

    end
    local var_1c7 = next16(mem, reader_pos)
    register_set_pc(reg, var_1c7)
    return 12
end
opcodes_names[221] = 'CALL C, a16'
opcodes[221] = function (reader_pos)
    -- CALL C, a16
    if not register_flag_cy(reg) then
            register_set_pc(reg, register_pc(reg) + 3)
            return 24
    else

    end
    local var_1c8 = register_pc(reg)
    local var_1c9 = register_sp(reg)
    local var_1ca = var_1c9 - 1
    local var_1cb = var_1c8 + 3
    mmu_set(mem, var_1ca, bit_rshift(var_1cb, 8))
    local var_1cc = var_1ca - 1
    mmu_set(mem, var_1cc, bit_band(var_1cb, 255))
    register_set_sp(reg, var_1cc)
    local var_1cd = next16(mem, reader_pos)
    register_set_pc(reg, var_1cd)
    return 12
end
opcodes_names[223] = 'SBC A, d8'
opcodes[223] = function (reader_pos)
    -- SBC A, d8
    local var_1ce = register_a(reg)
    local var_1cf = mmu_get(mem, reader_pos)
    local should_add_carry = register_flag_cy(reg)
    local var_1d0 = sub8to8(var_1ce, var_1cf, reg, true, true)
    local backup_cy = register_flag_cy(reg)
    local backup_h = register_flag_h(reg)
    if should_add_carry then
            var_1d0 = sub8to8(var_1d0, 1, reg, true, true)
    else

    end
    if backup_cy then
            register_set_flag_cy(reg)
    else

    end
    if backup_h then
            register_set_flag_h(reg)
    else

    end
    register_set_a(reg, var_1d0)
    if var_1d0 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[224] = 'RST 18H'
opcodes[224] = function (reader_pos)
    -- RST 18H
    local var_1d1 = register_pc(reg)
    local var_1d2 = register_sp(reg)
    local var_1d3 = var_1d2 - 1
    local var_1d4 = var_1d1 + 1
    mmu_set(mem, var_1d3, bit_rshift(var_1d4, 8))
    local var_1d5 = var_1d3 - 1
    mmu_set(mem, var_1d5, bit_band(var_1d4, 255))
    register_set_sp(reg, var_1d5)
    register_set_pc(reg, 24)
    return 16
end
opcodes_names[225] = 'LDH (a8), A'
opcodes[225] = function (reader_pos)
    -- LDH (a8), A
    local var_1d6 = mmu_get(mem, reader_pos)
    local var_1d7 = register_a(reg)
    mmu_set(mem, bit_bor(var_1d6, 65280), var_1d7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 12
end
opcodes_names[226] = 'POP HL'
opcodes[226] = function (reader_pos)
    -- POP HL
    local var_1d8 = register_sp(reg)
    local var_1d9 = mmu_get(mem, var_1d8)
    local var_1da = var_1d8 + 1
    local var_1db = mmu_get(mem, var_1da)
    local var_1dc = var_1da + 1
    local var_1dd = bit_bor(var_1d9, bit_lshift(var_1db, 8))
    register_set_sp(reg, var_1dc)
    register_set_hl(reg, var_1dd)
    register_set_pc(reg, register_pc(reg) + 1)
    return 12
end
opcodes_names[227] = 'LD (C), A'
opcodes[227] = function (reader_pos)
    -- LD (C), A
    local var_1de = register_c(reg)
    local var_1df = register_a(reg)
    mmu_set(mem, bit_bor(var_1de, 65280), var_1df)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[230] = 'PUSH HL'
opcodes[230] = function (reader_pos)
    -- PUSH HL
    local var_1e0 = register_hl(reg)
    local var_1e1 = register_sp(reg)
    local var_1e2 = var_1e1 - 1
    local var_1e3 = var_1e0
    mmu_set(mem, var_1e2, bit_rshift(var_1e3, 8))
    local var_1e4 = var_1e2 - 1
    mmu_set(mem, var_1e4, bit_band(var_1e3, 255))
    register_set_sp(reg, var_1e4)
    register_set_pc(reg, register_pc(reg) + 1)
    return 16
end
opcodes_names[231] = 'AND d8'
opcodes[231] = function (reader_pos)
    -- AND d8
    local var_1e5 = mmu_get(mem, reader_pos)
    local var_1e6 = register_a(reg)
    local var_1e7 = bit_band(var_1e5, var_1e6)
    register_set_a(reg, var_1e7)
    if var_1e7 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[232] = 'RST 20H'
opcodes[232] = function (reader_pos)
    -- RST 20H
    local var_1e8 = register_pc(reg)
    local var_1e9 = register_sp(reg)
    local var_1ea = var_1e9 - 1
    local var_1eb = var_1e8 + 1
    mmu_set(mem, var_1ea, bit_rshift(var_1eb, 8))
    local var_1ec = var_1ea - 1
    mmu_set(mem, var_1ec, bit_band(var_1eb, 255))
    register_set_sp(reg, var_1ec)
    register_set_pc(reg, 32)
    return 16
end
opcodes_names[233] = 'ADD SP, r8'
opcodes[233] = function (reader_pos)
    -- ADD SP, r8
    local var_1ed = mmu_get(mem, reader_pos)
    local var_1ee = register_sp(reg)
    local var_1ef = add8to16(var_1ed, var_1ee, reg, true, true)
    register_set_sp(reg, var_1ef)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    return 16
end
opcodes_names[234] = 'JP HL'
opcodes[234] = function (reader_pos)
    -- JP HL
    if false then
            register_set_pc(reg, register_pc(reg) + 1)
            return 4
    else

    end
    local var_1f0 = register_hl(reg)
    register_set_pc(reg, var_1f0)
    return 4
end
opcodes_names[235] = 'LD (a16), A'
opcodes[235] = function (reader_pos)
    -- LD (a16), A
    local var_1f1 = register_a(reg)
    mmu_set(mem, next16(mem, reader_pos), var_1f1)
    register_set_pc(reg, register_pc(reg) + 3)
    return 16
end
opcodes_names[239] = 'XOR d8'
opcodes[239] = function (reader_pos)
    -- XOR d8
    local var_1f2 = mmu_get(mem, reader_pos)
    local var_1f3 = register_a(reg)
    local var_1f4 = bit_bxor(var_1f2, var_1f3)
    register_set_a(reg, var_1f4)
    if var_1f4 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[240] = 'RST 28H'
opcodes[240] = function (reader_pos)
    -- RST 28H
    local var_1f5 = register_pc(reg)
    local var_1f6 = register_sp(reg)
    local var_1f7 = var_1f6 - 1
    local var_1f8 = var_1f5 + 1
    mmu_set(mem, var_1f7, bit_rshift(var_1f8, 8))
    local var_1f9 = var_1f7 - 1
    mmu_set(mem, var_1f9, bit_band(var_1f8, 255))
    register_set_sp(reg, var_1f9)
    register_set_pc(reg, 40)
    return 16
end
opcodes_names[241] = 'LDH A, (a8)'
opcodes[241] = function (reader_pos)
    -- LDH A, (a8)
    local var_1fa = mmu_get(mem, reader_pos)
    local var_1fb = mmu_get(mem, bit_bor(var_1fa, 65280))
    if var_1fb == nil then print(string.format("%04X", bit_bor(var_1fa, 65280))) end
    register_set_a(reg, var_1fb)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 12
end
opcodes_names[242] = 'POP AF'
opcodes[242] = function (reader_pos)
    -- POP AF
    local var_1fc = register_sp(reg)
    local var_1fd = mmu_get(mem, var_1fc)
    local var_1fe = var_1fc + 1
    local var_1ff = mmu_get(mem, var_1fe)
    local var_200 = var_1fe + 1
    local var_201 = bit_bor(var_1fd, bit_lshift(var_1ff, 8))
    register_set_sp(reg, var_200)
    register_set_af(reg, bit_band(var_201, 65520))
    register_set_pc(reg, register_pc(reg) + 1)
    return 12
end
opcodes_names[243] = 'LD A, (C)'
opcodes[243] = function (reader_pos)
    -- LD A, (C)
    local var_202 = register_c(reg)
    register_set_a(reg, mmu_get(mem, bit_bor(var_202, 65280)))
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[244] = 'DI'
opcodes[244] = function (reader_pos)
    -- DI
    register_unset_flag_ime(reg)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[246] = 'PUSH AF'
opcodes[246] = function (reader_pos)
    -- PUSH AF
    local var_203 = register_af(reg)
    local var_204 = register_sp(reg)
    local var_205 = var_204 - 1
    local var_206 = var_203
    mmu_set(mem, var_205, bit_rshift(var_206, 8))
    local var_207 = var_205 - 1
    mmu_set(mem, var_207, bit_band(var_206, 255))
    register_set_sp(reg, var_207)
    register_set_pc(reg, register_pc(reg) + 1)
    return 16
end
opcodes_names[247] = 'OR d8'
opcodes[247] = function (reader_pos)
    -- OR d8
    local var_208 = mmu_get(mem, reader_pos)
    local var_209 = register_a(reg)
    local var_20a = bit_bor(var_208, var_209)
    register_set_a(reg, var_20a)
    if var_20a == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes_names[248] = 'RST 30H'
opcodes[248] = function (reader_pos)
    -- RST 30H
    local var_20b = register_pc(reg)
    local var_20c = register_sp(reg)
    local var_20d = var_20c - 1
    local var_20e = var_20b + 1
    mmu_set(mem, var_20d, bit_rshift(var_20e, 8))
    local var_20f = var_20d - 1
    mmu_set(mem, var_20f, bit_band(var_20e, 255))
    register_set_sp(reg, var_20f)
    register_set_pc(reg, 48)
    return 16
end
opcodes_names[249] = 'LD HL, SP+r8'
opcodes[249] = function (reader_pos)
    -- LD HL, SP+r8
    local var_210 = add8to16(mmu_get(mem, reader_pos), register_sp(reg), reg, true, true)
    register_set_hl(reg, var_210)
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_zf(reg)
    register_unset_flag_n(reg)
    return 12
end
opcodes_names[250] = 'LD SP, HL'
opcodes[250] = function (reader_pos)
    -- LD SP, HL
    local var_211 = register_hl(reg)
    register_set_sp(reg, var_211)
    register_set_pc(reg, register_pc(reg) + 1)
    return 8
end
opcodes_names[251] = 'LD A, (a16)'
opcodes[251] = function (reader_pos)
    -- LD A, (a16)
    local var_212 = mmu_get(mem, next16(mem, reader_pos))
    register_set_a(reg, var_212)
    register_set_pc(reg, register_pc(reg) + 3)
    return 16
end
opcodes_names[252] = 'EI'
opcodes[252] = function (reader_pos)
    -- EI
    register_set_flag_ime(reg)
    register_set_pc(reg, register_pc(reg) + 1)
    return 4
end
opcodes_names[255] = 'CP d8'
opcodes[255] = function (reader_pos)
    -- CP d8
    local var_213 = mmu_get(mem, reader_pos)
    local var_214 = register_a(reg)
    sub8to8(var_214, var_213, reg, true, true)
    if var_214 == var_213 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_set_flag_n(reg)
    return 8
end
opcodes_names[256] = 'RST 38H'
opcodes[256] = function (reader_pos)
    -- RST 38H
    local var_215 = register_pc(reg)
    local var_216 = register_sp(reg)
    local var_217 = var_216 - 1
    local var_218 = var_215 + 1
    mmu_set(mem, var_217, bit_rshift(var_218, 8))
    local var_219 = var_217 - 1
    mmu_set(mem, var_219, bit_band(var_218, 255))
    register_set_sp(reg, var_219)
    register_set_pc(reg, 56)
    return 16
end
opcodes16, opcodes16_names = {
}, {
}
opcodes16_names[1] = 'RLC B'
opcodes16[1] = function (reader_pos)
    -- RLC B
    local var_21a = register_b(reg)
    local var_21b = bit_lshift(var_21a, 1)
    local var_21c = bit_band(var_21b, 255)
    if bit_band(var_21b, 256) ~= 0 then
            var_21c = bit_bor(var_21c, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, var_21c)
    if var_21c == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[2] = 'RLC C'
opcodes16[2] = function (reader_pos)
    -- RLC C
    local var_21d = register_c(reg)
    local var_21e = bit_lshift(var_21d, 1)
    local var_21f = bit_band(var_21e, 255)
    if bit_band(var_21e, 256) ~= 0 then
            var_21f = bit_bor(var_21f, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, var_21f)
    if var_21f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[3] = 'RLC D'
opcodes16[3] = function (reader_pos)
    -- RLC D
    local var_220 = register_d(reg)
    local var_221 = bit_lshift(var_220, 1)
    local var_222 = bit_band(var_221, 255)
    if bit_band(var_221, 256) ~= 0 then
            var_222 = bit_bor(var_222, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, var_222)
    if var_222 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[4] = 'RLC E'
opcodes16[4] = function (reader_pos)
    -- RLC E
    local var_223 = register_e(reg)
    local var_224 = bit_lshift(var_223, 1)
    local var_225 = bit_band(var_224, 255)
    if bit_band(var_224, 256) ~= 0 then
            var_225 = bit_bor(var_225, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, var_225)
    if var_225 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[5] = 'RLC H'
opcodes16[5] = function (reader_pos)
    -- RLC H
    local var_226 = register_h(reg)
    local var_227 = bit_lshift(var_226, 1)
    local var_228 = bit_band(var_227, 255)
    if bit_band(var_227, 256) ~= 0 then
            var_228 = bit_bor(var_228, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, var_228)
    if var_228 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[6] = 'RLC L'
opcodes16[6] = function (reader_pos)
    -- RLC L
    local var_229 = register_l(reg)
    local var_22a = bit_lshift(var_229, 1)
    local var_22b = bit_band(var_22a, 255)
    if bit_band(var_22a, 256) ~= 0 then
            var_22b = bit_bor(var_22b, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, var_22b)
    if var_22b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[7] = 'RLC (HL)'
opcodes16[7] = function (reader_pos)
    -- RLC (HL)
    local var_22c = mmu_get(mem, register_hl(reg))
    local var_22d = bit_lshift(var_22c, 1)
    local var_22e = bit_band(var_22d, 255)
    if bit_band(var_22d, 256) ~= 0 then
            var_22e = bit_bor(var_22e, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), var_22e)
    if var_22e == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[8] = 'RLC A'
opcodes16[8] = function (reader_pos)
    -- RLC A
    local var_22f = register_a(reg)
    local var_230 = bit_lshift(var_22f, 1)
    local var_231 = bit_band(var_230, 255)
    if bit_band(var_230, 256) ~= 0 then
            var_231 = bit_bor(var_231, 1)
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_231)
    if var_231 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[9] = 'RRC B'
opcodes16[9] = function (reader_pos)
    -- RRC B
    local var_232 = register_b(reg)
    local var_233 = bit_rshift(var_232, 1)
    if bit_band(var_232, 1) ~= 0 then
            var_233 = bit_bor(var_233, 128)
    else

    end
    if bit_band(var_232, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, var_233)
    if var_233 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[10] = 'RRC C'
opcodes16[10] = function (reader_pos)
    -- RRC C
    local var_234 = register_c(reg)
    local var_235 = bit_rshift(var_234, 1)
    if bit_band(var_234, 1) ~= 0 then
            var_235 = bit_bor(var_235, 128)
    else

    end
    if bit_band(var_234, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, var_235)
    if var_235 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[11] = 'RRC D'
opcodes16[11] = function (reader_pos)
    -- RRC D
    local var_236 = register_d(reg)
    local var_237 = bit_rshift(var_236, 1)
    if bit_band(var_236, 1) ~= 0 then
            var_237 = bit_bor(var_237, 128)
    else

    end
    if bit_band(var_236, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, var_237)
    if var_237 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[12] = 'RRC E'
opcodes16[12] = function (reader_pos)
    -- RRC E
    local var_238 = register_e(reg)
    local var_239 = bit_rshift(var_238, 1)
    if bit_band(var_238, 1) ~= 0 then
            var_239 = bit_bor(var_239, 128)
    else

    end
    if bit_band(var_238, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, var_239)
    if var_239 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[13] = 'RRC H'
opcodes16[13] = function (reader_pos)
    -- RRC H
    local var_23a = register_h(reg)
    local var_23b = bit_rshift(var_23a, 1)
    if bit_band(var_23a, 1) ~= 0 then
            var_23b = bit_bor(var_23b, 128)
    else

    end
    if bit_band(var_23a, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, var_23b)
    if var_23b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[14] = 'RRC L'
opcodes16[14] = function (reader_pos)
    -- RRC L
    local var_23c = register_l(reg)
    local var_23d = bit_rshift(var_23c, 1)
    if bit_band(var_23c, 1) ~= 0 then
            var_23d = bit_bor(var_23d, 128)
    else

    end
    if bit_band(var_23c, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, var_23d)
    if var_23d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[15] = 'RRC (HL)'
opcodes16[15] = function (reader_pos)
    -- RRC (HL)
    local var_23e = mmu_get(mem, register_hl(reg))
    local var_23f = bit_rshift(var_23e, 1)
    if bit_band(var_23e, 1) ~= 0 then
            var_23f = bit_bor(var_23f, 128)
    else

    end
    if bit_band(var_23e, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), var_23f)
    if var_23f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[16] = 'RRC A'
opcodes16[16] = function (reader_pos)
    -- RRC A
    local var_240 = register_a(reg)
    local var_241 = bit_rshift(var_240, 1)
    if bit_band(var_240, 1) ~= 0 then
            var_241 = bit_bor(var_241, 128)
    else

    end
    if bit_band(var_240, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_241)
    if var_241 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[17] = 'RL B'
opcodes16[17] = function (reader_pos)
    -- RL B
    local var_242 = register_b(reg)
    local var_243 = bit_lshift(var_242, 1)
    if register_flag_cy(reg) then
            var_243 = bit_bor(var_243, 1)
    else

    end
    if bit_band(var_243, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, bit_band(var_243, 255))
    if bit_band(var_243, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[18] = 'RL C'
opcodes16[18] = function (reader_pos)
    -- RL C
    local var_244 = register_c(reg)
    local var_245 = bit_lshift(var_244, 1)
    if register_flag_cy(reg) then
            var_245 = bit_bor(var_245, 1)
    else

    end
    if bit_band(var_245, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, bit_band(var_245, 255))
    if bit_band(var_245, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[19] = 'RL D'
opcodes16[19] = function (reader_pos)
    -- RL D
    local var_246 = register_d(reg)
    local var_247 = bit_lshift(var_246, 1)
    if register_flag_cy(reg) then
            var_247 = bit_bor(var_247, 1)
    else

    end
    if bit_band(var_247, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, bit_band(var_247, 255))
    if bit_band(var_247, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[20] = 'RL E'
opcodes16[20] = function (reader_pos)
    -- RL E
    local var_248 = register_e(reg)
    local var_249 = bit_lshift(var_248, 1)
    if register_flag_cy(reg) then
            var_249 = bit_bor(var_249, 1)
    else

    end
    if bit_band(var_249, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, bit_band(var_249, 255))
    if bit_band(var_249, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[21] = 'RL H'
opcodes16[21] = function (reader_pos)
    -- RL H
    local var_24a = register_h(reg)
    local var_24b = bit_lshift(var_24a, 1)
    if register_flag_cy(reg) then
            var_24b = bit_bor(var_24b, 1)
    else

    end
    if bit_band(var_24b, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, bit_band(var_24b, 255))
    if bit_band(var_24b, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[22] = 'RL L'
opcodes16[22] = function (reader_pos)
    -- RL L
    local var_24c = register_l(reg)
    local var_24d = bit_lshift(var_24c, 1)
    if register_flag_cy(reg) then
            var_24d = bit_bor(var_24d, 1)
    else

    end
    if bit_band(var_24d, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, bit_band(var_24d, 255))
    if bit_band(var_24d, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[23] = 'RL (HL)'
opcodes16[23] = function (reader_pos)
    -- RL (HL)
    local var_24e = mmu_get(mem, register_hl(reg))
    local var_24f = bit_lshift(var_24e, 1)
    if register_flag_cy(reg) then
            var_24f = bit_bor(var_24f, 1)
    else

    end
    if bit_band(var_24f, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), bit_band(var_24f, 255))
    if bit_band(var_24f, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[24] = 'RL A'
opcodes16[24] = function (reader_pos)
    -- RL A
    local var_250 = register_a(reg)
    local var_251 = bit_lshift(var_250, 1)
    if register_flag_cy(reg) then
            var_251 = bit_bor(var_251, 1)
    else

    end
    if bit_band(var_251, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, bit_band(var_251, 255))
    if bit_band(var_251, 255) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[25] = 'RR B'
opcodes16[25] = function (reader_pos)
    -- RR B
    local var_252 = register_b(reg)
    local var_253 = bit_rshift(var_252, 1)
    if register_flag_cy(reg) then
            var_253 = bit_bor(var_253, 128)
    else

    end
    if bit_band(var_252, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, var_253)
    if var_253 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[26] = 'RR C'
opcodes16[26] = function (reader_pos)
    -- RR C
    local var_254 = register_c(reg)
    local var_255 = bit_rshift(var_254, 1)
    if register_flag_cy(reg) then
            var_255 = bit_bor(var_255, 128)
    else

    end
    if bit_band(var_254, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, var_255)
    if var_255 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[27] = 'RR D'
opcodes16[27] = function (reader_pos)
    -- RR D
    local var_256 = register_d(reg)
    local var_257 = bit_rshift(var_256, 1)
    if register_flag_cy(reg) then
            var_257 = bit_bor(var_257, 128)
    else

    end
    if bit_band(var_256, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, var_257)
    if var_257 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[28] = 'RR E'
opcodes16[28] = function (reader_pos)
    -- RR E
    local var_258 = register_e(reg)
    local var_259 = bit_rshift(var_258, 1)
    if register_flag_cy(reg) then
            var_259 = bit_bor(var_259, 128)
    else

    end
    if bit_band(var_258, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, var_259)
    if var_259 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[29] = 'RR H'
opcodes16[29] = function (reader_pos)
    -- RR H
    local var_25a = register_h(reg)
    local var_25b = bit_rshift(var_25a, 1)
    if register_flag_cy(reg) then
            var_25b = bit_bor(var_25b, 128)
    else

    end
    if bit_band(var_25a, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, var_25b)
    if var_25b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[30] = 'RR L'
opcodes16[30] = function (reader_pos)
    -- RR L
    local var_25c = register_l(reg)
    local var_25d = bit_rshift(var_25c, 1)
    if register_flag_cy(reg) then
            var_25d = bit_bor(var_25d, 128)
    else

    end
    if bit_band(var_25c, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, var_25d)
    if var_25d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[31] = 'RR (HL)'
opcodes16[31] = function (reader_pos)
    -- RR (HL)
    local var_25e = mmu_get(mem, register_hl(reg))
    local var_25f = bit_rshift(var_25e, 1)
    if register_flag_cy(reg) then
            var_25f = bit_bor(var_25f, 128)
    else

    end
    if bit_band(var_25e, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), var_25f)
    if var_25f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[32] = 'RR A'
opcodes16[32] = function (reader_pos)
    -- RR A
    local var_260 = register_a(reg)
    local var_261 = bit_rshift(var_260, 1)
    if register_flag_cy(reg) then
            var_261 = bit_bor(var_261, 128)
    else

    end
    if bit_band(var_260, 1) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_261)
    if var_261 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[33] = 'SLA B'
opcodes16[33] = function (reader_pos)
    -- SLA B
    local var_262 = register_b(reg)
    local var_263 = bit_lshift(var_262, 1)
    local var_264 = bit_band(var_263, 255)
    if bit_band(var_263, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, var_264)
    if var_264 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[34] = 'SLA C'
opcodes16[34] = function (reader_pos)
    -- SLA C
    local var_265 = register_c(reg)
    local var_266 = bit_lshift(var_265, 1)
    local var_267 = bit_band(var_266, 255)
    if bit_band(var_266, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, var_267)
    if var_267 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[35] = 'SLA D'
opcodes16[35] = function (reader_pos)
    -- SLA D
    local var_268 = register_d(reg)
    local var_269 = bit_lshift(var_268, 1)
    local var_26a = bit_band(var_269, 255)
    if bit_band(var_269, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, var_26a)
    if var_26a == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[36] = 'SLA E'
opcodes16[36] = function (reader_pos)
    -- SLA E
    local var_26b = register_e(reg)
    local var_26c = bit_lshift(var_26b, 1)
    local var_26d = bit_band(var_26c, 255)
    if bit_band(var_26c, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, var_26d)
    if var_26d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[37] = 'SLA H'
opcodes16[37] = function (reader_pos)
    -- SLA H
    local var_26e = register_h(reg)
    local var_26f = bit_lshift(var_26e, 1)
    local var_270 = bit_band(var_26f, 255)
    if bit_band(var_26f, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, var_270)
    if var_270 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[38] = 'SLA L'
opcodes16[38] = function (reader_pos)
    -- SLA L
    local var_271 = register_l(reg)
    local var_272 = bit_lshift(var_271, 1)
    local var_273 = bit_band(var_272, 255)
    if bit_band(var_272, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, var_273)
    if var_273 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[39] = 'SLA (HL)'
opcodes16[39] = function (reader_pos)
    -- SLA (HL)
    local var_274 = mmu_get(mem, register_hl(reg))
    local var_275 = bit_lshift(var_274, 1)
    local var_276 = bit_band(var_275, 255)
    if bit_band(var_275, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), var_276)
    if var_276 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[40] = 'SLA A'
opcodes16[40] = function (reader_pos)
    -- SLA A
    local var_277 = register_a(reg)
    local var_278 = bit_lshift(var_277, 1)
    local var_279 = bit_band(var_278, 255)
    if bit_band(var_278, 256) ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_279)
    if var_279 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[41] = 'SRA B'
opcodes16[41] = function (reader_pos)
    -- SRA B
    local var_27a = register_b(reg)
    local var_27b = bit_band(var_27a, 1)
    local var_27c = bit_rshift(var_27a, 1)
    if var_27b ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_27c, 64) ~= 0 then
            var_27c = bit_bor(var_27c, 128)
    else

    end
    register_set_b(reg, var_27c)
    if var_27c == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[42] = 'SRA C'
opcodes16[42] = function (reader_pos)
    -- SRA C
    local var_27d = register_c(reg)
    local var_27e = bit_band(var_27d, 1)
    local var_27f = bit_rshift(var_27d, 1)
    if var_27e ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_27f, 64) ~= 0 then
            var_27f = bit_bor(var_27f, 128)
    else

    end
    register_set_c(reg, var_27f)
    if var_27f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[43] = 'SRA D'
opcodes16[43] = function (reader_pos)
    -- SRA D
    local var_280 = register_d(reg)
    local var_281 = bit_band(var_280, 1)
    local var_282 = bit_rshift(var_280, 1)
    if var_281 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_282, 64) ~= 0 then
            var_282 = bit_bor(var_282, 128)
    else

    end
    register_set_d(reg, var_282)
    if var_282 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[44] = 'SRA E'
opcodes16[44] = function (reader_pos)
    -- SRA E
    local var_283 = register_e(reg)
    local var_284 = bit_band(var_283, 1)
    local var_285 = bit_rshift(var_283, 1)
    if var_284 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_285, 64) ~= 0 then
            var_285 = bit_bor(var_285, 128)
    else

    end
    register_set_e(reg, var_285)
    if var_285 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[45] = 'SRA H'
opcodes16[45] = function (reader_pos)
    -- SRA H
    local var_286 = register_h(reg)
    local var_287 = bit_band(var_286, 1)
    local var_288 = bit_rshift(var_286, 1)
    if var_287 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_288, 64) ~= 0 then
            var_288 = bit_bor(var_288, 128)
    else

    end
    register_set_h(reg, var_288)
    if var_288 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[46] = 'SRA L'
opcodes16[46] = function (reader_pos)
    -- SRA L
    local var_289 = register_l(reg)
    local var_28a = bit_band(var_289, 1)
    local var_28b = bit_rshift(var_289, 1)
    if var_28a ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_28b, 64) ~= 0 then
            var_28b = bit_bor(var_28b, 128)
    else

    end
    register_set_l(reg, var_28b)
    if var_28b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[47] = 'SRA (HL)'
opcodes16[47] = function (reader_pos)
    -- SRA (HL)
    local var_28c = mmu_get(mem, register_hl(reg))
    local var_28d = bit_band(var_28c, 1)
    local var_28e = bit_rshift(var_28c, 1)
    if var_28d ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_28e, 64) ~= 0 then
            var_28e = bit_bor(var_28e, 128)
    else

    end
    mmu_set(mem, register_hl(reg), var_28e)
    if var_28e == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[48] = 'SRA A'
opcodes16[48] = function (reader_pos)
    -- SRA A
    local var_28f = register_a(reg)
    local var_290 = bit_band(var_28f, 1)
    local var_291 = bit_rshift(var_28f, 1)
    if var_290 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    if bit_band(var_291, 64) ~= 0 then
            var_291 = bit_bor(var_291, 128)
    else

    end
    register_set_a(reg, var_291)
    if var_291 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[49] = 'SWAP B'
opcodes16[49] = function (reader_pos)
    -- SWAP B
    local var_292 = register_b(reg)
    local var_293 = bit_bor(bit_lshift(bit_band(var_292, 15), 4), bit_rshift(var_292, 4))
    register_set_b(reg, var_293)
    if var_293 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[50] = 'SWAP C'
opcodes16[50] = function (reader_pos)
    -- SWAP C
    local var_294 = register_c(reg)
    local var_295 = bit_bor(bit_lshift(bit_band(var_294, 15), 4), bit_rshift(var_294, 4))
    register_set_c(reg, var_295)
    if var_295 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[51] = 'SWAP D'
opcodes16[51] = function (reader_pos)
    -- SWAP D
    local var_296 = register_d(reg)
    local var_297 = bit_bor(bit_lshift(bit_band(var_296, 15), 4), bit_rshift(var_296, 4))
    register_set_d(reg, var_297)
    if var_297 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[52] = 'SWAP E'
opcodes16[52] = function (reader_pos)
    -- SWAP E
    local var_298 = register_e(reg)
    local var_299 = bit_bor(bit_lshift(bit_band(var_298, 15), 4), bit_rshift(var_298, 4))
    register_set_e(reg, var_299)
    if var_299 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[53] = 'SWAP H'
opcodes16[53] = function (reader_pos)
    -- SWAP H
    local var_29a = register_h(reg)
    local var_29b = bit_bor(bit_lshift(bit_band(var_29a, 15), 4), bit_rshift(var_29a, 4))
    register_set_h(reg, var_29b)
    if var_29b == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[54] = 'SWAP L'
opcodes16[54] = function (reader_pos)
    -- SWAP L
    local var_29c = register_l(reg)
    local var_29d = bit_bor(bit_lshift(bit_band(var_29c, 15), 4), bit_rshift(var_29c, 4))
    register_set_l(reg, var_29d)
    if var_29d == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[55] = 'SWAP (HL)'
opcodes16[55] = function (reader_pos)
    -- SWAP (HL)
    local var_29e = mmu_get(mem, register_hl(reg))
    local var_29f = bit_bor(bit_lshift(bit_band(var_29e, 15), 4), bit_rshift(var_29e, 4))
    mmu_set(mem, register_hl(reg), var_29f)
    if var_29f == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 16
end
opcodes16_names[56] = 'SWAP A'
opcodes16[56] = function (reader_pos)
    -- SWAP A
    local var_2a0 = register_a(reg)
    local var_2a1 = bit_bor(bit_lshift(bit_band(var_2a0, 15), 4), bit_rshift(var_2a0, 4))
    register_set_a(reg, var_2a1)
    if var_2a1 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    register_unset_flag_cy(reg)
    return 8
end
opcodes16_names[57] = 'SRL B'
opcodes16[57] = function (reader_pos)
    -- SRL B
    local var_2a2 = register_b(reg)
    local var_2a3 = bit_band(var_2a2, 1)
    local var_2a4 = bit_rshift(var_2a2, 1)
    if var_2a3 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_b(reg, var_2a4)
    if var_2a4 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[58] = 'SRL C'
opcodes16[58] = function (reader_pos)
    -- SRL C
    local var_2a5 = register_c(reg)
    local var_2a6 = bit_band(var_2a5, 1)
    local var_2a7 = bit_rshift(var_2a5, 1)
    if var_2a6 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_c(reg, var_2a7)
    if var_2a7 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[59] = 'SRL D'
opcodes16[59] = function (reader_pos)
    -- SRL D
    local var_2a8 = register_d(reg)
    local var_2a9 = bit_band(var_2a8, 1)
    local var_2aa = bit_rshift(var_2a8, 1)
    if var_2a9 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_d(reg, var_2aa)
    if var_2aa == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[60] = 'SRL E'
opcodes16[60] = function (reader_pos)
    -- SRL E
    local var_2ab = register_e(reg)
    local var_2ac = bit_band(var_2ab, 1)
    local var_2ad = bit_rshift(var_2ab, 1)
    if var_2ac ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_e(reg, var_2ad)
    if var_2ad == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[61] = 'SRL H'
opcodes16[61] = function (reader_pos)
    -- SRL H
    local var_2ae = register_h(reg)
    local var_2af = bit_band(var_2ae, 1)
    local var_2b0 = bit_rshift(var_2ae, 1)
    if var_2af ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_h(reg, var_2b0)
    if var_2b0 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[62] = 'SRL L'
opcodes16[62] = function (reader_pos)
    -- SRL L
    local var_2b1 = register_l(reg)
    local var_2b2 = bit_band(var_2b1, 1)
    local var_2b3 = bit_rshift(var_2b1, 1)
    if var_2b2 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_l(reg, var_2b3)
    if var_2b3 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[63] = 'SRL (HL)'
opcodes16[63] = function (reader_pos)
    -- SRL (HL)
    local var_2b4 = mmu_get(mem, register_hl(reg))
    local var_2b5 = bit_band(var_2b4, 1)
    local var_2b6 = bit_rshift(var_2b4, 1)
    if var_2b5 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    mmu_set(mem, register_hl(reg), var_2b6)
    if var_2b6 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 16
end
opcodes16_names[64] = 'SRL A'
opcodes16[64] = function (reader_pos)
    -- SRL A
    local var_2b7 = register_a(reg)
    local var_2b8 = bit_band(var_2b7, 1)
    local var_2b9 = bit_rshift(var_2b7, 1)
    if var_2b8 ~= 0 then
            register_set_flag_cy(reg)
    else
            register_unset_flag_cy(reg)
    end
    register_set_a(reg, var_2b9)
    if var_2b9 == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_unset_flag_h(reg)
    return 8
end
opcodes16_names[65] = 'BIT 0, B'
opcodes16[65] = function (reader_pos)
    -- BIT 0, B
    local var_2ba = register_b(reg)
    if bit_band(var_2ba, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[66] = 'BIT 0, C'
opcodes16[66] = function (reader_pos)
    -- BIT 0, C
    local var_2bb = register_c(reg)
    if bit_band(var_2bb, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[67] = 'BIT 0, D'
opcodes16[67] = function (reader_pos)
    -- BIT 0, D
    local var_2bc = register_d(reg)
    if bit_band(var_2bc, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[68] = 'BIT 0, E'
opcodes16[68] = function (reader_pos)
    -- BIT 0, E
    local var_2bd = register_e(reg)
    if bit_band(var_2bd, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[69] = 'BIT 0, H'
opcodes16[69] = function (reader_pos)
    -- BIT 0, H
    local var_2be = register_h(reg)
    if bit_band(var_2be, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[70] = 'BIT 0, L'
opcodes16[70] = function (reader_pos)
    -- BIT 0, L
    local var_2bf = register_l(reg)
    if bit_band(var_2bf, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[71] = 'BIT 0, (HL)'
opcodes16[71] = function (reader_pos)
    -- BIT 0, (HL)
    local var_2c0 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2c0, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[72] = 'BIT 0, A'
opcodes16[72] = function (reader_pos)
    -- BIT 0, A
    local var_2c1 = register_a(reg)
    if bit_band(var_2c1, 1) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[73] = 'BIT 1, B'
opcodes16[73] = function (reader_pos)
    -- BIT 1, B
    local var_2c2 = register_b(reg)
    if bit_band(var_2c2, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[74] = 'BIT 1, C'
opcodes16[74] = function (reader_pos)
    -- BIT 1, C
    local var_2c3 = register_c(reg)
    if bit_band(var_2c3, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[75] = 'BIT 1, D'
opcodes16[75] = function (reader_pos)
    -- BIT 1, D
    local var_2c4 = register_d(reg)
    if bit_band(var_2c4, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[76] = 'BIT 1, E'
opcodes16[76] = function (reader_pos)
    -- BIT 1, E
    local var_2c5 = register_e(reg)
    if bit_band(var_2c5, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[77] = 'BIT 1, H'
opcodes16[77] = function (reader_pos)
    -- BIT 1, H
    local var_2c6 = register_h(reg)
    if bit_band(var_2c6, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[78] = 'BIT 1, L'
opcodes16[78] = function (reader_pos)
    -- BIT 1, L
    local var_2c7 = register_l(reg)
    if bit_band(var_2c7, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[79] = 'BIT 1, (HL)'
opcodes16[79] = function (reader_pos)
    -- BIT 1, (HL)
    local var_2c8 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2c8, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[80] = 'BIT 1, A'
opcodes16[80] = function (reader_pos)
    -- BIT 1, A
    local var_2c9 = register_a(reg)
    if bit_band(var_2c9, 2) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[81] = 'BIT 2, B'
opcodes16[81] = function (reader_pos)
    -- BIT 2, B
    local var_2ca = register_b(reg)
    if bit_band(var_2ca, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[82] = 'BIT 2, C'
opcodes16[82] = function (reader_pos)
    -- BIT 2, C
    local var_2cb = register_c(reg)
    if bit_band(var_2cb, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[83] = 'BIT 2, D'
opcodes16[83] = function (reader_pos)
    -- BIT 2, D
    local var_2cc = register_d(reg)
    if bit_band(var_2cc, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[84] = 'BIT 2, E'
opcodes16[84] = function (reader_pos)
    -- BIT 2, E
    local var_2cd = register_e(reg)
    if bit_band(var_2cd, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[85] = 'BIT 2, H'
opcodes16[85] = function (reader_pos)
    -- BIT 2, H
    local var_2ce = register_h(reg)
    if bit_band(var_2ce, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[86] = 'BIT 2, L'
opcodes16[86] = function (reader_pos)
    -- BIT 2, L
    local var_2cf = register_l(reg)
    if bit_band(var_2cf, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[87] = 'BIT 2, (HL)'
opcodes16[87] = function (reader_pos)
    -- BIT 2, (HL)
    local var_2d0 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2d0, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[88] = 'BIT 2, A'
opcodes16[88] = function (reader_pos)
    -- BIT 2, A
    local var_2d1 = register_a(reg)
    if bit_band(var_2d1, 4) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[89] = 'BIT 3, B'
opcodes16[89] = function (reader_pos)
    -- BIT 3, B
    local var_2d2 = register_b(reg)
    if bit_band(var_2d2, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[90] = 'BIT 3, C'
opcodes16[90] = function (reader_pos)
    -- BIT 3, C
    local var_2d3 = register_c(reg)
    if bit_band(var_2d3, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[91] = 'BIT 3, D'
opcodes16[91] = function (reader_pos)
    -- BIT 3, D
    local var_2d4 = register_d(reg)
    if bit_band(var_2d4, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[92] = 'BIT 3, E'
opcodes16[92] = function (reader_pos)
    -- BIT 3, E
    local var_2d5 = register_e(reg)
    if bit_band(var_2d5, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[93] = 'BIT 3, H'
opcodes16[93] = function (reader_pos)
    -- BIT 3, H
    local var_2d6 = register_h(reg)
    if bit_band(var_2d6, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[94] = 'BIT 3, L'
opcodes16[94] = function (reader_pos)
    -- BIT 3, L
    local var_2d7 = register_l(reg)
    if bit_band(var_2d7, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[95] = 'BIT 3, (HL)'
opcodes16[95] = function (reader_pos)
    -- BIT 3, (HL)
    local var_2d8 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2d8, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[96] = 'BIT 3, A'
opcodes16[96] = function (reader_pos)
    -- BIT 3, A
    local var_2d9 = register_a(reg)
    if bit_band(var_2d9, 8) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[97] = 'BIT 4, B'
opcodes16[97] = function (reader_pos)
    -- BIT 4, B
    local var_2da = register_b(reg)
    if bit_band(var_2da, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[98] = 'BIT 4, C'
opcodes16[98] = function (reader_pos)
    -- BIT 4, C
    local var_2db = register_c(reg)
    if bit_band(var_2db, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[99] = 'BIT 4, D'
opcodes16[99] = function (reader_pos)
    -- BIT 4, D
    local var_2dc = register_d(reg)
    if bit_band(var_2dc, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[100] = 'BIT 4, E'
opcodes16[100] = function (reader_pos)
    -- BIT 4, E
    local var_2dd = register_e(reg)
    if bit_band(var_2dd, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[101] = 'BIT 4, H'
opcodes16[101] = function (reader_pos)
    -- BIT 4, H
    local var_2de = register_h(reg)
    if bit_band(var_2de, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[102] = 'BIT 4, L'
opcodes16[102] = function (reader_pos)
    -- BIT 4, L
    local var_2df = register_l(reg)
    if bit_band(var_2df, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[103] = 'BIT 4, (HL)'
opcodes16[103] = function (reader_pos)
    -- BIT 4, (HL)
    local var_2e0 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2e0, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[104] = 'BIT 4, A'
opcodes16[104] = function (reader_pos)
    -- BIT 4, A
    local var_2e1 = register_a(reg)
    if bit_band(var_2e1, 16) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[105] = 'BIT 5, B'
opcodes16[105] = function (reader_pos)
    -- BIT 5, B
    local var_2e2 = register_b(reg)
    if bit_band(var_2e2, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[106] = 'BIT 5, C'
opcodes16[106] = function (reader_pos)
    -- BIT 5, C
    local var_2e3 = register_c(reg)
    if bit_band(var_2e3, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[107] = 'BIT 5, D'
opcodes16[107] = function (reader_pos)
    -- BIT 5, D
    local var_2e4 = register_d(reg)
    if bit_band(var_2e4, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[108] = 'BIT 5, E'
opcodes16[108] = function (reader_pos)
    -- BIT 5, E
    local var_2e5 = register_e(reg)
    if bit_band(var_2e5, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[109] = 'BIT 5, H'
opcodes16[109] = function (reader_pos)
    -- BIT 5, H
    local var_2e6 = register_h(reg)
    if bit_band(var_2e6, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[110] = 'BIT 5, L'
opcodes16[110] = function (reader_pos)
    -- BIT 5, L
    local var_2e7 = register_l(reg)
    if bit_band(var_2e7, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[111] = 'BIT 5, (HL)'
opcodes16[111] = function (reader_pos)
    -- BIT 5, (HL)
    local var_2e8 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2e8, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[112] = 'BIT 5, A'
opcodes16[112] = function (reader_pos)
    -- BIT 5, A
    local var_2e9 = register_a(reg)
    if bit_band(var_2e9, 32) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[113] = 'BIT 6, B'
opcodes16[113] = function (reader_pos)
    -- BIT 6, B
    local var_2ea = register_b(reg)
    if bit_band(var_2ea, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[114] = 'BIT 6, C'
opcodes16[114] = function (reader_pos)
    -- BIT 6, C
    local var_2eb = register_c(reg)
    if bit_band(var_2eb, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[115] = 'BIT 6, D'
opcodes16[115] = function (reader_pos)
    -- BIT 6, D
    local var_2ec = register_d(reg)
    if bit_band(var_2ec, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[116] = 'BIT 6, E'
opcodes16[116] = function (reader_pos)
    -- BIT 6, E
    local var_2ed = register_e(reg)
    if bit_band(var_2ed, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[117] = 'BIT 6, H'
opcodes16[117] = function (reader_pos)
    -- BIT 6, H
    local var_2ee = register_h(reg)
    if bit_band(var_2ee, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[118] = 'BIT 6, L'
opcodes16[118] = function (reader_pos)
    -- BIT 6, L
    local var_2ef = register_l(reg)
    if bit_band(var_2ef, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[119] = 'BIT 6, (HL)'
opcodes16[119] = function (reader_pos)
    -- BIT 6, (HL)
    local var_2f0 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2f0, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[120] = 'BIT 6, A'
opcodes16[120] = function (reader_pos)
    -- BIT 6, A
    local var_2f1 = register_a(reg)
    if bit_band(var_2f1, 64) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[121] = 'BIT 7, B'
opcodes16[121] = function (reader_pos)
    -- BIT 7, B
    local var_2f2 = register_b(reg)
    if bit_band(var_2f2, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[122] = 'BIT 7, C'
opcodes16[122] = function (reader_pos)
    -- BIT 7, C
    local var_2f3 = register_c(reg)
    if bit_band(var_2f3, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[123] = 'BIT 7, D'
opcodes16[123] = function (reader_pos)
    -- BIT 7, D
    local var_2f4 = register_d(reg)
    if bit_band(var_2f4, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[124] = 'BIT 7, E'
opcodes16[124] = function (reader_pos)
    -- BIT 7, E
    local var_2f5 = register_e(reg)
    if bit_band(var_2f5, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[125] = 'BIT 7, H'
opcodes16[125] = function (reader_pos)
    -- BIT 7, H
    local var_2f6 = register_h(reg)
    if bit_band(var_2f6, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[126] = 'BIT 7, L'
opcodes16[126] = function (reader_pos)
    -- BIT 7, L
    local var_2f7 = register_l(reg)
    if bit_band(var_2f7, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[127] = 'BIT 7, (HL)'
opcodes16[127] = function (reader_pos)
    -- BIT 7, (HL)
    local var_2f8 = mmu_get(mem, register_hl(reg))
    if bit_band(var_2f8, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 16
end
opcodes16_names[128] = 'BIT 7, A'
opcodes16[128] = function (reader_pos)
    -- BIT 7, A
    local var_2f9 = register_a(reg)
    if bit_band(var_2f9, 128) == 0 then
            register_set_flag_zf(reg)
    else
            register_unset_flag_zf(reg)
    end
    register_set_pc(reg, register_pc(reg) + 2)
    register_unset_flag_n(reg)
    register_set_flag_h(reg)
    return 8
end
opcodes16_names[129] = 'RES 0, B'
opcodes16[129] = function (reader_pos)
    -- RES 0, B
    local var_2fa = register_b(reg)
    local var_2fb = bit_band(var_2fa, 254)
    register_set_b(reg, var_2fb)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[130] = 'RES 0, C'
opcodes16[130] = function (reader_pos)
    -- RES 0, C
    local var_2fc = register_c(reg)
    local var_2fd = bit_band(var_2fc, 254)
    register_set_c(reg, var_2fd)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[131] = 'RES 0, D'
opcodes16[131] = function (reader_pos)
    -- RES 0, D
    local var_2fe = register_d(reg)
    local var_2ff = bit_band(var_2fe, 254)
    register_set_d(reg, var_2ff)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[132] = 'RES 0, E'
opcodes16[132] = function (reader_pos)
    -- RES 0, E
    local var_300 = register_e(reg)
    local var_301 = bit_band(var_300, 254)
    register_set_e(reg, var_301)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[133] = 'RES 0, H'
opcodes16[133] = function (reader_pos)
    -- RES 0, H
    local var_302 = register_h(reg)
    local var_303 = bit_band(var_302, 254)
    register_set_h(reg, var_303)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[134] = 'RES 0, L'
opcodes16[134] = function (reader_pos)
    -- RES 0, L
    local var_304 = register_l(reg)
    local var_305 = bit_band(var_304, 254)
    register_set_l(reg, var_305)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[135] = 'RES 0, (HL)'
opcodes16[135] = function (reader_pos)
    -- RES 0, (HL)
    local var_306 = mmu_get(mem, register_hl(reg))
    local var_307 = bit_band(var_306, 254)
    mmu_set(mem, register_hl(reg), var_307)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[136] = 'RES 0, A'
opcodes16[136] = function (reader_pos)
    -- RES 0, A
    local var_308 = register_a(reg)
    local var_309 = bit_band(var_308, 254)
    register_set_a(reg, var_309)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[137] = 'RES 1, B'
opcodes16[137] = function (reader_pos)
    -- RES 1, B
    local var_30a = register_b(reg)
    local var_30b = bit_band(var_30a, 253)
    register_set_b(reg, var_30b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[138] = 'RES 1, C'
opcodes16[138] = function (reader_pos)
    -- RES 1, C
    local var_30c = register_c(reg)
    local var_30d = bit_band(var_30c, 253)
    register_set_c(reg, var_30d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[139] = 'RES 1, D'
opcodes16[139] = function (reader_pos)
    -- RES 1, D
    local var_30e = register_d(reg)
    local var_30f = bit_band(var_30e, 253)
    register_set_d(reg, var_30f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[140] = 'RES 1, E'
opcodes16[140] = function (reader_pos)
    -- RES 1, E
    local var_310 = register_e(reg)
    local var_311 = bit_band(var_310, 253)
    register_set_e(reg, var_311)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[141] = 'RES 1, H'
opcodes16[141] = function (reader_pos)
    -- RES 1, H
    local var_312 = register_h(reg)
    local var_313 = bit_band(var_312, 253)
    register_set_h(reg, var_313)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[142] = 'RES 1, L'
opcodes16[142] = function (reader_pos)
    -- RES 1, L
    local var_314 = register_l(reg)
    local var_315 = bit_band(var_314, 253)
    register_set_l(reg, var_315)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[143] = 'RES 1, (HL)'
opcodes16[143] = function (reader_pos)
    -- RES 1, (HL)
    local var_316 = mmu_get(mem, register_hl(reg))
    local var_317 = bit_band(var_316, 253)
    mmu_set(mem, register_hl(reg), var_317)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[144] = 'RES 1, A'
opcodes16[144] = function (reader_pos)
    -- RES 1, A
    local var_318 = register_a(reg)
    local var_319 = bit_band(var_318, 253)
    register_set_a(reg, var_319)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[145] = 'RES 2, B'
opcodes16[145] = function (reader_pos)
    -- RES 2, B
    local var_31a = register_b(reg)
    local var_31b = bit_band(var_31a, 251)
    register_set_b(reg, var_31b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[146] = 'RES 2, C'
opcodes16[146] = function (reader_pos)
    -- RES 2, C
    local var_31c = register_c(reg)
    local var_31d = bit_band(var_31c, 251)
    register_set_c(reg, var_31d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[147] = 'RES 2, D'
opcodes16[147] = function (reader_pos)
    -- RES 2, D
    local var_31e = register_d(reg)
    local var_31f = bit_band(var_31e, 251)
    register_set_d(reg, var_31f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[148] = 'RES 2, E'
opcodes16[148] = function (reader_pos)
    -- RES 2, E
    local var_320 = register_e(reg)
    local var_321 = bit_band(var_320, 251)
    register_set_e(reg, var_321)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[149] = 'RES 2, H'
opcodes16[149] = function (reader_pos)
    -- RES 2, H
    local var_322 = register_h(reg)
    local var_323 = bit_band(var_322, 251)
    register_set_h(reg, var_323)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[150] = 'RES 2, L'
opcodes16[150] = function (reader_pos)
    -- RES 2, L
    local var_324 = register_l(reg)
    local var_325 = bit_band(var_324, 251)
    register_set_l(reg, var_325)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[151] = 'RES 2, (HL)'
opcodes16[151] = function (reader_pos)
    -- RES 2, (HL)
    local var_326 = mmu_get(mem, register_hl(reg))
    local var_327 = bit_band(var_326, 251)
    mmu_set(mem, register_hl(reg), var_327)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[152] = 'RES 2, A'
opcodes16[152] = function (reader_pos)
    -- RES 2, A
    local var_328 = register_a(reg)
    local var_329 = bit_band(var_328, 251)
    register_set_a(reg, var_329)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[153] = 'RES 3, B'
opcodes16[153] = function (reader_pos)
    -- RES 3, B
    local var_32a = register_b(reg)
    local var_32b = bit_band(var_32a, 247)
    register_set_b(reg, var_32b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[154] = 'RES 3, C'
opcodes16[154] = function (reader_pos)
    -- RES 3, C
    local var_32c = register_c(reg)
    local var_32d = bit_band(var_32c, 247)
    register_set_c(reg, var_32d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[155] = 'RES 3, D'
opcodes16[155] = function (reader_pos)
    -- RES 3, D
    local var_32e = register_d(reg)
    local var_32f = bit_band(var_32e, 247)
    register_set_d(reg, var_32f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[156] = 'RES 3, E'
opcodes16[156] = function (reader_pos)
    -- RES 3, E
    local var_330 = register_e(reg)
    local var_331 = bit_band(var_330, 247)
    register_set_e(reg, var_331)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[157] = 'RES 3, H'
opcodes16[157] = function (reader_pos)
    -- RES 3, H
    local var_332 = register_h(reg)
    local var_333 = bit_band(var_332, 247)
    register_set_h(reg, var_333)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[158] = 'RES 3, L'
opcodes16[158] = function (reader_pos)
    -- RES 3, L
    local var_334 = register_l(reg)
    local var_335 = bit_band(var_334, 247)
    register_set_l(reg, var_335)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[159] = 'RES 3, (HL)'
opcodes16[159] = function (reader_pos)
    -- RES 3, (HL)
    local var_336 = mmu_get(mem, register_hl(reg))
    local var_337 = bit_band(var_336, 247)
    mmu_set(mem, register_hl(reg), var_337)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[160] = 'RES 3, A'
opcodes16[160] = function (reader_pos)
    -- RES 3, A
    local var_338 = register_a(reg)
    local var_339 = bit_band(var_338, 247)
    register_set_a(reg, var_339)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[161] = 'RES 4, B'
opcodes16[161] = function (reader_pos)
    -- RES 4, B
    local var_33a = register_b(reg)
    local var_33b = bit_band(var_33a, 239)
    register_set_b(reg, var_33b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[162] = 'RES 4, C'
opcodes16[162] = function (reader_pos)
    -- RES 4, C
    local var_33c = register_c(reg)
    local var_33d = bit_band(var_33c, 239)
    register_set_c(reg, var_33d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[163] = 'RES 4, D'
opcodes16[163] = function (reader_pos)
    -- RES 4, D
    local var_33e = register_d(reg)
    local var_33f = bit_band(var_33e, 239)
    register_set_d(reg, var_33f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[164] = 'RES 4, E'
opcodes16[164] = function (reader_pos)
    -- RES 4, E
    local var_340 = register_e(reg)
    local var_341 = bit_band(var_340, 239)
    register_set_e(reg, var_341)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[165] = 'RES 4, H'
opcodes16[165] = function (reader_pos)
    -- RES 4, H
    local var_342 = register_h(reg)
    local var_343 = bit_band(var_342, 239)
    register_set_h(reg, var_343)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[166] = 'RES 4, L'
opcodes16[166] = function (reader_pos)
    -- RES 4, L
    local var_344 = register_l(reg)
    local var_345 = bit_band(var_344, 239)
    register_set_l(reg, var_345)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[167] = 'RES 4, (HL)'
opcodes16[167] = function (reader_pos)
    -- RES 4, (HL)
    local var_346 = mmu_get(mem, register_hl(reg))
    local var_347 = bit_band(var_346, 239)
    mmu_set(mem, register_hl(reg), var_347)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[168] = 'RES 4, A'
opcodes16[168] = function (reader_pos)
    -- RES 4, A
    local var_348 = register_a(reg)
    local var_349 = bit_band(var_348, 239)
    register_set_a(reg, var_349)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[169] = 'RES 5, B'
opcodes16[169] = function (reader_pos)
    -- RES 5, B
    local var_34a = register_b(reg)
    local var_34b = bit_band(var_34a, 223)
    register_set_b(reg, var_34b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[170] = 'RES 5, C'
opcodes16[170] = function (reader_pos)
    -- RES 5, C
    local var_34c = register_c(reg)
    local var_34d = bit_band(var_34c, 223)
    register_set_c(reg, var_34d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[171] = 'RES 5, D'
opcodes16[171] = function (reader_pos)
    -- RES 5, D
    local var_34e = register_d(reg)
    local var_34f = bit_band(var_34e, 223)
    register_set_d(reg, var_34f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[172] = 'RES 5, E'
opcodes16[172] = function (reader_pos)
    -- RES 5, E
    local var_350 = register_e(reg)
    local var_351 = bit_band(var_350, 223)
    register_set_e(reg, var_351)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[173] = 'RES 5, H'
opcodes16[173] = function (reader_pos)
    -- RES 5, H
    local var_352 = register_h(reg)
    local var_353 = bit_band(var_352, 223)
    register_set_h(reg, var_353)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[174] = 'RES 5, L'
opcodes16[174] = function (reader_pos)
    -- RES 5, L
    local var_354 = register_l(reg)
    local var_355 = bit_band(var_354, 223)
    register_set_l(reg, var_355)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[175] = 'RES 5, (HL)'
opcodes16[175] = function (reader_pos)
    -- RES 5, (HL)
    local var_356 = mmu_get(mem, register_hl(reg))
    local var_357 = bit_band(var_356, 223)
    mmu_set(mem, register_hl(reg), var_357)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[176] = 'RES 5, A'
opcodes16[176] = function (reader_pos)
    -- RES 5, A
    local var_358 = register_a(reg)
    local var_359 = bit_band(var_358, 223)
    register_set_a(reg, var_359)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[177] = 'RES 6, B'
opcodes16[177] = function (reader_pos)
    -- RES 6, B
    local var_35a = register_b(reg)
    local var_35b = bit_band(var_35a, 191)
    register_set_b(reg, var_35b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[178] = 'RES 6, C'
opcodes16[178] = function (reader_pos)
    -- RES 6, C
    local var_35c = register_c(reg)
    local var_35d = bit_band(var_35c, 191)
    register_set_c(reg, var_35d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[179] = 'RES 6, D'
opcodes16[179] = function (reader_pos)
    -- RES 6, D
    local var_35e = register_d(reg)
    local var_35f = bit_band(var_35e, 191)
    register_set_d(reg, var_35f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[180] = 'RES 6, E'
opcodes16[180] = function (reader_pos)
    -- RES 6, E
    local var_360 = register_e(reg)
    local var_361 = bit_band(var_360, 191)
    register_set_e(reg, var_361)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[181] = 'RES 6, H'
opcodes16[181] = function (reader_pos)
    -- RES 6, H
    local var_362 = register_h(reg)
    local var_363 = bit_band(var_362, 191)
    register_set_h(reg, var_363)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[182] = 'RES 6, L'
opcodes16[182] = function (reader_pos)
    -- RES 6, L
    local var_364 = register_l(reg)
    local var_365 = bit_band(var_364, 191)
    register_set_l(reg, var_365)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[183] = 'RES 6, (HL)'
opcodes16[183] = function (reader_pos)
    -- RES 6, (HL)
    local var_366 = mmu_get(mem, register_hl(reg))
    local var_367 = bit_band(var_366, 191)
    mmu_set(mem, register_hl(reg), var_367)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[184] = 'RES 6, A'
opcodes16[184] = function (reader_pos)
    -- RES 6, A
    local var_368 = register_a(reg)
    local var_369 = bit_band(var_368, 191)
    register_set_a(reg, var_369)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[185] = 'RES 7, B'
opcodes16[185] = function (reader_pos)
    -- RES 7, B
    local var_36a = register_b(reg)
    local var_36b = bit_band(var_36a, 127)
    register_set_b(reg, var_36b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[186] = 'RES 7, C'
opcodes16[186] = function (reader_pos)
    -- RES 7, C
    local var_36c = register_c(reg)
    local var_36d = bit_band(var_36c, 127)
    register_set_c(reg, var_36d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[187] = 'RES 7, D'
opcodes16[187] = function (reader_pos)
    -- RES 7, D
    local var_36e = register_d(reg)
    local var_36f = bit_band(var_36e, 127)
    register_set_d(reg, var_36f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[188] = 'RES 7, E'
opcodes16[188] = function (reader_pos)
    -- RES 7, E
    local var_370 = register_e(reg)
    local var_371 = bit_band(var_370, 127)
    register_set_e(reg, var_371)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[189] = 'RES 7, H'
opcodes16[189] = function (reader_pos)
    -- RES 7, H
    local var_372 = register_h(reg)
    local var_373 = bit_band(var_372, 127)
    register_set_h(reg, var_373)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[190] = 'RES 7, L'
opcodes16[190] = function (reader_pos)
    -- RES 7, L
    local var_374 = register_l(reg)
    local var_375 = bit_band(var_374, 127)
    register_set_l(reg, var_375)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[191] = 'RES 7, (HL)'
opcodes16[191] = function (reader_pos)
    -- RES 7, (HL)
    local var_376 = mmu_get(mem, register_hl(reg))
    local var_377 = bit_band(var_376, 127)
    mmu_set(mem, register_hl(reg), var_377)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[192] = 'RES 7, A'
opcodes16[192] = function (reader_pos)
    -- RES 7, A
    local var_378 = register_a(reg)
    local var_379 = bit_band(var_378, 127)
    register_set_a(reg, var_379)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[193] = 'SET 0, B'
opcodes16[193] = function (reader_pos)
    -- SET 0, B
    local var_37a = register_b(reg)
    local var_37b = bit_bor(var_37a, 1)
    register_set_b(reg, var_37b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[194] = 'SET 0, C'
opcodes16[194] = function (reader_pos)
    -- SET 0, C
    local var_37c = register_c(reg)
    local var_37d = bit_bor(var_37c, 1)
    register_set_c(reg, var_37d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[195] = 'SET 0, D'
opcodes16[195] = function (reader_pos)
    -- SET 0, D
    local var_37e = register_d(reg)
    local var_37f = bit_bor(var_37e, 1)
    register_set_d(reg, var_37f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[196] = 'SET 0, E'
opcodes16[196] = function (reader_pos)
    -- SET 0, E
    local var_380 = register_e(reg)
    local var_381 = bit_bor(var_380, 1)
    register_set_e(reg, var_381)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[197] = 'SET 0, H'
opcodes16[197] = function (reader_pos)
    -- SET 0, H
    local var_382 = register_h(reg)
    local var_383 = bit_bor(var_382, 1)
    register_set_h(reg, var_383)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[198] = 'SET 0, L'
opcodes16[198] = function (reader_pos)
    -- SET 0, L
    local var_384 = register_l(reg)
    local var_385 = bit_bor(var_384, 1)
    register_set_l(reg, var_385)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[199] = 'SET 0, (HL)'
opcodes16[199] = function (reader_pos)
    -- SET 0, (HL)
    local var_386 = mmu_get(mem, register_hl(reg))
    local var_387 = bit_bor(var_386, 1)
    mmu_set(mem, register_hl(reg), var_387)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[200] = 'SET 0, A'
opcodes16[200] = function (reader_pos)
    -- SET 0, A
    local var_388 = register_a(reg)
    local var_389 = bit_bor(var_388, 1)
    register_set_a(reg, var_389)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[201] = 'SET 1, B'
opcodes16[201] = function (reader_pos)
    -- SET 1, B
    local var_38a = register_b(reg)
    local var_38b = bit_bor(var_38a, 2)
    register_set_b(reg, var_38b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[202] = 'SET 1, C'
opcodes16[202] = function (reader_pos)
    -- SET 1, C
    local var_38c = register_c(reg)
    local var_38d = bit_bor(var_38c, 2)
    register_set_c(reg, var_38d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[203] = 'SET 1, D'
opcodes16[203] = function (reader_pos)
    -- SET 1, D
    local var_38e = register_d(reg)
    local var_38f = bit_bor(var_38e, 2)
    register_set_d(reg, var_38f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[204] = 'SET 1, E'
opcodes16[204] = function (reader_pos)
    -- SET 1, E
    local var_390 = register_e(reg)
    local var_391 = bit_bor(var_390, 2)
    register_set_e(reg, var_391)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[205] = 'SET 1, H'
opcodes16[205] = function (reader_pos)
    -- SET 1, H
    local var_392 = register_h(reg)
    local var_393 = bit_bor(var_392, 2)
    register_set_h(reg, var_393)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[206] = 'SET 1, L'
opcodes16[206] = function (reader_pos)
    -- SET 1, L
    local var_394 = register_l(reg)
    local var_395 = bit_bor(var_394, 2)
    register_set_l(reg, var_395)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[207] = 'SET 1, (HL)'
opcodes16[207] = function (reader_pos)
    -- SET 1, (HL)
    local var_396 = mmu_get(mem, register_hl(reg))
    local var_397 = bit_bor(var_396, 2)
    mmu_set(mem, register_hl(reg), var_397)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[208] = 'SET 1, A'
opcodes16[208] = function (reader_pos)
    -- SET 1, A
    local var_398 = register_a(reg)
    local var_399 = bit_bor(var_398, 2)
    register_set_a(reg, var_399)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[209] = 'SET 2, B'
opcodes16[209] = function (reader_pos)
    -- SET 2, B
    local var_39a = register_b(reg)
    local var_39b = bit_bor(var_39a, 4)
    register_set_b(reg, var_39b)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[210] = 'SET 2, C'
opcodes16[210] = function (reader_pos)
    -- SET 2, C
    local var_39c = register_c(reg)
    local var_39d = bit_bor(var_39c, 4)
    register_set_c(reg, var_39d)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[211] = 'SET 2, D'
opcodes16[211] = function (reader_pos)
    -- SET 2, D
    local var_39e = register_d(reg)
    local var_39f = bit_bor(var_39e, 4)
    register_set_d(reg, var_39f)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[212] = 'SET 2, E'
opcodes16[212] = function (reader_pos)
    -- SET 2, E
    local var_3a0 = register_e(reg)
    local var_3a1 = bit_bor(var_3a0, 4)
    register_set_e(reg, var_3a1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[213] = 'SET 2, H'
opcodes16[213] = function (reader_pos)
    -- SET 2, H
    local var_3a2 = register_h(reg)
    local var_3a3 = bit_bor(var_3a2, 4)
    register_set_h(reg, var_3a3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[214] = 'SET 2, L'
opcodes16[214] = function (reader_pos)
    -- SET 2, L
    local var_3a4 = register_l(reg)
    local var_3a5 = bit_bor(var_3a4, 4)
    register_set_l(reg, var_3a5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[215] = 'SET 2, (HL)'
opcodes16[215] = function (reader_pos)
    -- SET 2, (HL)
    local var_3a6 = mmu_get(mem, register_hl(reg))
    local var_3a7 = bit_bor(var_3a6, 4)
    mmu_set(mem, register_hl(reg), var_3a7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[216] = 'SET 2, A'
opcodes16[216] = function (reader_pos)
    -- SET 2, A
    local var_3a8 = register_a(reg)
    local var_3a9 = bit_bor(var_3a8, 4)
    register_set_a(reg, var_3a9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[217] = 'SET 3, B'
opcodes16[217] = function (reader_pos)
    -- SET 3, B
    local var_3aa = register_b(reg)
    local var_3ab = bit_bor(var_3aa, 8)
    register_set_b(reg, var_3ab)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[218] = 'SET 3, C'
opcodes16[218] = function (reader_pos)
    -- SET 3, C
    local var_3ac = register_c(reg)
    local var_3ad = bit_bor(var_3ac, 8)
    register_set_c(reg, var_3ad)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[219] = 'SET 3, D'
opcodes16[219] = function (reader_pos)
    -- SET 3, D
    local var_3ae = register_d(reg)
    local var_3af = bit_bor(var_3ae, 8)
    register_set_d(reg, var_3af)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[220] = 'SET 3, E'
opcodes16[220] = function (reader_pos)
    -- SET 3, E
    local var_3b0 = register_e(reg)
    local var_3b1 = bit_bor(var_3b0, 8)
    register_set_e(reg, var_3b1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[221] = 'SET 3, H'
opcodes16[221] = function (reader_pos)
    -- SET 3, H
    local var_3b2 = register_h(reg)
    local var_3b3 = bit_bor(var_3b2, 8)
    register_set_h(reg, var_3b3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[222] = 'SET 3, L'
opcodes16[222] = function (reader_pos)
    -- SET 3, L
    local var_3b4 = register_l(reg)
    local var_3b5 = bit_bor(var_3b4, 8)
    register_set_l(reg, var_3b5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[223] = 'SET 3, (HL)'
opcodes16[223] = function (reader_pos)
    -- SET 3, (HL)
    local var_3b6 = mmu_get(mem, register_hl(reg))
    local var_3b7 = bit_bor(var_3b6, 8)
    mmu_set(mem, register_hl(reg), var_3b7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[224] = 'SET 3, A'
opcodes16[224] = function (reader_pos)
    -- SET 3, A
    local var_3b8 = register_a(reg)
    local var_3b9 = bit_bor(var_3b8, 8)
    register_set_a(reg, var_3b9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[225] = 'SET 4, B'
opcodes16[225] = function (reader_pos)
    -- SET 4, B
    local var_3ba = register_b(reg)
    local var_3bb = bit_bor(var_3ba, 16)
    register_set_b(reg, var_3bb)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[226] = 'SET 4, C'
opcodes16[226] = function (reader_pos)
    -- SET 4, C
    local var_3bc = register_c(reg)
    local var_3bd = bit_bor(var_3bc, 16)
    register_set_c(reg, var_3bd)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[227] = 'SET 4, D'
opcodes16[227] = function (reader_pos)
    -- SET 4, D
    local var_3be = register_d(reg)
    local var_3bf = bit_bor(var_3be, 16)
    register_set_d(reg, var_3bf)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[228] = 'SET 4, E'
opcodes16[228] = function (reader_pos)
    -- SET 4, E
    local var_3c0 = register_e(reg)
    local var_3c1 = bit_bor(var_3c0, 16)
    register_set_e(reg, var_3c1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[229] = 'SET 4, H'
opcodes16[229] = function (reader_pos)
    -- SET 4, H
    local var_3c2 = register_h(reg)
    local var_3c3 = bit_bor(var_3c2, 16)
    register_set_h(reg, var_3c3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[230] = 'SET 4, L'
opcodes16[230] = function (reader_pos)
    -- SET 4, L
    local var_3c4 = register_l(reg)
    local var_3c5 = bit_bor(var_3c4, 16)
    register_set_l(reg, var_3c5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[231] = 'SET 4, (HL)'
opcodes16[231] = function (reader_pos)
    -- SET 4, (HL)
    local var_3c6 = mmu_get(mem, register_hl(reg))
    local var_3c7 = bit_bor(var_3c6, 16)
    mmu_set(mem, register_hl(reg), var_3c7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[232] = 'SET 4, A'
opcodes16[232] = function (reader_pos)
    -- SET 4, A
    local var_3c8 = register_a(reg)
    local var_3c9 = bit_bor(var_3c8, 16)
    register_set_a(reg, var_3c9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[233] = 'SET 5, B'
opcodes16[233] = function (reader_pos)
    -- SET 5, B
    local var_3ca = register_b(reg)
    local var_3cb = bit_bor(var_3ca, 32)
    register_set_b(reg, var_3cb)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[234] = 'SET 5, C'
opcodes16[234] = function (reader_pos)
    -- SET 5, C
    local var_3cc = register_c(reg)
    local var_3cd = bit_bor(var_3cc, 32)
    register_set_c(reg, var_3cd)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[235] = 'SET 5, D'
opcodes16[235] = function (reader_pos)
    -- SET 5, D
    local var_3ce = register_d(reg)
    local var_3cf = bit_bor(var_3ce, 32)
    register_set_d(reg, var_3cf)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[236] = 'SET 5, E'
opcodes16[236] = function (reader_pos)
    -- SET 5, E
    local var_3d0 = register_e(reg)
    local var_3d1 = bit_bor(var_3d0, 32)
    register_set_e(reg, var_3d1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[237] = 'SET 5, H'
opcodes16[237] = function (reader_pos)
    -- SET 5, H
    local var_3d2 = register_h(reg)
    local var_3d3 = bit_bor(var_3d2, 32)
    register_set_h(reg, var_3d3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[238] = 'SET 5, L'
opcodes16[238] = function (reader_pos)
    -- SET 5, L
    local var_3d4 = register_l(reg)
    local var_3d5 = bit_bor(var_3d4, 32)
    register_set_l(reg, var_3d5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[239] = 'SET 5, (HL)'
opcodes16[239] = function (reader_pos)
    -- SET 5, (HL)
    local var_3d6 = mmu_get(mem, register_hl(reg))
    local var_3d7 = bit_bor(var_3d6, 32)
    mmu_set(mem, register_hl(reg), var_3d7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[240] = 'SET 5, A'
opcodes16[240] = function (reader_pos)
    -- SET 5, A
    local var_3d8 = register_a(reg)
    local var_3d9 = bit_bor(var_3d8, 32)
    register_set_a(reg, var_3d9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[241] = 'SET 6, B'
opcodes16[241] = function (reader_pos)
    -- SET 6, B
    local var_3da = register_b(reg)
    local var_3db = bit_bor(var_3da, 64)
    register_set_b(reg, var_3db)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[242] = 'SET 6, C'
opcodes16[242] = function (reader_pos)
    -- SET 6, C
    local var_3dc = register_c(reg)
    local var_3dd = bit_bor(var_3dc, 64)
    register_set_c(reg, var_3dd)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[243] = 'SET 6, D'
opcodes16[243] = function (reader_pos)
    -- SET 6, D
    local var_3de = register_d(reg)
    local var_3df = bit_bor(var_3de, 64)
    register_set_d(reg, var_3df)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[244] = 'SET 6, E'
opcodes16[244] = function (reader_pos)
    -- SET 6, E
    local var_3e0 = register_e(reg)
    local var_3e1 = bit_bor(var_3e0, 64)
    register_set_e(reg, var_3e1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[245] = 'SET 6, H'
opcodes16[245] = function (reader_pos)
    -- SET 6, H
    local var_3e2 = register_h(reg)
    local var_3e3 = bit_bor(var_3e2, 64)
    register_set_h(reg, var_3e3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[246] = 'SET 6, L'
opcodes16[246] = function (reader_pos)
    -- SET 6, L
    local var_3e4 = register_l(reg)
    local var_3e5 = bit_bor(var_3e4, 64)
    register_set_l(reg, var_3e5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[247] = 'SET 6, (HL)'
opcodes16[247] = function (reader_pos)
    -- SET 6, (HL)
    local var_3e6 = mmu_get(mem, register_hl(reg))
    local var_3e7 = bit_bor(var_3e6, 64)
    mmu_set(mem, register_hl(reg), var_3e7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[248] = 'SET 6, A'
opcodes16[248] = function (reader_pos)
    -- SET 6, A
    local var_3e8 = register_a(reg)
    local var_3e9 = bit_bor(var_3e8, 64)
    register_set_a(reg, var_3e9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[249] = 'SET 7, B'
opcodes16[249] = function (reader_pos)
    -- SET 7, B
    local var_3ea = register_b(reg)
    local var_3eb = bit_bor(var_3ea, 128)
    register_set_b(reg, var_3eb)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[250] = 'SET 7, C'
opcodes16[250] = function (reader_pos)
    -- SET 7, C
    local var_3ec = register_c(reg)
    local var_3ed = bit_bor(var_3ec, 128)
    register_set_c(reg, var_3ed)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[251] = 'SET 7, D'
opcodes16[251] = function (reader_pos)
    -- SET 7, D
    local var_3ee = register_d(reg)
    local var_3ef = bit_bor(var_3ee, 128)
    register_set_d(reg, var_3ef)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[252] = 'SET 7, E'
opcodes16[252] = function (reader_pos)
    -- SET 7, E
    local var_3f0 = register_e(reg)
    local var_3f1 = bit_bor(var_3f0, 128)
    register_set_e(reg, var_3f1)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[253] = 'SET 7, H'
opcodes16[253] = function (reader_pos)
    -- SET 7, H
    local var_3f2 = register_h(reg)
    local var_3f3 = bit_bor(var_3f2, 128)
    register_set_h(reg, var_3f3)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[254] = 'SET 7, L'
opcodes16[254] = function (reader_pos)
    -- SET 7, L
    local var_3f4 = register_l(reg)
    local var_3f5 = bit_bor(var_3f4, 128)
    register_set_l(reg, var_3f5)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
opcodes16_names[255] = 'SET 7, (HL)'
opcodes16[255] = function (reader_pos)
    -- SET 7, (HL)
    local var_3f6 = mmu_get(mem, register_hl(reg))
    local var_3f7 = bit_bor(var_3f6, 128)
    mmu_set(mem, register_hl(reg), var_3f7)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 16
end
opcodes16_names[256] = 'SET 7, A'
opcodes16[256] = function (reader_pos)
    -- SET 7, A
    local var_3f8 = register_a(reg)
    local var_3f9 = bit_bor(var_3f8, 128)
    register_set_a(reg, var_3f9)
    if false then

    else

    end
    register_set_pc(reg, register_pc(reg) + 2)
    return 8
end
return opcodes, opcodes_names, opcodes16, opcodes16_names
end