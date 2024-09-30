-- Fortune provides helper functions to create random values, vectors, choices stc.
local fortune = {}

-- When this module imported for the first time, we seed the random-generator with the current time
math.randomseed(os.time())

-- Flip returns true or false (flip a coin)
function fortune.flip()
    return math.random(1, 2) == 1
end

-- Returns a random floatingpoint number between the from and to values (from and to included)
function fortune.rand(from, to)
    return (math.random() * math.abs(to - from)) + math.min(from, to)
end

function fortune.rand_int(from, to)
    return math.random(from, to)
end

-- Returns a random vector
function fortune.rand_v2(minX, maxX, minY, maxY)
    return v2(fortune.rand(minX, maxX), fortune.rand(minY, maxY))
end

function fortune.rand_v2_int(minX, maxX, minY, maxY)
    return v2(fortune.rand_int(minX, maxX), fortune.rand_int(minY, maxY))
end

-- Choose a random element from a list
function fortune.choice(elements)
    return elements[math.random(1, #elements)]
end

-- Shuffle the elements in a list
function fortune.shuffle(list)
    for i = #list, 2, -1 do
        local j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end
    return list
end

-- Choose and element from a list of weighted elements { {ElemA, WeightA}, {ElemB, WeightB}, {ElemC, WeightC} }
function fortune.weightedChoice(elements)
    local totalweight = 0
    for _, element in ipairs(elements) do
        totalweight = totalweight + element[2]
    end

    local randvalue = fortune.rand(0, totalweight)
    for _, element in ipairs(elements) do
        randvalue = randvalue - element[2]
        if randvalue <= 0 then
            return element[1]
        end
    end
end

return fortune
