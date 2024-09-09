(*  REM ***** MORTGAGE *****

   Business Program  
   Mortgage -- Version #1 (7/31/69)

   ***** Mortgage Analysis *****

  $Id: mortgage.pas,v 0.31 2024/09/07 22:11:22 kc4zvw Exp kc4zvw $

 *)

program Mortgage;

uses
	Math;

const
	Bell = ^G;
	Tab = ^I;

type
	array_type = array [1 .. 12] of Integer; 

var
	A, A1		 		: real;
	C			 		: real;
	M, M1, M2, M3	: integer;
	N					: integer;
	N2					: real;
	Inner				: integer;
	I1					: real;
	Outer				: integer;
	P, P1				: real;
	Q					: real;
	R, R1				: real;
	S1, S2			: real;
	T1, T2, T3		: integer;
	Y					: integer;
	Z, Z1, Z2		: integer;

label L150, L200, L220, L260, L300, L330, L470, L530, L580, L610,
	  L660, L730, L770, L830, L950, L970, L990, L1000, L1120, L1140,
	  L1230, L1280, L1360, L1370, L1470, L1590, L1620, L1660, L1690, L1700;

function Tabulate(n : Integer) : string;
begin
	Tabulate := '    ';
end;

begin
	WriteLn; 
	WriteLn(' *  Mortgage Analysis  *');
	WriteLn; 
	WriteLn(' If you want to find: ');
	WriteLn('      The rate, Type ''1''');
	WriteLn('      The life, Type ''2''');
	WriteLn('      The amount borrowed, Type ''3''');
	WriteLn('      The monthly payment, Type ''4''');
	WriteLn; 
	Write(' Which do you want?  ');
	ReadLn(Z);

	WriteLn;
	if Z = 1 then goto L220;
L150:
	WriteLn('What is the nominal annual rate using decimal notation');
	ReadLn( R );
	if R < 1 then goto L200;
	WriteLn('It appears that you have forgotten to use decimal notation');
	goto L150;
L200:
	WriteLn; 
	if Z = 2 then goto L260;
L220:
	WriteLn('What is the life of the mortgage: Years, Months');
	ReadLn( Y, M );
	WriteLn; 
	if Z = 3 then goto L300;
L260:
	WriteLn('What is the amount to be borrowed');
	ReadLn(A);
	WriteLn; 
	if Z = 4 then goto L330;
L300:
	WriteLn('What is the amount of one monthly payment');
	ReadLn(P);
	WriteLn; 
L330:
	WriteLn('What is the month (Jan=1, etc.), and year in which the mortgage loan is');
	WriteLn('to be made');
	ReadLn( T1, T2 );
	WriteLn; 
	WriteLn('For how many calendar years do you want the mortgage table printed');
	ReadLn( T3 );
	WriteLn; 
	WriteLn('Type a One (1) if you want only an annual summary of the mortgage table');
	WriteLn('Type a Zero (0) for a monthly table');
	ReadLn(Z1);
	WriteLn; 


	if Z = 2 then goto L470;
	N := 12 * (Y + M);
	if Z = 1 then goto L660;

L470:
	R1 := R / 12;
	if Z = 3 then goto L580;
	if Z = 4 then goto L610;
	if (A * R1 / P) < 1 then goto L530;

	WriteLn('The first months payment will not even cover its interest charge');


L530:
	N2 := -(Log2(1 - (A * R1) / P) / Log2(1 + R1));
	N := Trunc(N2) + 1;
	Y := Trunc(N2 / 12);
	M := N - 12 * Y;
	goto L770;

L580:
	A := (P * (1 - 1 / (power((1 + R1),N)))) / R1;
	A := Int((A + 5) / 10) * 10;
	goto L770;

L610:
	P := (A * R1) / (1 - 1 / (power((1 + R1), N)));
	P := (P * 1000 + 5) / 10;
	P := Int(P);
	P := P / 100;
	goto L770;

L660:
	R1 := 0;
	for Outer := 1 to 5 do begin
		for Inner := 1 to 10 do begin
			Q := Inner * (1 / (power(10, Outer))) + R1;
			C := (P * (1 - 1 / (power((1 + Q), N)))) / Q;
			if C < A then goto L730;
		end; { I }

L730:
		R1 := Q - (1 / (power(10, Outer)));
	end; { Outer }

	R1 := Int(24000 * R1 + 0.5) / 24000;
	R := 12 * R1;

