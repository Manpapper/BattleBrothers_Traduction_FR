this.fake_drink_night_vision_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.fake_drink_night_vision";
		this.m.Name = "Boire un Élixir de Vision Nocturne";
		this.m.Description = "Buvez une prouesse alchimique pour voir dans la nuit comme s\'il était midi. Ne peut être utilisé si le personnage est engagé en mêlée";
		this.m.Icon = "skills/active_142.png";
		this.m.IconDisabled = "skills/active_142_sw.png";
		this.m.Overlay = "active_142";
		this.m.SoundOnUse = [
			"sounds/combat/drink_01.wav",
			"sounds/combat/drink_02.wav",
			"sounds/combat/drink_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 10;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Supprime l\'effet Nuit"
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Ne peut être utilisé car le personnage est engagé en mêlée[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onUse( _user, _targetTile )
	{
		_user.getSkills().removeByID("special.night");

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " boit un Élixir de Vision Nocturne");
		}

		return true;
	}

});

