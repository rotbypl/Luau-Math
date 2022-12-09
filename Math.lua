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
	-- Get the sine of the number
	local sine = 0

	for index = 0, Math.Precision, 1 do
		-- Taylor Series of Sine
		sine += ((-1)^index / Math.factorial(2 * index + 1)) * (number^(2 * index + 1))
	end

	return if hyperbolic then (Math.exp(number) - Math.exp(-number)) / 2 else sine
end

function Math.cosine (number: number, hyperbolic: boolean?)
	-- Get the cosine of the number
	local cosine = 0

	for index = 0, Math.Precision, 1 do
		-- Taylor Series of Cosine
		cosine += ((-1)^index / Math.factorial(2 * index)) * (number^(2 * index))
	end

	return if hyperbolic then (Math.exponential(number) + Math.exponential(-number)) / 2 else cosine
end

function Math.tangent (number: number, hyperbolic: boolean?)
	-- Tangent is the ratio of sine and cosine
	return Math.sine(number, hyperbolic) / Math.cosine(number, hyperbolic)
end

function Math.cotangent (number: number, hyperbolic: boolean?)
	-- Cotangent is the ratio of cosine and sine
	return Math.cosine(number, hyperbolic) / Math.sine(number, hyperbolic)
end

function Math.secant (number: number, hyperbolic: boolean?)
	-- Secant is the ratio of 1 and cosine
	return 1 / Math.cosine(number, hyperbolic)
end

function Math.cosecant (number: number, hyperbolic: boolean?)
	-- Cosecant is the ratio of 1 and sine
	return 1 / Math.sine(number, hyperbolic)
end

function Math.logarithm (number: number, base: number?)
	local logarithm = 0

	for index = 0, Math.Precision, 1 do
		-- Taylor Series of Logarithm
		logarithm += ((-1)^index / (index + 1)) * ((number - 1)^(index + 1))
	end

	return if base then logarithm / Math.logarithm(base) else logarithm
end

function Math.exponential (number: number)
	local exponential = 0

	for index = 0, Math.Precision, 1 do
		-- Taylor Series of Exponential
		exponential += (1 / Math.factorial(index)) * (number^index)
	end

	return exponential
end

function Math.sign (number: number)
	return if number > 0 then 1 elseif number < 0 then -1 else 0
end

function Math.random (rangeOrRounded: NumberRange | boolean?, rounded: boolean?)
	local range = if typeof(rangeOrRounded) == 'NumberRange' then rangeOrRounded else NumberRange.new(0, 1)
	local random = 0
	
	for index = 1, 10, 1 do
		random += math.random()
	end
	
	random /= 10
	random = range.Min + (random * Math.distance(range.Min, range.Max))
	
	return if rangeOrRounded == true or rounded then Math.round(random) else random
end

-- Constants
Math.E6 = 2.718282 -- First 6 decimal places of E
Math.E12 = 2.718281828459 -- First 12..
Math.E18 = 2.718281828459045235
Math.E24 = 2.718281828459045235360287 -- Most precise
Math.E = Math.E12

Math.PI6 = 3.141593 -- First 6 decimal places of PI
Math.PI12 = 3.141592653590 -- First 12..
Math.PI18 = 3.141592653589793238
Math.PI24 = 3.141592653589793238462643 -- Most precise
Math.PI = Math.PI12

Math.TAU6 = Math.PI6 * 2 -- First 6 decimal places of TAU
Math.TAU12 = Math.PI12 * 2 -- First 12..
Math.TAU18 = Math.PI18 * 2
Math.TAU24 = Math.PI24 * 2 -- Most precise
Math.TAU = Math.TAU12

Math.PHI6 = 1.618034 -- First 6 decimal places of PHI
Math.PHI12 = 1.618033988750 -- First 12..
Math.PHI18 = 1.618033988749894848
Math.PHI24 = 1.618033988749894848204586 -- Most precise
Math.PHI = Math.PHI12

Math.INF = 2^1024 -- Highest storable number in Lua (infinity, inf)
Math.NAN = 0 / 0 -- Not a number (nan)

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
Math.tan = Math.tangent
Math.cotan = Math.cotangent
Math.sec = Math.secant
Math.cosec = Math.cosecant
Math.log = Math.logarithm
Math.exp = Math.exponential
Math.rand = Math.random

Math.sinh = function (number: number)
	return Math.sin(number, true)
end

Math.cosh = function (number: number)
	return Math.cos(number, true)
end

Math.tanh = function (number: number)
	return Math.tan(number, true)
end

Math.cotanh = function (number: number)
	return Math.cotan(number, true)
end

Math.sech = function (number: number)
	return Math.sec(number, true)
end

Math.cosech = function (number: number)
	return Math.cosec(number, true)
end

Math.log10 = function (number: number)
	return Math.logarithm(number, 10)
end

Math.log2 = function (number: number)
	return Math.logarithm(number, 2)
end

Math.logE = function (number: number)
	return Math.logarithm(number, Math.E)
end

return Math
