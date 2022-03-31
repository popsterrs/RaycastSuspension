for wheelName, originalPosition in pairs(WheelPositions)do

    local carCFrame = carPrim.CFrame
    local rayOrigin = carCFrame:ToWorldSpace(CFrame.new(originalPosition)).p
    local rayDirection = -carCFrame.UpVector * (SuspensionMaxLength + wheelRadius)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {carModel}
    local raycast = workspace:Raycast(rayOrigin,rayDirection,rayParams)

    if raycast then

        local RaycastDistance = (rayOrigin - raycast.Position).magnitude

        local SpringLength = math.clamp(RaycastDistance - wheelRadius, 0, SuspensionMaxLength)
        local StiffnessForce = Stiffness * (SuspensionMaxLength - SpringLength)
        local DamperForce = Damper * (( SpringLengthMemory[wheelName] - SpringLength) / delta)
        local SuspensionForceVec3 = carCFrame.UpVector * (StiffnessForce + DamperForce)

        local RotationsOnlyWheelDirCFrame = CFrame.lookAt(Vector3.zero,carCFrame.LookVector,carCFrame.UpVector)
        if string.sub(wheelName,1,1)=='F' then
            RotationsOnlyWheelDirCFrame = RotationsOnlyWheelDirCFrame * CFrame.Angles(0,-math.rad(SmoothSteer * SteerAngle),0)
        end
        local LocalVelocity = RotationsOnlyWheelDirCFrame:ToObjectSpace(CFrame.new(carPrim:GetVelocityAtPosition(raycast.Position)))

        local Xforce = RotationsOnlyWheelDirCFrame.RightVector * -LocalVelocity.x * wheelFriction
        local Zforce = RotationsOnlyWheelDirCFrame.LookVector * seatPart.ThrottleFloat * torque * (math.sign(-LocalVelocity.z)==seatPart.Throttle and(1 - math.min(1,math.abs(LocalVelocity.z)/MaxSpeed))or 1)

        SpringLengthMemory[wheelName] = SpringLength

        carPrim:ApplyImpulseAtPosition(SuspensionForceVec3 + Xforce + Zforce, raycast.Position)

    else
        SpringLengthMemory[wheelName] = SuspensionMaxLength
    end

end