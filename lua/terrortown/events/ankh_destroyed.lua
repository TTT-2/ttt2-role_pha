if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/ankh_destroyed")
	EVENT.title = "title_event_ankh_destroyed"

	function EVENT:GetText()
		return {
			{
				string = "desc_event_ankh_destroyed",
				params = {
					old = self.event.oldOwner.nick,
					orole = roles.GetByIndex(self.event.oldOwner.role).name,
					oteam = self.event.oldOwner.team,
					attacker = self.event.attacker.nick,
					arole = roles.GetByIndex(self.event.attacker.role).name,
					ateam = self.event.attacker.team
				},
				translateParams = true
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(oldOwner, attacker)
		if not IsValid(oldOwner) or not IsValid(attacker) then return end

		self:AddAffectedPlayers(
			{oldOwner:SteamID64(), attacker:SteamID64()},
			{oldOwner:Nick(), attacker:Nick()}
		)

		return self:Add({
			oldOwner = {
				nick = oldOwner:Nick(),
				sid64 = oldOwner:SteamID64(),
				role = oldOwner:GetSubRole(),
				team = oldOwner:GetTeam(),
			},
			attacker = {
				nick = attacker:Nick(),
				sid64 = attacker:SteamID64(),
				role = attacker:GetSubRole(),
				team = attacker:GetTeam(),
			}
		})
	end
end

function EVENT:Serialize()
	return self.event.attacker.nick .. " destroyed the ankh of " .. self.event.oldOwner.nick .. "."
end
