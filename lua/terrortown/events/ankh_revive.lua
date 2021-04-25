if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/ankh_revive")
	EVENT.title = "title_event_ankh_revive"

	function EVENT:GetText()
		return {
			{
				string = "desc_event_ankh_revive",
				params = {
					owner = self.event.owner.nick,
					role = roles.GetByIndex(self.event.owner.role).name,
					team = self.event.owner.team,
				},
				translateParams = true
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(owner)
		if not IsValid(owner) then return end

		self:AddAffectedPlayers(
			{owner:SteamID64()},
			{owner:Nick()}
		)

		return self:Add({
			owner = {
				nick = owner:Nick(),
				sid64 = owner:SteamID64(),
				role = owner:GetSubRole(),
				team = owner:GetTeam(),
			}
		})
	end
end

function EVENT:Serialize()
	return self.event.owner.nick .. " used his ankh to respawn."
end
