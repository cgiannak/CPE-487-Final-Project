--Change all mine variables to mine_number variables
--Repeat processes for each iteration of mine_numbers
--Move the location of the paddle (boat)
--Create new sprite for surface of water
--Change background color
--Make paddle shoot depth charges when button is pressed
--Signal to delete both depth charge and submarine when they collide
--Counter to keep score of how many submarines you hit
--Manual reset button


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY boat_n_mines IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        boat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current boat x position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END boat_n_mines;

ARCHITECTURE Behavioral OF boat_n_mines IS
    CONSTANT msize : INTEGER := 2; -- mine size in pixels
    CONSTANT boat_w : INTEGER := 20; -- boat width in pixels
    CONSTANT boat_h : INTEGER := 6; -- boat height in pixels
    -- distance boat moves each frame
    CONSTANT mine_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL mine_on_1 : STD_LOGIC; -- indicates whether mine is at current pixel position
	SIGNAL mine_on_2 : STD_LOGIC;
	SIGNAL mine_on_3 : STD_LOGIC;
	SIGNAL mine_on_4 : STD_LOGIC;
	SIGNAL mine_on_5 : STD_LOGIC;
    SIGNAL boat_on : STD_LOGIC; -- indicates whether boat at over current pixel position
    -- SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether mine is in play
    -- current mine position - intitialized to center of screen
    SIGNAL mine_1_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11); -- possibly need to make 5 (can game run when some aren't in play?)
    SIGNAL mine_1_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL mine_2_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL mine_2_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL mine_3_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL mine_3_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL mine_4_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL mine_4_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL mine_5_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL mine_5_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    -- boat vertical position
    CONSTANT boat_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(500, 11);
    -- current mine motion - initialized to (+ mine_speed) pixels/frame in both X and Y directions
	
	
	
	
BEGIN

-- add numbered mines, get rid of mine_x and pixel_row?

    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on_1;
    blue <= NOT mine_on_1; 
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_1_x, mine_1_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_1_x THEN -- vx = |mine_1_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
	
BEGIN
    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on;
    blue <= NOT mine_on;
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_x, mine_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_x THEN -- vx = |mine_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
	
BEGIN
    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on;
    blue <= NOT mine_on;
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_x, mine_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_x THEN -- vx = |mine_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
	
BEGIN
    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on;
    blue <= NOT mine_on;
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_x, mine_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_x THEN -- vx = |mine_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
	
BEGIN
    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on;
    blue <= NOT mine_on;
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_x, mine_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_x THEN -- vx = |mine_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
	
BEGIN
    red <= NOT boat_on; -- color setup for red mine and cyan boat on white background
    green <= NOT mine_on;
    blue <= NOT mine_on;
    -- process to draw round mine
    -- set mine_on if current pixel address is covered by mine position
    minedraw : PROCESS (mine_x, mine_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= mine_x THEN -- vx = |mine_x - pixel_col|
            vx := mine_x - pixel_col;
        ELSE
            vx := pixel_col - mine_x;
        END IF;
        IF pixel_row <= mine_y THEN -- vy = |mine_y - pixel_row|
            vy := mine_y - pixel_row;
        ELSE
            vy := pixel_row - mine_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (msize * msize) THEN -- test if radial distance < msize
            boat_on <= game_on; -- change to trigger being boat
        ELSE
            mine_on <= '0';
        END IF;
    END PROCESS;
    -- process to draw boat
    -- set boat_on if current pixel address is covered by boat position
    boatdraw : PROCESS (boat_x, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= boat_x - boat_w) OR (boat_x <= boat_w)) AND
         pixel_col <= boat_x + boat_w AND
             pixel_row >= boat_y - boat_h AND
             pixel_row <= boat_y + boat_h THEN
                boat_on <= '1';
        ELSE
            boat_on <= '0';
        END IF;
    END PROCESS;
    -- process to move mine once every frame (i.e., once every vsync pulse)
    mmine : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1'; -- may need multiple if statements for each mine (game always on)
            mine_y_motion <= (NOT mine_speed) + 1; -- set vspeed to (- mine_speed) pixels
            mine_y_motion <= mine_speed; -- set vspeed to (+ mine_speed) pixels
        ELSIF mine_y + msize >= 0 THEN -- if mine meets top wall
            mine_y_motion <= (NOT mine_speed) + 1; -- set vspeed to (- mine_speed) pixels
            game_on <= '0'; -- and make mine disappear
        END IF;
mine
        -- compute next mine vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when mine_y is close to zero and mine_y_motion is negative
        temp := ('0' & mine_y) + (mine_y_motion(10) & mine_y_motion);
        IF mine_on_1 = '0' THEN
            mine_1_y <= CONV_STD_LOGIC_VECTOR(600, 11); -- need to copy/paste this for each mine
		ELSEIF mine_on_2 = '0' THEN
            mine_2_y <= CONV_STD_LOGIC_VECTOR(600, 11);
		ELSEIF mine_on_3 = '0' THEN
            mine_3_y <= CONV_STD_LOGIC_VECTOR(600, 11);
		ELSEIF mine_on_4 = '0' THEN
            mine_4_y <= CONV_STD_LOGIC_VECTOR(600, 11);
		ELSEIF mine_on_5 = '0' THEN
            mine_5_y <= CONV_STD_LOGIC_VECTOR(600, 11);
        ELSIF temp(11) = '1' THEN
            mine_y <= (OTHERS => '0'); -- copy/paste elseif for each mine?
        ELSE mine_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next mine horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when mine_x is close to zero and mine_x_motion is negative
        temp := ('0' & mine_x) + (mine_x_motion(10) & mine_x_motion);
        IF temp(11) = '1' THEN
            mine_x <= (OTHERS => '0');
        ELSE mine_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
END Behavioral;
