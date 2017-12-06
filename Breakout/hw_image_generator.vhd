--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY hw_image_generator IS
	PORT(
		rst 			:	IN 	STD_LOGIC;
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		clk			:  IN		STD_LOGIC;	--50 MHz input clock from board
		newKey		:	IN		STD_LOGIC;
		key			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --blue magnitude output to DAC
		a1				:	OUT	STD_LOGIC;
		a2				:	OUT	STD_LOGIC;
		a3				:	OUT	STD_LOGIC;
		a4				:	OUT	STD_LOGIC;
		a5				:	OUT	STD_LOGIC;
		a6				:	OUT	STD_LOGIC;
		a7				:	OUT	STD_LOGIC;
		a8				:	OUT	STD_LOGIC;
		a9				:	OUT	STD_LOGIC;
		a10			:	OUT	STD_LOGIC;
		a11			:	OUT	STD_LOGIC;
		a12			:	OUT	STD_LOGIC;
		a13			:	OUT	STD_LOGIC;
		a14			:	OUT	STD_LOGIC;
		d1				:	OUT	STD_LOGIC;
		d2				:	OUT	STD_LOGIC;
		d3				:	OUT	STD_LOGIC;
		d4				:	OUT	STD_LOGIC;
		l1				:	OUT	STD_LOGIC;
		l2				:	OUT	STD_LOGIC;
		l3				:	OUT	STD_LOGIC;
		l4				:	OUT	STD_LOGIC;
		l5				:	OUT	STD_LOGIC;
		l6				:	OUT	STD_LOGIC;
		l7				:	OUT	STD_LOGIC);
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS

	signal level : INTEGER := 1;
	signal newLevel : STD_LOGIC := '1';

	signal lbutton : STD_LOGIC := '1';
	signal rbutton : STD_LOGIC := '1';
	signal offKey : STD_LOGIC := '0';
	signal lastKey : STD_LOGIC_VECTOR(7 downto 0);

	CONSTANT topborder : INTEGER := 75;
	CONSTANT leftBorder : INTEGER := 50;
	CONSTANT brickGap : INTEGER := 50;
	CONSTANT sideGap : INTEGER := 45;
	CONSTANT wid : INTEGER := (1280-(2*leftBorder)-(4*sideGap))/5;
	CONSTANT hght : INTEGER := 45;

	signal b1 : STD_LOGIC := '1';
	CONSTANT b1y : INTEGER := leftBorder;
	CONSTANT b1x : INTEGER := topborder;
	
	signal b2 : STD_LOGIC := '1';
	CONSTANT b2y : INTEGER := leftBorder+wid+sideGap;
	CONSTANT b2x : INTEGER := topborder;
	
	signal b3 : STD_LOGIC := '1';
	CONSTANT b3y : INTEGER := leftBorder+(2*(wid+sideGap));
	CONSTANT b3x : INTEGER := topborder;
	
	signal b4 : STD_LOGIC := '1';
	CONSTANT b4y : INTEGER := leftBorder+(3*(wid+sideGap));
	CONSTANT b4x : INTEGER := topborder;
	
	
	signal nk : STD_LOGIC := '0'; 
	
	signal b5 : STD_LOGIC := '1';
	CONSTANT b5y : INTEGER := leftBorder+(4*(wid+sideGap));
	CONSTANT b5x : INTEGER := topborder;
	
	signal b6 : STD_LOGIC := '1';
	CONSTANT b6y : INTEGER := leftBorder;
	CONSTANT b6x : INTEGER := topborder+hght+brickGap;
	
	signal b7 : STD_LOGIC := '1';
	CONSTANT b7y : INTEGER := leftBorder+wid+sideGap;
	CONSTANT b7x : INTEGER := topborder+hght+brickGap;
	
	signal b8 : STD_LOGIC := '1';
	CONSTANT b8y : INTEGER := leftBorder+(2*(wid+sideGap));
	CONSTANT b8x : INTEGER := topborder+hght+brickGap;
	
	signal b9 : STD_LOGIC := '1';
	CONSTANT b9y : INTEGER := leftBorder+(3*(wid+sideGap));
	CONSTANT b9x : INTEGER := topborder+hght+brickGap;
	
	signal b10 : STD_LOGIC := '1';
	CONSTANT b10y : INTEGER := leftBorder+(4*(wid+sideGap));
	CONSTANT b10x : INTEGER := topborder+hght+brickGap;
	
	signal b11 : STD_LOGIC := '1';
	CONSTANT b11y : INTEGER := leftBorder;
	CONSTANT b11x : INTEGER := topborder+(2*hght)+(2*brickGap);
	
	signal b12 : STD_LOGIC := '1';
	CONSTANT b12y : INTEGER := leftBorder+wid+sideGap;
	CONSTANT b12x : INTEGER := topborder+(2*hght)+(2*brickGap);
	
	signal b13 : STD_LOGIC := '1';
	CONSTANT b13y : INTEGER := leftBorder+(2*(wid+sideGap));
	CONSTANT b13x : INTEGER := topborder+(2*hght)+(2*brickGap);
	
	signal b14 : STD_LOGIC := '1';
	CONSTANT b14y : INTEGER := leftBorder+(3*(wid+sideGap));
	CONSTANT b14x : INTEGER := topborder+(2*hght)+(2*brickGap);
	
	signal b15 : STD_LOGIC := '1';
	CONSTANT b15y : INTEGER := leftBorder+(4*(wid+sideGap));
	CONSTANT b15x : INTEGER := topborder+(2*hght)+(2*brickGap);
	
	signal counter1 : STD_LOGIC_VECTOR(24 downto 0);
	CONSTANT movespeed : INTEGER := 250;
	CONSTANT padw : INTEGER := 200;
	CONSTANT padh : INTEGER := 60;
	CONSTANT padiny : INTEGER := (1280-padw)/2;
	signal pady : INTEGER :=  padiny;
	CONSTANT padx : INTEGER := 1024-topborder-padh;
	
	signal counter2 : STD_LOGIC_VECTOR(24 downto 0);
	CONSTANT blocks : INTEGER:= 40;
	signal blockspeed : INTEGER := 150;
	signal speed : INTEGER := blockspeed;
	CONSTANT blockiny : INTEGER := (1280-blocks)/2;
	CONSTANT blockinx : INTEGER := 1024/2;
	signal blocky : INTEGER := blockiny;
	signal blockx : INTEGER := blockinx;
	signal posy : STD_LOGIC := '1';
	signal posx : STD_LOGIC := '1';
	
	signal score: INTEGER := 0;
	
	CONSTANT lives : INTEGER := 4;
	signal death: INTEGER := lives;
	
	signal tempscore : INTEGER :=0;
	signal digit : INTEGER :=0;
	
	signal delay  : STD_LOGIC := '1';
	signal delayco : STD_LOGIC_VECTOR(100 downto 0);
	
	signal off : STD_LOGIC := '0';
	
	BEGIN

	clk_div: PROCESS(clk)
	BEGIN
		if rising_edge(clk) then
			if delay='1'then
				if(delayco < "10011000100101101000000000")then
					blocky <= blockiny;
					blockx <= blockinx;
					pady <= padiny;
					delayco <= delayco+1;
				else
					delayco <= (others => '0');
					delay <= '0';
					counter1 <= (others => '0');
				end if;
			elsif(rst = '0') then
				level<=1;
				death <= lives;
				score <= 0;
				posx <= '0';
				speed <= blockspeed;
				blocky <= blockiny;
				blockx <= blockinx;
				pady <= padiny;
				b1 <= '1';
				b2 <= '1';
				b3 <= '1';
				b4 <= '1';
				b5 <= '1';
				b6 <= '1';
				b7 <= '1';
				b8 <= '1';
				b9 <= '1';
				b10 <= '1';
				b11 <= '1';
				b12 <= '1';
				b13 <= '1';
				b14 <= '1';
				b15 <= '1';
				delay <= '1';
			elsif(newLevel = '1') then
				posx <= '0';
				speed <= blockspeed+(level-1)*40;
				blocky <= blockiny;
				blockx <= blockinx;
				pady <= padiny;
				b1 <= '1';
				b2 <= '1';
				b3 <= '1';
				b4 <= '1';
				b5 <= '1';
				b6 <= '1';
				b7 <= '1';
				b8 <= '1';
				b9 <= '1';
				b10 <= '1';
				b11 <= '1';
				b12 <= '1';
				b13 <= '1';
				b14 <= '1';
				b15 <= '1';
				delay <= '1';
				level<=level+1;
			end if;
			if counter1 < "1011111010111100001000000" then
					counter1 <= counter1 + movespeed;
			else
					if(lbutton = '0' AND pady-1 >= 0) then
						pady <= pady - 1;
					elsif (rbutton = '0' AND (pady+padw)<= 1280) then
						pady <= pady + 1;
					end if;
					counter1 <= (others => '0');
			end if;
			
			if counter2 < "1011111010111100001000000" then
					counter2 <= counter2 + speed;
			else
				if(posy = '0') then
					if(blocky > 0) then
						blocky <= blocky - 1;
					else
						posy <= '1';
					end if;
				elsif (posy='1') then
					if (blocky + blocks <= 1280) then
						blocky <= blocky + 1;
					else
						posy <= '0';
					end if;
				end if;
				if(posx = '0') then
					if(blockx > 0) then
						blockx <= blockx - 1;
					else
						posx <= '1';
					end if;
				elsif (posx='1') then
					if (blockx + blocks <= 1024) then
						blockx <= blockx + 1;
					else
						if(death>1) then
							death <= death-1;
							posx <= '0';
							blocky <= pady + 75;
							blockx <= padx - 1 - blocks;
						else
							death <= 0;
							speed <= 0;
						end if;
					end if;
				end if;
				counter2 <= (others => '0');
			end if;
			
			if((blockx+blocks=padx) AND ((blocky>=pady AND blocky<=pady+padw) OR (blocky+blocks>=pady AND blocky+blocks<=pady+padw))) then
				posx <= '0';
			end if;
			if((blockx+blocks>=padx) AND (blocky=pady+padw)) then
				posy <= '1';
			elsif((blockx+blocks>=padx) AND (blocky+blocks=pady)) then
				posy <= '0';
			end if;
			
			if(b1='1') then
				if((blockx = b1x+hght) AND ((blocky>=b1y AND blocky<=b1y+wid) OR (blocky+blocks>=b1y AND blocky+blocks<=b1y+wid))) then
					posx <= NOT posx;
					b1 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b1x) AND ((blocky>=b1y AND blocky<=b1y+wid) OR (blocky+blocks>=b1y AND blocky+blocks<=b1y+wid))) then
					posx <= NOT posx;
					b1 <= '0';
					score <= score + 1;
				elsif((blocky = b1y+wid) AND ((blockx>=b1x AND blockx<=b1x+hght) OR (blockx+blocks>=b1x AND blockx+blocks<=b1x+hght))) then
					posy <= NOT posy;
					b1 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b1y) AND ((blockx>=b1x AND blockx<=b1x+hght) OR (blockx+blocks>=b1x AND blockx+blocks<=b1x+hght))) then
					posy <= NOT posy;
					b1 <= '0';
					score <= score + 1;
				end if;
			end if;
			
			if(b2='1') then
				if((blockx = b2x+hght) AND ((blocky>=b2y AND blocky<=b2y+wid) OR (blocky+blocks>=b2y AND blocky+blocks<=b2y+wid))) then
					posx <= NOT posx;
					b2 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b2x) AND ((blocky>=b2y AND blocky<=b2y+wid) OR (blocky+blocks>=b2y AND blocky+blocks<=b2y+wid))) then
					posx <= NOT posx;
					b2 <= '0';
					score <= score + 1;
				elsif((blocky = b2y+wid) AND ((blockx>=b2x AND blockx<=b2x+hght) OR (blockx+blocks>=b2x AND blockx+blocks<=b2x+hght))) then
					posy <= NOT posy;
					b2 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b2y) AND ((blockx>=b2x AND blockx<=b2x+hght) OR (blockx+blocks>=b2x AND blockx+blocks<=b2x+hght))) then
					posy <= NOT posy;
					b2 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b3='1') then
				if((blockx = b3x+hght) AND ((blocky>=b3y AND blocky<=b3y+wid) OR (blocky+blocks>=b3y AND blocky+blocks<=b3y+wid))) then
					posx <= NOT posx;
					b3 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b3x) AND ((blocky>=b3y AND blocky<=b3y+wid) OR (blocky+blocks>=b3y AND blocky+blocks<=b3y+wid))) then
					posx <= NOT posx;
					b3 <= '0';
					score <= score + 1;
				elsif((blocky = b3y+wid) AND ((blockx>=b3x AND blockx<=b3x+hght) OR (blockx+blocks>=b3x AND blockx+blocks<=b3x+hght))) then
					posy <= NOT posy;
					b3 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b3y) AND ((blockx>=b3x AND blockx<=b3x+hght) OR (blockx+blocks>=b3x AND blockx+blocks<=b3x+hght))) then
					posy <= NOT posy;
					b3 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b4='1') then
				if((blockx = b4x+hght) AND ((blocky>=b4y AND blocky<=b4y+wid) OR (blocky+blocks>=b4y AND blocky+blocks<=b4y+wid))) then
					posx <= NOT posx;
					b4 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b4x) AND ((blocky>=b4y AND blocky<=b4y+wid) OR (blocky+blocks>=b4y AND blocky+blocks<=b4y+wid))) then
					posx <= NOT posx;
					b4 <= '0';
					score <= score + 1;
				elsif((blocky = b4y+wid) AND ((blockx>=b4x AND blockx<=b4x+hght) OR (blockx+blocks>=b4x AND blockx+blocks<=b4x+hght))) then
					posy <= NOT posy;
					b4 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b4y) AND ((blockx>=b4x AND blockx<=b4x+hght) OR (blockx+blocks>=b4x AND blockx+blocks<=b4x+hght))) then
					posy <= NOT posy;
					b4 <= '0';
					score <= score + 1;
				end if;
			end if;
			
			if(b5='1') then
				if((blockx = b5x+hght) AND ((blocky>=b5y AND blocky<=b5y+wid) OR (blocky+blocks>=b5y AND blocky+blocks<=b5y+wid))) then
					posx <= NOT posx;
					b5 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b5x) AND ((blocky>=b5y AND blocky<=b5y+wid) OR (blocky+blocks>=b5y AND blocky+blocks<=b5y+wid))) then
					posx <= NOT posx;
					b5 <= '0';
					score <= score + 1;
				elsif((blocky = b5y+wid) AND ((blockx>=b5x AND blockx<=b5x+hght) OR (blockx+blocks>=b5x AND blockx+blocks<=b5x+hght))) then
					posy <= NOT posy;
					b5 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b5y) AND ((blockx>=b5x AND blockx<=b5x+hght) OR (blockx+blocks>=b5x AND blockx+blocks<=b5x+hght))) then
					posy <= NOT posy;
					b5 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b6='1') then
				if((blockx = b6x+hght) AND ((blocky>=b6y AND blocky<=b6y+wid) OR (blocky+blocks>=b6y AND blocky+blocks<=b6y+wid))) then
					posx <= NOT posx;
					b6 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b6x) AND ((blocky>=b6y AND blocky<=b6y+wid) OR (blocky+blocks>=b6y AND blocky+blocks<=b6y+wid))) then
					posx <= NOT posx;
					b6 <= '0';
					score <= score + 1;
				elsif((blocky = b6y+wid) AND ((blockx>=b6x AND blockx<=b6x+hght) OR (blockx+blocks>=b6x AND blockx+blocks<=b6x+hght))) then
					posy <= NOT posy;
					b6 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b6y) AND ((blockx>=b6x AND blockx<=b6x+hght) OR (blockx+blocks>=b6x AND blockx+blocks<=b6x+hght))) then
					posy <= NOT posy;
					b6 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b7='1') then
				if((blockx = b7x+hght) AND ((blocky>=b7y AND blocky<=b7y+wid) OR (blocky+blocks>=b7y AND blocky+blocks<=b7y+wid))) then
					posx <= NOT posx;
					b7 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b7x) AND ((blocky>=b7y AND blocky<=b7y+wid) OR (blocky+blocks>=b7y AND blocky+blocks<=b7y+wid))) then
					posx <= NOT posx;
					b7 <= '0';
					score <= score + 1;
				elsif((blocky = b7y+wid) AND ((blockx>=b7x AND blockx<=b7x+hght) OR (blockx+blocks>=b7x AND blockx+blocks<=b7x+hght))) then
					posy <= NOT posy;
					b7 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b7y) AND ((blockx>=b7x AND blockx<=b7x+hght) OR (blockx+blocks>=b7x AND blockx+blocks<=b7x+hght))) then
					posy <= NOT posy;
					b7 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b8='1') then
				if((blockx = b8x+hght) AND ((blocky>=b8y AND blocky<=b8y+wid) OR (blocky+blocks>=b8y AND blocky+blocks<=b8y+wid))) then
					posx <= NOT posx;
					b8 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b8x) AND ((blocky>=b8y AND blocky<=b8y+wid) OR (blocky+blocks>=b8y AND blocky+blocks<=b8y+wid))) then
					posx <= NOT posx;
					b8 <= '0';
					score <= score + 1;
				elsif((blocky = b8y+wid) AND ((blockx>=b8x AND blockx<=b8x+hght) OR (blockx+blocks>=b8x AND blockx+blocks<=b8x+hght))) then
					posy <= NOT posy;
					b8 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b8y) AND ((blockx>=b8x AND blockx<=b8x+hght) OR (blockx+blocks>=b8x AND blockx+blocks<=b8x+hght))) then
					posy <= NOT posy;
					b8 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b9='1') then
				if((blockx = b9x+hght) AND ((blocky>=b9y AND blocky<=b9y+wid) OR (blocky+blocks>=b9y AND blocky+blocks<=b9y+wid))) then
					posx <= NOT posx;
					b9 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b9x) AND ((blocky>=b9y AND blocky<=b9y+wid) OR (blocky+blocks>=b9y AND blocky+blocks<=b9y+wid))) then
					posx <= NOT posx;
					b9 <= '0';
					score <= score + 1;
				elsif((blocky = b9y+wid) AND ((blockx>=b9x AND blockx<=b9x+hght) OR (blockx+blocks>=b9x AND blockx+blocks<=b9x+hght))) then
					posy <= NOT posy;
					b9 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b9y) AND ((blockx>=b9x AND blockx<=b9x+hght) OR (blockx+blocks>=b9x AND blockx+blocks<=b9x+hght))) then
					posy <= NOT posy;
					b9 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b10='1') then
				if((blockx = b10x+hght) AND ((blocky>=b10y AND blocky<=b10y+wid) OR (blocky+blocks>=b10y AND blocky+blocks<=b10y+wid))) then
					posx <= NOT posx;
					b10 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b10x) AND ((blocky>=b10y AND blocky<=b10y+wid) OR (blocky+blocks>=b10y AND blocky+blocks<=b10y+wid))) then
					posx <= NOT posx;
					b10 <= '0';
					score <= score + 1;
				elsif((blocky = b10y+wid) AND ((blockx>=b10x AND blockx<=b10x+hght) OR (blockx+blocks>=b10x AND blockx+blocks<=b10x+hght))) then
					posy <= NOT posy;
					b10 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b10y) AND ((blockx>=b10x AND blockx<=b10x+hght) OR (blockx+blocks>=b10x AND blockx+blocks<=b10x+hght))) then
					posy <= NOT posy;
					b10 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b11='1') then
				if((blockx = b11x+hght) AND ((blocky>=b11y AND blocky<=b11y+wid) OR (blocky+blocks>=b11y AND blocky+blocks<=b11y+wid))) then
					posx <= NOT posx;
					b11 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b11x) AND ((blocky>=b11y AND blocky<=b11y+wid) OR (blocky+blocks>=b11y AND blocky+blocks<=b11y+wid))) then
					posx <= NOT posx;
					b11 <= '0';
					score <= score + 1;
				elsif((blocky = b11y+wid) AND ((blockx>=b11x AND blockx<=b11x+hght) OR (blockx+blocks>=b11x AND blockx+blocks<=b11x+hght))) then
					posy <= NOT posy;
					b11 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b11y) AND ((blockx>=b11x AND blockx<=b11x+hght) OR (blockx+blocks>=b11x AND blockx+blocks<=b11x+hght))) then
					posy <= NOT posy;
					b11 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b12='1') then
				if((blockx = b12x+hght) AND ((blocky>=b12y AND blocky<=b12y+wid) OR (blocky+blocks>=b12y AND blocky+blocks<=b12y+wid))) then
					posx <= NOT posx;
					b12 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b12x) AND ((blocky>=b12y AND blocky<=b12y+wid) OR (blocky+blocks>=b12y AND blocky+blocks<=b12y+wid))) then
					posx <= NOT posx;
					b12 <= '0';
					score <= score + 1;
				elsif((blocky = b12y+wid) AND ((blockx>=b12x AND blockx<=b12x+hght) OR (blockx+blocks>=b12x AND blockx+blocks<=b12x+hght))) then
					posy <= NOT posy;
					b12 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b12y) AND ((blockx>=b12x AND blockx<=b12x+hght) OR (blockx+blocks>=b12x AND blockx+blocks<=b12x+hght))) then
					posy <= NOT posy;
					b12 <= '0';
					score <= score + 1;
				end if;
			end if;

			if(b13='1') then
				if((blockx = b13x+hght) AND ((blocky>=b13y AND blocky<=b13y+wid) OR (blocky+blocks>=b13y AND blocky+blocks<=b13y+wid))) then
					posx <= NOT posx;
					b13 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b13x) AND ((blocky>=b13y AND blocky<=b13y+wid) OR (blocky+blocks>=b13y AND blocky+blocks<=b13y+wid))) then
					posx <= NOT posx;
					b13 <= '0';
					score <= score + 1;
				elsif((blocky = b13y+wid) AND ((blockx>=b13x AND blockx<=b13x+hght) OR (blockx+blocks>=b13x AND blockx+blocks<=b13x+hght))) then
					posy <= NOT posy;
					b13 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b13y) AND ((blockx>=b13x AND blockx<=b13x+hght) OR (blockx+blocks>=b13x AND blockx+blocks<=b13x+hght))) then
					posy <= NOT posy;
					b13 <= '0';
					score <= score + 1;
				end if;
			end if;
		
			if(b14='1') then
				if((blockx = b14x+hght) AND ((blocky>=b14y AND blocky<=b14y+wid) OR (blocky+blocks>=b14y AND blocky+blocks<=b14y+wid))) then
					posx <= NOT posx;
					b14 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b14x) AND ((blocky>=b14y AND blocky<=b14y+wid) OR (blocky+blocks>=b14y AND blocky+blocks<=b14y+wid))) then
					posx <= NOT posx;
					b14 <= '0';
					score <= score + 1;
				elsif((blocky = b14y+wid) AND ((blockx>=b14x AND blockx<=b14x+hght) OR (blockx+blocks>=b14x AND blockx+blocks<=b14x+hght))) then
					posy <= NOT posy;
					b14 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b14y) AND ((blockx>=b14x AND blockx<=b14x+hght) OR (blockx+blocks>=b14x AND blockx+blocks<=b14x+hght))) then
					posy <= NOT posy;
					b14 <= '0';
					score <= score + 1;
				end if;
			end if;
			
			if(b15='1') then
				if((blockx = b15x+hght) AND ((blocky>=b15y AND blocky<=b15y+wid) OR (blocky+blocks>=b15y AND blocky+blocks<=b15y+wid))) then
					posx <= NOT posx;
					b15 <= '0';
					score <= score + 1;
				elsif((blockx + blocks = b15x) AND ((blocky>=b15y AND blocky<=b15y+wid) OR (blocky+blocks>=b15y AND blocky+blocks<=b15y+wid))) then
					posx <= NOT posx;
					b15 <= '0';
					score <= score + 1;
				elsif((blocky = b15y+wid) AND ((blockx>=b15x AND blockx<=b15x+hght) OR (blockx+blocks>=b15x AND blockx+blocks<=b15x+hght))) then
					posy <= NOT posy;
					b15 <= '0';
					score <= score + 1;
				elsif((blocky + blocks = b15y) AND ((blockx>=b15x AND blockx<=b15x+hght) OR (blockx+blocks>=b15x AND blockx+blocks<=b15x+hght))) then
					posy <= NOT posy;
					b15 <= '0';
					score <= score + 1;
				end if;
			end if;
				
		end if;
	END PROCESS clk_div;
			
	scoreDisplay : PROCESS(score)
		BEGIN
			tempscore <= score;
			digit <= tempscore mod 10;
			if(score>=99) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '1';
				a5 <= '1';
				a6 <= '0';
				a7 <= '0';
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '1';
				a12 <= '1';
				a13 <= '0';
				a14 <= '0';
			elsif(digit = 0) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '0';
				a5 <= '0';
				a6 <= '0';
				a7 <= '1';
			elsif(digit = 1) then
				a1 <= '1';
				a2 <= '0';
				a3 <= '0';
				a4 <= '1';
				a5 <= '1';
				a6 <= '1';
				a7 <= '1';
			elsif(digit = 2) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '1';
				a4 <= '0';
				a5 <= '0';
				a6 <= '1';
				a7 <= '0';
			elsif(digit = 3) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '0';
				a5 <= '1';
				a6 <= '1';
				a7 <= '0';
			elsif(digit = 4) then
				a1 <= '1';
				a2 <= '0';
				a3 <= '0';
				a4 <= '1';
				a5 <= '1';
				a6 <= '0';
				a7 <= '0';
			elsif(digit = 5) then
				a1 <= '0';
				a2 <= '1';
				a3 <= '0';
				a4 <= '0';
				a5 <= '1';
				a6 <= '0';
				a7 <= '0';
			elsif(digit = 6) then
				a1 <= '0';
				a2 <= '1';
				a3 <= '0';
				a4 <= '0';
				a5 <= '0';
				a6 <= '0';
				a7 <= '0';
			elsif(digit = 7) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '1';
				a5 <= '1';
				a6 <= '1';
				a7 <= '1';
			elsif(digit = 8) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '0';
				a5 <= '0';
				a6 <= '0';
				a7 <= '0';
			elsif(digit = 9) then
				a1 <= '0';
				a2 <= '0';
				a3 <= '0';
				a4 <= '1';
				a5 <= '1';
				a6 <= '0';
				a7 <= '0';
			end if;
			if(score < 10) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '0';
				a12 <= '0';
				a13 <= '0';
				a14 <= '1';
			elsif(score>=10 AND score < 20) then
				a8 <= '1';
				a9 <= '0';
				a10 <= '0';
				a11 <= '1';
				a12 <= '1';
				a13 <= '1';
				a14 <= '1';
			elsif(score>=20 AND score <30) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '1';
				a11 <= '0';
				a12 <= '0';
				a13 <= '1';
				a14 <= '0';
			elsif(score>=30 AND score <40) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '0';
				a12 <= '1';
				a13 <= '1';
				a14 <= '0';
			elsif(score>=40 AND score <50) then
				a8 <= '1';
				a9 <= '0';
				a10 <= '0';
				a11 <= '1';
				a12 <= '1';
				a13 <= '0';
				a14 <= '0';
			elsif(score>=50 AND score<60) then
				a8 <= '0';
				a9 <= '1';
				a10 <= '0';
				a11 <= '0';
				a12 <= '1';
				a13 <= '0';
				a14 <= '0';
			elsif(score>=60 AND score<70) then
				a8 <= '0';
				a9 <= '1';
				a10 <= '0';
				a11 <= '0';
				a12 <= '0';
				a13 <= '0';
				a14 <= '0';
			elsif(score>=70 AND score<80) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '1';
				a12 <= '1';
				a13 <= '1';
				a14 <= '1';
			elsif(score>=80 AND score<90) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '0';
				a12 <= '0';
				a13 <= '0';
				a14 <= '0';
			elsif(score>=90 AND score<99) then
				a8 <= '0';
				a9 <= '0';
				a10 <= '0';
				a11 <= '1';
				a12 <= '1';
				a13 <= '0';
				a14 <= '0';
			end if;
	END PROCESS scoreDisplay;
	
	levelUp : PROCESS(b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15)
		BEGIN
		if(b1 = '0' AND b2 = '0' AND b3 = '0' AND b4 = '0' AND b5 = '0' AND b6 = '0' AND b7 = '0' AND b8 = '0' AND b9 = '0' AND b10 = '0' AND b11 = '0' AND b12 = '0' AND b13 = '0' AND b14 = '0' AND b15='0') then
			newLevel <= '1';
		else
			newLevel <= '0';
		end if;
		END PROCESS levelUp;
		
	levelDisplay : PROCESS(newLevel)
		BEGIN
			if(level >= 9) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '0';
				l4 <= '1';
				l5 <= '1';
				l6 <= '0';
				l7 <= '0';
			elsif(level = 1) then
				l1 <= '1';
				l2 <= '0';
				l3 <= '0';
				l4 <= '1';
				l5 <= '1';
				l6 <= '1';
				l7 <= '1';
			elsif(level = 2) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '1';
				l4 <= '0';
				l5 <= '0';
				l6 <= '1';
				l7 <= '0';
			elsif(level = 3) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '0';
				l4 <= '0';
				l5 <= '1';
				l6 <= '1';
				l7 <= '0';
			elsif(level = 4) then
				l1 <= '1';
				l2 <= '0';
				l3 <= '0';
				l4 <= '1';
				l5 <= '1';
				l6 <= '0';
				l7 <= '0';
			elsif(level = 5) then
				l1 <= '0';
				l2 <= '1';
				l3 <= '0';
				l4 <= '0';
				l5 <= '1';
				l6 <= '0';
				l7 <= '0';
			elsif(level = 6) then
				l1 <= '0';
				l2 <= '1';
				l3 <= '0';
				l4 <= '0';
				l5 <= '0';
				l6 <= '0';
				l7 <= '0';
			elsif(level = 7) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '0';
				l4 <= '1';
				l5 <= '1';
				l6 <= '1';
				l7 <= '1';
			elsif(level = 8) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '0';
				l4 <= '0';
				l5 <= '0';
				l6 <= '0';
				l7 <= '0';
			elsif(level = 9) then
				l1 <= '0';
				l2 <= '0';
				l3 <= '0';
				l4 <= '1';
				l5 <= '1';
				l6 <= '0';
				l7 <= '0';
			end if;
		END PROCESS levelDisplay;
	
	deathDisplay: PROCESS(death)
		BEGIN
			if(death = 4) then
				d1 <= '1';
				d2 <= '1';
				d3 <= '1';
				d4 <= '1';
			elsif(death = 3) then
				d1 <= '1';
				d2 <= '1';
				d3 <= '1';
				d4 <= '0';
			elsif(death = 2) then
				d1 <= '1';
				d2 <= '1';
				d3 <= '0';
				d4 <= '0';
			elsif(death = 1) then
				d1 <= '1';
				d2 <= '0';
				d3 <= '0';
				d4 <= '0';
			elsif(death = 0) then
				d1 <= '0';
				d2 <= '0';
				d3 <= '0';
				d4 <= '0';
			end if;
		END PROCESS deathDisplay;

		keyPress : PROCESS(newKey, off)
		BEGIN
		if(rising_edge(newKey)) then
			if(off = '1') then
				lbutton <= '1';
				rbutton <= '1';
				off <= '0';
			end if;
			if(key = "11110000") then
				off <= '1';
			elsif(key = "00011100" AND off = '0') then
				lbutton <= '0';
				rbutton <= '1';
			elsif(key = "00100011" AND off = '0') then
				lbutton <= '1';
				rbutton <= '0';
			end if;
		end if;
		END PROCESS keyPress;
	
	draw: PROCESS(disp_ena, row, column)
		BEGIN

		IF(disp_ena = '1') THEN		--display time
			IF(row >= b1y AND row <= b1y + wid AND column >=b1x AND column < b1x + hght AND b1 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF(row >= b2y AND row <= b2y + wid AND column >=b2x AND column < b2x + hght AND b2 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			ELSIF(row >= b3y AND row <= b3y + wid AND column >=b3x AND column < b3x + hght AND b3 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row >= b4y AND row <= b4y + wid AND column >=b4x AND column < b4x + hght AND b4 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			ELSIF(row >= b5y AND row <= b5y + wid AND column >=b5x AND column < b5x + hght AND b5 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF(row >= b6y AND row <= b6y + wid AND column >=b6x AND column < b6x + hght AND b6 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			ELSIF(row >= b7y AND row <= b7y + wid AND column >=b7x AND column < b7x + hght AND b7 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row >= b8y AND row <= b8y + wid AND column >=b8x AND column < b8x + hght AND b8 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF(row >= b9y AND row <= b9y + wid AND column >=b9x AND column < b9x + hght AND b9 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			ELSIF(row >= b10y AND row <= b10y + wid AND column >=b10x AND column < b10x + hght AND b10 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row >= b11y AND row <= b11y + wid AND column >=b11x AND column < b11x + hght AND b11 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			ELSIF(row >= b12y AND row <= b12y + wid AND column >=b12x AND column < b12x + hght AND b12 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF(row >= b13y AND row <= b13y + wid AND column >=b13x AND column < b13x + hght AND b13 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			ELSIF(row >= b14y AND row <= b14y + wid AND column >=b14x AND column < b14x + hght AND b14 = '1') THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row >= b15y AND row <= b15y + wid AND column >=b15x AND column < b15x + hght AND b15 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF(row >= b15y AND row <= b15y + wid AND column >=b15x AND column < b15x + hght AND b15 = '1') THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');

			ELSIF(row >= pady AND row <= pady + padw AND column >=padx AND column < padx + padh) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
				
				ELSIF(row >= blocky AND row <= blocky + blocks AND column >=blockx AND column < blockx + blocks) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
				
			ELSE
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	
	END PROCESS draw;
	
	
END behavior;
