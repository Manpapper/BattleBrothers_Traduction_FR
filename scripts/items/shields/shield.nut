this.shield <- this.inherit("scripts/items/item", {
	m = {
		AddGenericSkill = true,
		ShowOnCharacter = true,
		Sprite = "",
		SpriteDamaged = "",
		SoundOnDestroyed = this.Const.Sound.ShieldDestroyed,
		SoundOnHit = this.Const.Sound.ShieldHitWood,
		ShieldDecal = this.Const.Items.Default.ShieldDecal,
		MeleeDefense = 0,
		RangedDefense = 0,
		StaminaModifier = 0,
		FatigueOnSkillUse = 0
	},
	function isAmountShown()
	{
		return this.m.Condition != this.m.ConditionMax;
	}

	function getAmountString()
	{
		return "" + this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * 100) + "%";
	}

	function getAmountColor()
	{
		return this.Const.Items.ConditionColor[this.Math.min(this.Math.max(0, this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * (this.Const.Items.ConditionColor.len() - 1))), this.Const.Items.ConditionColor.len() - 1)];
	}

	function getMeleeDefense()
	{
		return this.m.MeleeDefense;
	}

	function getRangedDefense()
	{
		return this.m.RangedDefense;
	}

	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function getValue()
	{
		return this.Math.ceil(this.m.Value * (this.m.Condition * 1.0 / (this.m.ConditionMax * 1.0)));
	}

	function getSlotType()
	{
		if (this.m.Condition > 0)
		{
			return this.m.SlotType;
		}
		else
		{
			return this.Const.ItemSlot.None;
		}
	}

	function create()
	{
		this.m.ItemType = this.Const.Items.ItemType.Shield;
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.IsDroppedAsLoot = true;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		result.push({
			id = 4,
			type = "progressbar",
			icon = "ui/icons/asset_supplies.png",
			value = this.getCondition(),
			valueMax = this.getConditionMax(),
			text = "" + this.getCondition() + " / " + this.getConditionMax() + "",
			style = "armor-head-slim"
		});

		if (this.m.MeleeDefense > 0)
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.MeleeDefense + "[/color] de Défense en Mêlée"
			});
		}

		if (this.m.RangedDefense > 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RangedDefense + "[/color] de Défense à Distance"
			});
		}

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] de Fatigue Maximum"
			});
		}

		if (this.m.FatigueOnSkillUse > 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Les compétences de bouclier produisent [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.FatigueOnSkillUse + "[/color] de Fatigue en plus"
			});
		}
		else if (this.m.FatigueOnSkillUse < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Les compétences de bouclier produisent [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.FatigueOnSkillUse + "[/color] de Fatigue en moins"
			});
		}

		if (this.m.Condition == 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Cassé et inutilisable [/color]"
			});
		}

		return result;
	}

	function isDroppedAsLoot()
	{
		if (!this.item.isDroppedAsLoot())
		{
			return false;
		}

		local isPlayer = this.m.LastEquippedByFaction == this.Const.Faction.Player || this.getContainer() != null && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.isKindOf(this.getContainer().getActor().get(), "player");
		local isLucky = !this.Tactical.State.isScenarioMode() && !isPlayer && this.World.Assets.getOrigin().isDroppedAsLoot(this);
		local isBlacksmithed = isPlayer && !this.Tactical.State.isScenarioMode() && this.World.Assets.m.IsBlacksmithed;

		if ((isBlacksmithed || this.m.Condition >= 6) && (isPlayer || this.m.Condition / this.m.ConditionMax >= 0.25) && (isPlayer || isLucky || isBlacksmithed || !isPlayer && this.isItemType(this.Const.Items.ItemType.Named) || this.isItemType(this.Const.Items.ItemType.Legendary) || this.Math.rand(1, 100) <= 90))
		{
			return true;
		}

		return false;
	}

	function applyShieldDamage( _damage, _playHitSound = true )
	{
		if (this.m.Condition == 0)
		{
			return;
		}

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			_damage = this.Math.max(1, this.Math.ceil(_damage * 0.5));
		}

		local Condition = this.m.Condition;
		Condition = this.Math.maxf(0.0, this.m.Condition - _damage);

		if (Condition == 0)
		{
			if (this.m.SoundOnDestroyed.len() != 0)
			{
				this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			}

			if (this.m.ShieldDecal.len() > 0)
			{
				local ourTile = this.getContainer().getActor().getTile();
				local candidates = [];

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!ourTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = ourTile.getNextTile(i);

						if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
						{
							candidates.push(tile);
						}
					}
				}

				if (candidates.len() != 0)
				{
					local tileToSpawnAt = candidates[this.Math.rand(0, candidates.len() - 1)];
					tileToSpawnAt.spawnDetail(this.m.ShieldDecal);
					tileToSpawnAt.Properties.add("IsItemSpawned");
					tileToSpawnAt.Properties.add("IsShieldItemSpawned");
				}
				else if (!ourTile.Properties.has("IsItemSpawned") && !ourTile.IsCorpseSpawned)
				{
					ourTile.spawnDetail(this.m.ShieldDecal);
					ourTile.Properties.add("IsItemSpawned");
					ourTile.Properties.add("IsShieldItemSpawned");
				}
			}

			local actor = this.getContainer().getActor();
			local isPlayer = this.m.LastEquippedByFaction == this.Const.Faction.Player || actor != null && !actor.isNull() && this.isKindOf(actor.get(), "player");
			local isBlacksmithed = isPlayer && !this.Tactical.State.isScenarioMode() && this.World.Assets.m.IsBlacksmithed;
			this.m.Container.unequip(this);
			this.m.Condition = Condition;

			if (isBlacksmithed)
			{
				this.drop(actor.getTile());
			}
		}
		else
		{
			this.m.Condition = Condition;

			if (_playHitSound && this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
				this.Sound.play(this.m.SoundOnDestroyed[this.Math.rand(0, this.m.SoundOnDestroyed.len() - 1)], this.Const.Sound.Volume.Skill * 0.33, this.getContainer().getActor().getPos());
			}

			if (this.m.ShowOnCharacter)
			{
				local app = this.getContainer().getAppearance();

				if (this.m.Condition == 0)
				{
					app.Shield = "";
				}
				else if (this.m.Condition / (this.m.ConditionMax * 1.0) <= this.Const.Combat.ShowDamagedShieldThreshold)
				{
					app.Shield = this.m.SpriteDamaged;
				}
				else
				{
					app.Shield = this.m.Sprite;
				}

				this.getContainer().updateAppearance();
			}
		}
	}

	function onShieldUp()
	{
		if (!this.m.ShowOnCharacter)
		{
			return;
		}

		local app = this.getContainer().getAppearance();
		app.RaiseShield = true;
		this.getContainer().updateAppearance();
	}

	function onShieldDown()
	{
		if (!this.m.ShowOnCharacter)
		{
			return;
		}

		local app = this.getContainer().getAppearance();
		app.RaiseShield = false;
		this.getContainer().updateAppearance();
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/shieldwall_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Inventory);
	}

	function updateAppearance()
	{
		if (this.getContainer() == null || !this.isEquipped())
		{
			return;
		}

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();

			if (this.m.Condition == 0)
			{
				app.Shield = "";
			}
			else if (this.m.Condition / this.m.ConditionMax <= this.Const.Combat.ShowDamagedShieldThreshold)
			{
				app.Shield = this.m.SpriteDamaged;
			}
			else
			{
				app.Shield = this.m.Sprite;
			}

			this.getContainer().updateAppearance();
		}
	}

	function addSkill( _skill )
	{
		this.item.addSkill(_skill);

		if (_skill.isType(this.Const.SkillType.Active))
		{
			_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
		}
	}

	function onEquip()
	{
		this.item.onEquip();

		if (this.m.AddGenericSkill)
		{
			this.addGenericItemSkill();
		}

		this.updateAppearance();
	}

	function onUnequip()
	{
		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Shield = "";
			app.RaiseShield = false;
			this.getContainer().updateAppearance();
		}
	}

	function onUpdateProperties( _properties )
	{
		if (this.m.Condition == 0)
		{
			return;
		}

		local mult = 1.0;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			mult = 1.25;
		}

		_properties.MeleeDefense += this.Math.floor(this.m.MeleeDefense * mult);
		_properties.RangedDefense += this.Math.floor(this.m.RangedDefense * mult);
		_properties.Stamina += this.m.StaminaModifier;
	}

	function onCombatFinished()
	{
		this.updateAppearance();
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition);
	}

});