L770:
	WriteLn;

	if 12 * P > (R * A + 1) then goto L830;

	WriteLn('Your first years''s payments are ', (12 * P):8:2 );
	WriteLn('The first years''s interest is', (R * A):8:2 );
	WriteLn('Therefore, the life of the mortgage is undefined');
	WriteLn; 

L830:
	WriteLn('***********************************************************************');
	WriteLn; 
	WriteLn('                            Mortgage Terms');
	WriteLn; 
	WriteLn('      Nominal annual rate = ', (R * 100):5:2, ' percent');
	WriteLn('      Life of mortgage = ', Y, ' Years, ', M, ' Months');
	WriteLn('      Amount borrowed = $', A:9:2);
	WriteLn('      Monthly payment = $', P:9:2);

	if Z = 1 then goto L950;
	if Z = 3 then goto L990;
	if Z = 2 then goto L970;
	goto L1000;
L950:  WriteLn('  (Note: The annual rate has been rounded to nearest 1/100 percent)');
	goto L1000;
L970:  WriteLn('  (Note: The mortgage life has been rounded upward to nearest month)');
	goto L1000;
L990:  WriteLn('  (Note: The amount borrowed rounded to nearest $10');

L1000:
	WriteLn;
	WriteLn('----------------------------------------------------------------------');
	WriteLn;
	WriteLn('                           Mortgage Table');
	WriteLn;
	WriteLn;

	Z2 := 0;
	S1 := 0;
	S2 := 0;
	if T1 = 12 then goto L1120;
	M2 := T1;
	goto L1140;
L1120:
	T2 := T2 + 1;
	M2 := 0;
L1140:
	M3 := M2 + 1;
	if Z1 = 1 then goto L1230;

	WriteLn('                               Beginning');
	WriteLn('                               Principal      Principal');
	WriteLn(' Month         Outstanding     Interest       Repayment');
	WriteLn;
	WriteLn;
	WriteLn('    for the calendar year ', T2);

	goto L1280;

L1230:
	WriteLn('                                 Ending ');
	WriteLn('                                 Principal      Principal ');
	WriteLn(' Year             Interest       Repayment      Outstanding');
	WriteLn; 
	WriteLn; 

L1280:
	for M1 := M3 to 12 * T3 do begin
		I1 := A * R1;
		I1 := (I1 * 1000 + 5) / 10;
		I1 := Int(I1);
		I1 := I1 / 100;
		if P < (A + I1) then goto L1360;
		P1 := A;
		goto L1370;

L1360:
		P1 := P - I1;

L1370:
		A1 := A;
		A := A1 - P1;
		S1 := S1 + I1;
		S2 := S2 + P1;
		M2 := M2 + 1;
		if Z1 = 1 then goto L1590;
		WriteLn( M2:5, Tab, A1:15:2, Tab, I1:15:2, Tab, P1:20:2 );
		if M2 = 12 then goto L1470;
		if A > 0 then goto L1690;
		Z2 := 1;

L1470:
		WriteLn; 
		WriteLn('      Interest paid during ', T2,  '            =', S1:10:2);
		WriteLn('      Principle repaid during ', T2, '         =', S2:10:2);
		WriteLn('      Principle outstanding at year end    =', A:10:2);

		if Z2 = 1 then goto L1700;
		T2 := T2 + 1;

		WriteLn; 
		WriteLn(' -----');
		WriteLn; 
	
		if M1 = 12 * T3 then goto L1700;
		WriteLn('         for the calendar year ', T2);
		WriteLn; 
		goto L1660;

L1590:
		if M2 = 12 then goto L1620;
		if A > 0 then goto L1690;
		Z2 := 1;
L1620:
		WriteLn( T2:5, Tab, S1:15:2, Tab, S2:15:2, Tab, A:20:2 );
		T2 := T2 + 1;
		if M1 = 12 * T3 then goto L1700;
		if Z2 = 1 then goto L1700;
L1660:
		S1 := 0;
		S2 := 0;
		M2 := 0;
L1690:
	end; { M1 }

L1700:
	WriteLn;
	WriteLn('');
	WriteLn('**********************************************************************');

end.

(* REM ---------------------------------- *)

(*
 *   vim: nowrap tabstop=3:
 *)

{ *** End of File *** }
