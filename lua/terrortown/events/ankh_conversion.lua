if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/ankh_conversion")
	EVENT.title = "title_event_ankh_conversion"

	function EVENT:GetText()
		return {
			{
				string = "desc_event_ankh_conversion",
				params = {
					old = self.event.oldOwner.nick,
					orole = roles.GetByIndex(self.event.oldOwner.role).name,
					oteam = self.event.oldOwner.team,
					new = self.event.newOwner.nick,
					nrole = roles.GetByIndex(self.event.newOwner.role).name,
					nteam = self.event.newOwner.team
				},
				translateParams = true
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(oldOwner, newOwner)
		if not IsValid(oldOwner) or not IsValid(newOwner) then return end

		self:AddAffectedPlayers(
			{oldOwner:SteamID64(), newOwner:SteamID64()},
			{oldOwner:Nick(), newOwner:Nick()}
		)

		return self:Add({
			oldOwner = {
				nick = oldOwner:Nick(),
				sid64 = oldOwner:SteamID64(),
				role = oldOwner:GetSubRole(),
				team = oldOwner:GetTeam(),
			},
			newOwner = {
				nick = newOwner:Nick(),
				sid64 = newOwner:SteamID64(),
				role = newOwner:GetSubRole(),
				team = newOwner:GetTeam(),
			}
		})
	end

	function EVENT:CalculateScore()
		local event = self.event

		self:SetPlayerScore(event.newOwner.sid64, {
			score = 1
		})
	end
end

function EVENT:Serialize()
	return self.event.newOwner.nick .. " stole the ankh from " .. self.event.oldOwner.nick .. "."
end
