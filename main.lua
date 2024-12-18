return {
    dragify = function(frame, dragSpeed)
        local dragToggle
        local dragInput
        local dragStart
        local startPos

        frame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
                dragToggle = true
                dragStart = Vector2.new(input.Position.X, input.Position.Y)
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragToggle then
                local inputPos = Vector2.new(input.Position.X, input.Position.Y)

                local delta = inputPos - dragStart
                local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                print(position)

                if dragSpeed and typeof(dragSpeed) == "number" then
                    game:GetService("TweenService"):Create(frame, TweenInfo.new(dragSpeed), {["Position"] = position}):Play()
                else
                    frame.Position = position
                end
            end
        end)
    end
}