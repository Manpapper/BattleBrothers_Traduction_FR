this.town_temple_dialog_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function create()
	{
		this.m.ID = "TempleDialogModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.ui_module.destroy();
	}

	function clear()
	{
	}

	function onLeaveButtonPressed()
	{
		this.m.Parent.onModuleClosed();
	}

	function queryRosterInformation()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local roster = [];

		foreach( b in brothers )
		{
			local injuries = [];
			local allInjuries = b.getSkills().query(this.Const.SkillType.TemporaryInjury);

			for( local i = 0; i != allInjuries.len(); i = ++i )
			{
				local inj = allInjuries[i];

				if (!inj.isTreated() && inj.isTreatable())
				{
					injuries.push({
						id = inj.getID(),
						icon = inj.getIconColored(),
						name = inj.getNameOnly(),
						price = inj.getPrice()
					});
				}
			}

			if (injuries.len() == 0)
			{
				continue;
			}

			local background = b.getBackground();
			local e = {
				ID = b.getID(),
				Name = b.getName(),
				ImagePath = b.getImagePath(),
				ImageOffsetX = b.getImageOffsetX(),
				ImageOffsetY = b.getImageOffsetY(),
				BackgroundImagePath = background.getIconColored(),
				BackgroundText = background.getDescription(),
				Injuries = injuries
			};
			roster.push(e);
		}

		return {
			Title = "Temple",
			SubTitle = "Faites soigner vos blessés par des prêtres et priez pour eux.",
			Roster = roster,
			Assets = this.m.Parent.queryAssetsInformation()
		};
	}

	function onTreatInjury( _data )
	{
		local entityID = _data[0];
		local injuryID = _data[1];
		local entity = this.Tactical.getEntityByID(entityID);
		local injury = entity.getSkills().getSkillByID(injuryID);
		injury.setTreated(true);
		this.World.Assets.addMoney(-injury.getPrice());
		entity.updateInjuryVisuals();
		local injuries = [];
		local allInjuries = entity.getSkills().query(this.Const.SkillType.TemporaryInjury);

		foreach( inj in allInjuries )
		{
			if (!inj.isTreated())
			{
				injuries.push({
					id = inj.getID(),
					icon = inj.getIconColored(),
					name = inj.getNameOnly(),
					price = inj.getPrice()
				});
			}
		}

		local background = entity.getBackground();
		local e = {
			ID = entity.getID(),
			Name = entity.getName(),
			ImagePath = entity.getImagePath(),
			ImageOffsetX = entity.getImageOffsetX(),
			ImageOffsetY = entity.getImageOffsetY(),
			BackgroundImagePath = background.getIconColored(),
			BackgroundText = background.getDescription(),
			Injuries = injuries
		};
		local r = {
			Entity = e,
			Assets = this.m.Parent.queryAssetsInformation()
		};
		this.World.Statistics.getFlags().increment("InjuriesTreatedAtTemple");
		this.updateAchievement("PatchedUp", 1, 1);
		return r;
	}

});

