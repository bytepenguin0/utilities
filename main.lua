local utilities = {}

utilities.dragify = {}
utilities.dragify.__index = utilities.dragify

function utilities.drag(data)
    assert(data, "missing data")

    assert(data["frame"] ~= nil, "missing 'frame'")

    data = setmetatable(data, utilities.dragify)

    local dragToggle, dragInput, dragStart, startPos

    if not data.canDrag then
        data.canDrag = true
    end

    data.frame.InputBegan:Connect(function(input)
        if not data.canDrag then
            return
        end

        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
            dragToggle = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = data.frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    data.frame.InputChanged:Connect(function(input)
        if not data.canDrag then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if not data.canDrag then
            return
        end

        if input == dragInput and dragToggle then
            local inputPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = inputPos - dragStart
            local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

            if data.dragSpeed and typeof(data.dragSpeed) == "number" then
                game:GetService("TweenService"):Create(data.frame, TweenInfo.new(data.dragSpeed), {["Position"] = position}):Play()
            else
                data.frame.Position = position
            end
        end
    end)
    
    return data
end

return utilities