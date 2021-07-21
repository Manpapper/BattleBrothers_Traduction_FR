this.raise_all_undead_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.raise_all_undead";
		this.m.Name = "The Black Book";
		this.m.Description = "";
		this.m.Icon = "skills/active_213.png";
		this.m.IconDisabled = "skills/active_213.png";
		this.m.Overlay = "active_213";
		this.m.SoundOnUse = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.SoundVolume = 1.35;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		local entities = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
		local phylacteries = 0;

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.SkeletonPhylactery)
			{
				phylacteries = ++phylacteries;
			}
		}

		phylacteries = this.Math.max(0, phylacteries - this.Time.getRound() / 9);
		return this.skill.isUsable() && this.Tactical.Entities.getFlags().getAsInt("RaiseAllUndeadUsed") == 0 && phylacteries <= 6 && this.Tactical.Entities.getCorpses().len() >= 6;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function spawnUndead( _user, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		p.Faction = _user.getFaction();
		local e = this.Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
		}

		return e;
	}

	function onUse( _user, _targetTile )
	{
		local corpses = clone this.Tactical.Entities.getCorpses();

		foreach( c in corpses )
		{
			if (!c.IsEmpty)
			{
				continue;
			}

			if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
			{
				continue;
			}

			if (c.IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, c, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}

			local e = this.spawnUndead(_user, c);

			if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local item;

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
				{
					item = this.new("scripts/items/weapons/ancient/warscythe");
				}
				else
				{
					item = this.new("scripts/items/weapons/ancient/khopesh");
				}

				e.getItems().equip(item);
				item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
			}
		}

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has mastered death!");
		this.Tactical.Entities.getFlags().increment("RaiseAllUndeadUsed");
		return true;
	}

});

