with Ada.Numerics.Discrete_Random, Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body Assgn is 
  --initialize first array (My_Array) with random binary values
  procedure Init_Array (Arr: in out BINARY_ARRAY) is
    package RNG is new Ada.Numerics.Discrete_Random (BINARY_NUMBER);
    use RNG;
    G : Generator;
  begin
    Reset(G);
    for i in 1..16 loop
      Arr (i) := Random(G);
    end loop;
  end Init_Array;

  --reverse binary array
  procedure Reverse_Bin_Arr (Arr : in out BINARY_ARRAY) is
  begin
    for i in 1..8 loop
      Arr (i) := Arr(17 - i);
    end loop;
  end Reverse_Bin_Arr;

  --print an array
  procedure Print_Bin_Arr (Arr : in BINARY_ARRAY) is
  begin
    for i in 1..16 loop
      Put(Arr (i));
    end loop;
    New_Line;
  end Print_Bin_Arr;

  --Convert Integer to Binary Array
  function Int_To_Bin(Num : in INTEGER) return BINARY_ARRAY is
    A : BINARY_ARRAY;
    X : INTEGER := Num;
  begin
    for i in 1..16 loop
      A (i) := X mod 2;
      X := X / 2;
    end loop;
    Reverse_Bin_Arr(A);
    return A;
  end Int_To_Bin;

  --convert binary number to integer
  function Bin_To_Int (Arr : in BINARY_ARRAY) return INTEGER is
    A : INTEGER := 0;
  begin
    for i in 1..16 loop
      A := (2 * A) + Arr (i);
    end loop;
    return A;
  end Bin_To_Int;

  --overloaded + operator to add two BINARY_ARRAY types together
  function "+" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
  begin
    return Int_To_Bin(Bin_To_Int(Left) + Bin_To_Int(Right));
  end "+";

  --overloaded + operator to add an INTEGER type and a BINARY_ARRAY type together
  function "+" (Left : in INTEGER; Right : in BINARY_ARRAY) return BINARY_ARRAY is
    X : BINARY_ARRAY;
  begin
    X := Int_To_Bin(Left);
    return X + Right;
  end "+";

  --overloaded - operator to subtract one BINARY_ARRAY type from another			 
  function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
  begin
    return Int_To_Bin(Bin_To_Int(Left) - Bin_To_Int(Right));
  end "-";

  --overloaded - operator to subtract a BINARY_ARRAY type from an INTEGER type
  function "-" (Left : in Integer; Right : in BINARY_ARRAY) return BINARY_ARRAY is
    X : BINARY_ARRAY;
  begin
    X := Int_To_Bin(Left);
    return X - Right;
  end "-";
end Assgn;
