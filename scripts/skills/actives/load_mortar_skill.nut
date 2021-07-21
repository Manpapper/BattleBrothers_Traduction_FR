this.load_mortar_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.load_mortar";
		this.m.Name = "Charger l\'obus";
		this.m.Description = "";
		this.m.Icon = "skills/active_212.png";
		this.m.IconDisabled = "skills/active_212.png";
		this.m.Overlay = "active_212";
		this.m.SoundOnUse = [];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 10;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local myTile = this.getContainer().getActor().getTile();

		if (myTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return false;
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsOccupiedByActor && nextTile.getEntity().getType() == this.Const.EntityType.Mortar && this.getContainer().getActor().isAlliedWith(nextTile.getEntity()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		return true;
	}

});

