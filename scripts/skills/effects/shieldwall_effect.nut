this.shieldwall_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.shieldwall";
		this.m.Name = "Mur de boulier";
		this.m.Description = "Ayant un bouclier équipé, ce personnage bénéficie d\'une défense accrue.";
		this.m.Icon = "skills/status_effect_03.png";
		this.m.IconMini = "status_effect_03_mini";
		this.m.Overlay = "status_effect_03";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getBonus()
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return 0;
		}

		local myTile = actor.getTile();
		local num = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (!tile.IsEmpty && tile.IsOccupiedByActor && this.Math.abs(myTile.Level - tile.Level) <= 1)
				{
					local entity = tile.getEntity();

					if (actor.getFaction() == entity.getFaction() && entity.getSkills().hasSkill("effects.shieldwall"))
					{
						num = ++num;
					}
				}
			}
		}

		return this.Math.min(this.Const.Combat.ShieldWallMaxAllies, num) * 5;
	}

	function getTooltip()
	{
		local bonus = this.getBonus();
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local mult = 1.0;
		local proficiencyBonus = 0;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			mult = mult * 1.25;
		}

		if (this.getContainer().getActor().getCurrentProperties().IsProficientWithShieldSkills)
		{
			proficiencyBonus = 5;
		}

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription() + (bonus > 0 ? " En formant un solide mur de bouclier avec des alliés à proximité, la défense est encore plus augmentée." : "")
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(item.getMeleeDefense() * mult + bonus + proficiencyBonus) + "[/color] de Défense de Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(item.getRangedDefense() * mult + bonus + proficiencyBonus) + "[/color] de Défense à Distance"
			}
		];
	}

	function onAdded()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
			item.onShieldUp();
		}
	}

	function onUpdate( _properties )
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (item.isItemType(this.Const.Items.ItemType.Shield) && item.getCondition() > 0)
		{
			local mult = 1.0;
			local proficiencyBonus = 0;

			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
			{
				mult = mult * 1.25;
			}

			if (this.getContainer().getActor().getCurrentProperties().IsProficientWithShieldSkills)
			{
				proficiencyBonus = 5;
			}

			_properties.MeleeDefense += this.Math.floor(item.getMeleeDefense() * mult) + proficiencyBonus;
			_properties.RangedDefense += this.Math.floor(item.getRangedDefense() * mult) + proficiencyBonus;
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onRemoved()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (item != null && item.isItemType(this.Const.Items.ItemType.Shield))
		{
			item.onShieldDown();
		}
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		local bonus = this.getBonus();
		_properties.MeleeDefense += bonus;
		_properties.RangedDefense += bonus;
	}

});

