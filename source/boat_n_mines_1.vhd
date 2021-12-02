LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat x position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 2; -- ball size in pixels
    CONSTANT bat_w : INTEGER := 20; -- bat width in pixels
    CONSTANT bat_h : INTEGER := 6; -- bat height in pixels
    -- distance ball moves each frame
    CONSTANT ball_1_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_1_on : STD_LOGIC; -- indicates whether ball is at current pixel position
	CONSTANT ball_2_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_2_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    -- current ball position - intitialized to center of screen
    SIGNAL ball_1_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(600, 11);
    SIGNAL ball_1_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(600, 11);
	SIGNAL ball_2_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(200, 11);
    SIGNAL ball_2_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(600, 11);
    -- bat vertical position
    CONSTANT bat_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 11);
    -- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
    SIGNAL ball_1_x_motion, ball_1_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_1_speed;
	SIGNAL ball_2_x_motion, ball_2_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_2_speed;
BEGIN
    red <= NOT bat_on; -- color setup for red ball and cyan bat on white background
    green <= NOT ball_1_on;
    blue <= NOT ball_1_on;
	green <= NOT ball_2_on;
    blue <= NOT ball_2_on;
	
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    ball_1_draw : PROCESS (ball_1_x, ball_1_y, pixel_1_row, pixel_1_col) IS
        VARIABLE vx_1, vy_1 : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col_1 <= ball_1_x THEN -- vx_1 = |ball_1_x - pixel_1_col|
            vx_1 := ball_x - pixel_col;
        ELSE
            vx_1 := pixel_col_1 - ball_1_x;
        END IF;
        IF pixel_row_1 <= ball_1_y THEN -- vy_1 = |ball_1_y - pixel_row_1|
            vy_1 := ball_1_y - pixel_row_1;
        ELSE
            vy_1 := pixel_row_1 - ball_1_y;
        END IF;
        IF ((vx_1 * vx_1) + (vy_1 * vy_1)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_1_on <= game_on;
        ELSE
            ball_1_on <= '0';
        END IF;
    END PROCESS;
	
    ball_2_draw : PROCESS (ball_2_x, ball_2_y, pixel_2_row, pixel_2_col) IS
        VARIABLE vx_2, vy_2 : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col_2 <= ball_2_x THEN -- vx_2 = |ball_2_x - pixel_2_col|
            vx_2 := ball_x - pixel_col;
        ELSE
            vx_2 := pixel_col_2 - ball_2_x;
        END IF;
        IF pixel_row_2 <= ball_2_y THEN -- vy_2 = |ball_2_y - pixel_row_2|
            vy_2 := ball_2_y - pixel_row_2;
        ELSE
            vy_2 := pixel_row_2 - ball_2_y;
        END IF;
        IF ((vx_2 * vx_2) + (vy_2 * vy_2)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_2_on <= game_on;
        ELSE
            ball_2_on <= '0';
        END IF;
    END PROCESS;
	
    -- process to draw bat
    -- set bat_on if current pixel address is covered by bat position
    batdraw : PROCESS (bat_x, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_x - bat_w) OR (bat_x <= bat_w)) AND
         pixel_col <= bat_x + bat_w AND
             pixel_row >= bat_y - bat_h AND
             pixel_row <= bat_y + bat_h THEN
                bat_on <= '1';
        ELSE
            bat_on <= '0';
        END IF;
    END PROCESS;
	
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball_1 : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1';
            ball_1_y_motion <= (NOT ball_1_speed) + 1; -- set vspeed to (- ball_speed) pixels
        ELSIF ball_1_y + bsize >= 0 THEN -- if ball meets top wall
            ball_1_y_motion <= (NOT ball_1_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
        END IF;
        -- allow for bounce off left or right of screen
        IF ball_1_x + bsize >= 800 THEN -- bounce off right wall
            ball_1_x_motion <= (NOT ball_1_speed) + 1; -- set hspeed to (- ball_speed) pixels
        ELSIF ball_1_x <= bsize THEN -- bounce off left wall
            ball_1_x_motion <= ball_1_speed; -- set hspeed to (+ ball_speed) pixels
        END IF;
        -- allow for bounce off bat
        IF (ball_1_x + bsize/2) >= (bat_1_x - bat_w) AND
         (ball_1_x - bsize/2) <= (bat_x + bat_w) AND
             (ball_1_y + bsize/2) >= (bat_y - bat_h) AND
             (ball_1_y - bsize/2) <= (bat_y + bat_h) THEN
                game_on <= '0';
        END IF;
		
    mball_2 : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1';
            ball_2_y_motion <= (NOT ball_2_speed) + 1; -- set vspeed to (- ball_speed) pixels
        ELSIF ball_2_y + bsize >= 0 THEN -- if ball meets top wall
            ball_2_y_motion <= (NOT ball_2_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
        END IF;
        -- allow for bounce off left or right of screen
        IF ball_2_x + bsize >= 800 THEN -- bounce off right wall
            ball_2_x_motion <= (NOT ball_2_speed) + 1; -- set hspeed to (- ball_speed) pixels
        ELSIF ball_2_x <= bsize THEN -- bounce off left wall
            ball_2_x_motion <= ball_2_speed; -- set hspeed to (+ ball_speed) pixels
        END IF;
        -- allow for bounce off bat
        IF (ball_2_x + bsize/2) >= (bat_2_x - bat_w) AND
         (ball_2_x - bsize/2) <= (bat_x + bat_w) AND
             (ball_2_y + bsize/2) >= (bat_y - bat_h) AND
             (ball_2_y - bsize/2) <= (bat_y + bat_h) THEN
                game_on <= '0';
        END IF;
		
        -- compute next ball vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_y is close to zero and ball_y_motion is negative
        temp := ('0' & ball_1_y) + (ball_1_y_motion(10) & ball_1_y_motion);
        IF game_on = '0' THEN
            ball_1_y <= CONV_STD_LOGIC_VECTOR(600, 11);
        ELSIF temp(11) = '1' THEN
            ball_1_y <= (OTHERS => '0');
        ELSE ball_1_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_1_x) + (ball_1_x_motion(10) & ball_1_x_motion);
        IF temp(11) = '1' THEN
            ball_1_x <= (OTHERS => '0');
        ELSE ball_1_x <= temp(10 DOWNTO 0);
        END IF;
		
		temp := ('0' & ball_2_y) + (ball_2_y_motion(10) & ball_2_y_motion);
        IF game_on = '0' THEN
            ball_2_y <= CONV_STD_LOGIC_VECTOR(600, 11);
        ELSIF temp(11) = '1' THEN
            ball_2_y <= (OTHERS => '0');
        ELSE ball_2_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_2_x) + (ball_2_x_motion(10) & ball_2_x_motion);
        IF temp(11) = '1' THEN
            ball_2_x <= (OTHERS => '0');
        ELSE ball_2_x <= temp(10 DOWNTO 0);
        END IF;

    END PROCESS;
END Behavioral;
