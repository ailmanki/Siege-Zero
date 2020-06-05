//Kyle 'Avoca' Abent
if Server then 
    local origInit = PowerPoint.OnInitialized
    function PowerPoint:OnInitialized()
    origInit(self)
    self.SpawnTableOne = {}
    self.SpawnTableTwo = {}
    self.SpawnTableThree = {}
    self:GenerateTables()
    self.hasBeenToggledDuringSetup = false //OnReset???
    end

    //So every point will have three tables pre-configured/saved which will lessen dynamic calculations in game heh.


    function PowerPoint:GenerateTables()
        print("Powerpoint Generating spawn tables")
        
        //Unfortunately, cross reference previous spawnpoints ensuring current spawnpoint eligibility. 
            //Although in theory this is a f* headeache. 
                //(Like it would be neat to remove the used , insert back when used to unused and such)
            
            //So for the first one. Start by looking at a free space from the powerpoint. A distance a way.
                //Then the second, build from the first. Look a space from the first. A distance. 
                    //Then the third from the second. 
                        //Each building from previous 
                            //Rather than blindly looking. An analysis. 
                                //So the table two index 0/1 will have an offset from the index from first table 0/1 that the first table 2/3 went a different direction from 
            
            local maxAttempts = 100
            local maxSizePer = 25
            //local allLocations = GetAllLocationsWithSameName(self:GetOrigin())
            
            local currentIndexLocation = nil
            
            //One
            for i = 0, maxAttempts do 
            
                if i == 0 then // start from power
                    currentIndexLocation = self:GetOrigin()
                    if currentIndexLocation ~= nil then 
                        table.insert(self.SpawnTableOne, FindFreeSpace(currentIndexLocation,4,20) )
                        currentIndexLocation = nil//temp
                    end
                else //well i could be 1 but the index 0 could be empty. fuck. haha. Lets assume that the index 0 is ok. lol. Power origin should be fine.
                    //currentIndexLocation = FindFreeSpace(self.SpawnTableOne[i-1], 4, 20) this errors, last index nil. try moving.
                    currentIndexLocation = self.SpawnTableOne[i-1]
                    if currentIndexLocation ~= nil then 
                        //table.insert(self.SpawnTableOne, currentIndexLocation)
                        table.insert(self.SpawnTableOne, FindFreeSpace(currentIndexLocation,4,20) )
                        currentIndexLocation = nil//temp
                    end
                    //Analyze previous entry
                end
          
                //Make sure this does not get in way of previous entry? if possible.. 
                
                if #self.SpawnTableOne == maxSizePer then
                    break
                end
                
            end
            
            //Two
            for i = 0, maxAttempts do 
                 currentIndexLocation = self.SpawnTableOne[i]
                    if currentIndexLocation ~= nil then 
                        table.insert(self.SpawnTableTwo, FindFreeSpace(currentIndexLocation,4,20) )
                        currentIndexLocation = nil//temp
                    end
                if #self.SpawnTableTwo == maxSizePer then
                    break
                end
            end
            
            //Three
            for i = 0, maxAttempts do 
                 currentIndexLocation = self.SpawnTableTwo[i]
                    if currentIndexLocation ~= nil then 
                        table.insert(self.SpawnTableThree, FindFreeSpace(currentIndexLocation, 4, 20) )
                        currentIndexLocation = nil//temp
                    end
                if #self.SpawnTableThree == maxSizePer then
                    break
                end
            end
            

    end

    function PowerPoint:GetRandomSpawnPoint()
    print("PowerPoint GetRandomSpawnPoint")
    local whichTable = math.random(1,3)
        //Well assuming the spot isn't taken. Which it will be. Sometimes. on occasion. it will happen. lol.
        if whichTable == 1 then
            return table.random(self.SpawnTableOne)
        elseif whichTable == 2 then
            return table.random(self.SpawnTableTwo)
        elseif whichTable == 3 then
            return table.random(self.SpawnTableThree)
        end

    end
    
    function PowerPoint:GetHasBeenToggledDuringSetup()
        return self.hasBeenToggledDuringSetup
    end
    
    local origKill = PowerPoint.OnKill
    
     function PowerPoint:OnKill(attacker, doer, point, direction)
        origKill(self, attacker, doer, point, direction)
        local isSetup = not GetSetupConcluded()
        if isSetup or GetIsOriginInHiveRoom(self:GetOrigin()) then // Well if darksiege2016b tall room (marine sided room in setup with a tech point in it..) .. lol ... ahh
            self.hasBeenToggledDuringSetup = true
        end
     end

end