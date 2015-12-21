-------------------------------------------------------------------------------
-- Copyright (c) 2015, Daniel King
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * The name of the copyright holder may not be used to endorse or promote
--       Products derived from this software without specific prior written
--       permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
-- THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------
with Interfaces;
with Keccak.Duplex;
with Keccak.KeccakF;
with Keccak.KeccakF.Byte_Lanes;
with Keccak.Padding;
with Keccak.Sponge;

pragma Elaborate_All(Keccak.Duplex);
pragma Elaborate_All(Keccak.KeccakF);
pragma Elaborate_All(Keccak.KeccakF.Byte_Lanes);
pragma Elaborate_All(Keccak.Sponge);

package Keccak.Keccak_800
with SPARK_Mode => On
is

   package KeccakF_800 is new Keccak.KeccakF
     (L           => 5,
      Lane_Type   => Interfaces.Unsigned_32,
      Shift_Left  => Interfaces.Shift_Left,
      Shift_Right => Interfaces.Shift_Right,
      Rotate_Left => Interfaces.Rotate_Left);

   package KeccakF_800_Lanes is new KeccakF_800.Byte_Lanes;

   package Sponge is new Keccak.Sponge
     (State_Size          => KeccakF_800.B,
      State_Type          => KeccakF_800.State,
      Init_State          => KeccakF_800.Init,
      F                   => KeccakF_800.Permute,
      XOR_Bits_Into_State => KeccakF_800_Lanes.XOR_Bits_Into_State,
      Extract_Data        => KeccakF_800_Lanes.Extract_Bytes,
      Pad                 => Keccak.Padding.Pad101_Multi_Blocks);

   package Duplex is new Keccak.Duplex
     (State_Size          => KeccakF_800.B,
      State_Type          => KeccakF_800.State,
      Init_State          => KeccakF_800.Init,
      F                   => KeccakF_800.Permute,
      XOR_Bits_Into_State => KeccakF_800_Lanes.XOR_Bits_Into_State,
      Extract_Bits        => KeccakF_800_Lanes.Extract_Bits,
      Pad                 => Keccak.Padding.Pad101_Single_Block,
      Min_Padding_Bits    => Keccak.Padding.Pad101_Min_Bits);


end Keccak.Keccak_800;
