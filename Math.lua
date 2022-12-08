Math = {
	Precision = 200
}

-- Functions
function Math.absolute (number: number)
	return if number < 0 then -number else number
end

function Math.clamp (number: number, range: NumberRange)
	if number < range.Min then
		return range.Min
	elseif number > range.Max then
		return range.Max
	else
		return number
	end
end

function Math.maximum (number: number, max: number)
	return if number > max then max else number
end

function Math.minimum (number: number, min: number)
	return if number < min then min else number
end

function Math.distance (first: number, second: number)
	-- Absolute the difference between both numbers to get distance
	return Math.absolute(first - second)
end

function Math.power (number: number, exponent: number)
	local original = number
	
	-- Multiply by the original through each iteration of exponent's size
	for index = 1, exponent - 1, 1 do
		number *= original
	end
	
	return if exponent == 0 then 0 else number
end

function Math.floor (number: number)
	-- Drop any decimal place
	return tonumber(string.split(tostring(number), '.')[0])
end

function Math.ceiling (number: number)
	local floor = Math.floor(number)
	
	-- If distance from number and the floored number is greater than 0: round up
	return if Math.distance(number, floor) > 0 then floor + 1 else number
end

function Math.round (number: number)
	local floor = Math.floor(number)
	
	-- If distance from number and the floored number is 0.5 or more -- by algebraic law: round up
	return if Math.distance(number, floor) >= 0.5 then floor + 1 else floor
end

function Math.squareRoot (number: number)
	local guess = number
	
	for index = 1, Math.Precision, 1 do
		-- Newton's Method of Approximation
		guess = (guess - (guess^2 - number) / (2 * guess))
		
		if guess^2 == number then break end
	end
	
	return if number < 0 then nil elseif number == 0 then 0 else guess
end

function Math.factorial (number: number)
	-- Multiply number by number - 1 through each iteration
	for index = number - 1, 1, -1 do
		number *= index
	end
	
	return number
end

function Math.modulo (dividend: number, divisor: number)
	-- Subtract the dividend by the product of the divisor and the
	-- [floored quotient of the dividend and the divisor (How many
	-- times the divisor evenly goes into the dividend)]
	return dividend - (divisor * Math.floor(dividend / divisor))
end

function Math.sine (number: number, hyperbolic: boolean?)
	local sine = 0
	local sign = 1

	for index = 3, Math.Precision, 2 do
		sine += ((1 / Math.factorial(index)) * number^index) * sign
		sign = if hyperbolic then sign else -sign
	end

	return if hyperbolic then number + sine else number - sine
end

function Math.cosine (number: number, hyperbolic: boolean?)
	local cosine = 0
	local sign = 1
	
	for index = 2, Math.Precision, 2 do
		cosine += ((1 / Math.factorial(index)) * number^index) * sign
		sign = if hyperbolic then sign else -sign
	end
	
	return if hyperbolic then 1 + cosine else 1 - cosine
end

-- Constants
Math.PI6 = 3.141593 -- First 6 decimal places of PI
Math.PI12 = 3.141592653590 -- First 12..
Math.PI18 = 3.141592653589793238
Math.PI24 = 3.141592653589793238462643 -- Most precise
Math.PI = Math.PI12

Math.INF = 2^1024 -- Highest storable number in Lua (infinity, inf)

-- Shorthands
Math.abs = Math.absolute
Math.max = Math.maximum
Math.min = Math.minimum
Math.dist = Math.distance
Math.pow = Math.power
Math.ceil = Math.ceiling
Math.sqrt = Math.squareRoot
Math.fact = Math.factorial
Math.mod = Math.modulo
Math.sin = Math.sine
Math.cos = Math.cosine

Math.sinh = function (number: number)
	return Math.sin(number, true)
end

Math.cosh = function (number: number)
	return Math.cos(number, true)
end

return Math
