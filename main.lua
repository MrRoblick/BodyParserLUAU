local function Parse(text: string, startIndex: number, endIndex: number, results: {string}): ()
    local foundStart: number = 0
    local foundEnd: number = 0
    local lastDoIndex: number = 0
    local lastEndIndex: number = 0
    for i: number = startIndex, endIndex do
        local char: string = text:sub(i, i)
        if char == "{" then
            foundStart += 1
            lastDoIndex = i
            i += 1
        elseif char == "}" then
            foundEnd += 1
            lastEndIndex = i
            i += 2
        end
        if foundStart == foundEnd and foundStart > 0 then
            local block = text:sub(startIndex, lastEndIndex+2)
            table.insert(results, block)
            Parse(text, i+1, endIndex, results)
            break
        end
    end
    if foundStart > foundEnd then
        error("Expected '}'")
    elseif foundEnd > foundStart then
        error("Expected '{'")
    end
end

local function ParseBody(text: string, startIndex: number?, endIndex: number?): {string}
    local results: {string} = {}
    Parse(text, startIndex or 1, endIndex or #text, results)
    return results
end

local s: string = [[

{
    Hello
    {
        Yees
    }
}

{
    World
}


]]

local results: {string} = ParseBody(s)
for _, v: string in results do
    print('-----------')
    print(v)
end
