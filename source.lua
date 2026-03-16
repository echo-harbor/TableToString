local function serialize(value, indent)
    indent = indent or 0
    local t = typeof(value)

    if t == "string" then
        return string.format("%q", value)

    elseif t == "number" then
        return tostring(value)

    elseif t == "boolean" then
        return tostring(value)

    elseif t == "nil" then
        return "nil"

    elseif t == "Color3" then
        return string.format("Color3.new(%g, %g, %g)", value.R, value.G, value.B)

    elseif t == "BrickColor" then
        return string.format("BrickColor.new(\"%s\")", tostring(value))

    elseif t == "Vector3" then
        return string.format("Vector3.new(%g, %g, %g)", value.X, value.Y, value.Z)

    elseif t == "Vector2" then
        return string.format("Vector2.new(%g, %g)", value.X, value.Y)

    elseif t == "CFrame" then
        local c = value
        return string.format(
            "CFrame.new(%g,%g,%g, %g,%g,%g, %g,%g,%g, %g,%g,%g)",
            c.X, c.Y, c.Z,
            c.RightVector.X, c.RightVector.Y, c.RightVector.Z,
            c.UpVector.X,    c.UpVector.Y,    c.UpVector.Z,
            -c.LookVector.X, -c.LookVector.Y, -c.LookVector.Z
        )

    elseif t == "UDim2" then
        return string.format(
            "UDim2.new(%g, %g, %g, %g)",
            value.X.Scale, value.X.Offset,
            value.Y.Scale, value.Y.Offset
        )

    elseif t == "UDim" then
        return string.format("UDim.new(%g, %g)", value.Scale, value.Offset)

    elseif t == "Rect" then
        return string.format(
            "Rect.new(%g, %g, %g, %g)",
            value.Min.X, value.Min.Y,
            value.Max.X, value.Max.Y
        )

    elseif t == "table" then
        local lines = {}
        local pad = string.rep("    ", indent + 1)
        local closePad = string.rep("    ", indent)

        local isArray = true
        local maxN = 0
        for k, _ in pairs(value) do
            if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
                isArray = false
                break
            end
            if k > maxN then maxN = k end
        end
        if isArray and maxN ~= #value then isArray = false end

        if isArray then
            for i = 1, #value do
                table.insert(lines, pad .. serialize(value[i], indent + 1))
            end
        else
            for k, v in pairs(value) do
                local keyStr
                if type(k) == "string" and k:match("^[%a_][%w_]*$") then
                    keyStr = k
                else
                    keyStr = "[" .. serialize(k, indent + 1) .. "]"
                end
                table.insert(lines, pad .. keyStr .. " = " .. serialize(v, indent + 1))
            end
        end

        if #lines == 0 then return "{}" end
        return "{\n" .. table.concat(lines, ",\n") .. "\n" .. closePad .. "}"

    else
        return tostring(value)
    end
end

return function(tbl)
	return serialize(tbl)
end
