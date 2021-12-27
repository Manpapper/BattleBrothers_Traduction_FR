this.armor <- this.inherit("scripts/items/item", {
	m = {
		AddGenericSkill = true,
		ShowOnCharacter = false,
		HideBody = false,
		Sprite = null,
		SpriteDamaged = null,
		SpriteCorpse = null,
		VariantString = "body",
		ImpactSound = this.Const.Sound.ArmorLeatherImpact,
		InventorySound = this.Const.Sound.ArmorLeatherImpact,
		StaminaModifier = 0,
		Upgrade = null
	},
	function getArmor()
	{
		return this.Math.floor(this.m.Condition);
	}

	function getArmorMax()
	{
		return this.Math.floor(this.m.ConditionMax);
	}

	function setArmor( _a )
	{
		this.m.Condition = _a;
		this.updateAppearance();
	}

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
		return this.Const.Items.ConditionColor[this.Math.max(0, this.Math.floor(this.m.Condition / (this.m.ConditionMax * 1.0) * (this.Const.Items.ConditionColor.len() - 1)))];
	}

	function getUpgrade()
	{
		return this.m.Upgrade;
	}

	function getIconOverlay()
	{
		return this.m.Upgrade != null ? this.m.Upgrade.getOverlayIcon() : "";
	}

	function getIconLargeOverlay()
	{
		return this.m.Upgrade != null ? this.m.Upgrade.getOverlayIconLarge() : "";
	}

	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function getValue()
	{
		return this.Math.floor(this.m.Value * (this.m.Condition / this.m.ConditionMax) + (this.m.Upgrade != null ? this.m.Upgrade.getValue() : 0));
	}

	function setUpgrade( _upgrade )
	{
		if (!this.Const.DLC.Unhold && !this.Const.DLC.Wildmen && !this.Const.DLC.Desert)
		{
			return;
		}

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onRemoved();
		}

		this.m.Upgrade = _upgrade;

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.setArmor(this);
			this.m.Upgrade.onAdded();
		}

		this.updateAppearance();
	}

	function create()
	{
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ItemType = this.Const.Items.ItemType.Armor;
		this.m.ShowOnCharacter = true;
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
				text = this.getDescription() + (this.m.Upgrade != null ? " " + this.m.Upgrade.getArmorDescription() : "")
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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

		if (this.m.Upgrade != null)
		{
			if (this.m.Upgrade.getIconLarge() != null)
			{
				result.push({
					id = 3,
					type = "image",
					image = this.m.Upgrade.getIconLarge(),
					isLarge = true
				});
			}
			else
			{
				result.push({
					id = 3,
					type = "image",
					image = this.m.Upgrade.getIcon()
				});
			}
		}

		result.push({
			id = 4,
			type = "progressbar",
			icon = "ui/icons/armor_body.png",
			value = this.m.Condition,
			valueMax = this.m.ConditionMax,
			text = "" + this.getArmor() + " / " + this.getArmorMax() + "",
			style = "armor-body-slim"
		});

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] Fatigue Maximum "
			});
		}

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.getArmorTooltip(result);
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

		if (this.m.Condition > 10 && isPlayer || this.m.Condition > 30 && this.m.Condition / this.m.ConditionMax >= 0.25 || !isPlayer && this.isItemType(this.Const.Items.ItemType.Named) || this.isItemType(this.Const.Items.ItemType.Legendary) || isLucky || isBlacksmithed)
		{
			return true;
		}

		return false;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play(this.m.InventorySound[this.Math.rand(0, this.m.InventorySound.len() - 1)], this.Const.Sound.Volume.Inventory);
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_" + this.m.VariantString + "_" + variant;
		this.m.SpriteDamaged = "bust_" + this.m.VariantString + "_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_" + this.m.VariantString + "_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_" + this.m.VariantString + "_armor_" + variant + ".png";
		this.m.Icon = "armor/icon_" + this.m.VariantString + "_armor_" + variant + ".png";
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
			app.CorpseArmor = this.m.SpriteCorpse;
			app.HideBody = this.m.HideBody;
			app.ImpactSound[this.Const.BodyPart.Body] = this.m.ImpactSound;

			if (this.m.Condition / this.m.ConditionMax <= this.Const.Combat.ShowDamagedArmorThreshold)
			{
				if (this.m.SpriteDamaged != null)
				{
					app.Armor = this.m.SpriteDamaged;
				}
			}
			else if (this.m.Sprite != null)
			{
				app.Armor = this.m.Sprite;
			}

			if (this.m.Upgrade != null)
			{
				this.m.Upgrade.updateAppearance(app);
			}

			this.getContainer().updateAppearance();
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

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onEquip();
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onUnequip();
		}

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Armor = "";
			app.ArmorUpgradeFront = "";
			app.ArmorUpgradeBack = "";
			app.CorpseArmor = "";
			app.CorpseArmorUpgradeFront = "";
			app.CorpseArmorUpgradeBack = "";
			app.HideBody = false;
			app.ImpactSound[this.Const.BodyPart.Body] = [];
			this.getContainer().updateAppearance();

			if (this.getContainer().getActor() != null && !this.getContainer().getActor().isNull())
			{
				this.getContainer().getActor().resetBloodied();
			}
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties);
		}
	}

	function onDamageReceived( _damage, _fatalityType, _attacker )
	{
		this.item.onDamageReceived(_damage, _fatalityType, _attacker);

		if (this.m.Condition == 0)
		{
			return;
		}

		this.m.Condition = this.Math.max(0, this.m.Condition - _damage) * 1.0;

		if (this.m.Condition == 0 && !this.m.IsIndestructible)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s " + this.getName() + " is hit for [b]" + this.Math.floor(_damage) + "[/b] damage and has been destroyed!");

			if (_attacker != null && _attacker.isPlayerControlled() && !this.getContainer().getActor().isAlliedWithPlayer())
			{
				this.Tactical.Entities.addArmorParts(this.getArmorMax());
			}
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s " + this.getName() + " is hit for [b]" + this.Math.floor(_damage) + "[/b] damage");
		}

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onDamageReceived(_damage, _fatalityType, _attacker);
		}

		this.updateAppearance();
	}

	function onUpdateProperties( _properties )
	{
		if (this.getContainer().getActor() == null)
		{
			return;
		}

		local staminaMult = 1.0;

		if (this.getContainer().getActor().getSkills().hasSkill("perk.brawny"))
		{
			staminaMult = 0.7;
		}

		_properties.Armor[this.Const.BodyPart.Body] += this.m.Condition;
		_properties.ArmorMax[this.Const.BodyPart.Body] += this.m.ConditionMax;
		_properties.Stamina += this.Math.floor(this.m.StaminaModifier * staminaMult);

		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onUpdateProperties(_properties);
		}
	}

	function onTurnStart()
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onTurnStart();
		}
	}

	function onUse( _skill )
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onUse(_skill);
		}
	}

	function onTotalArmorChanged()
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onTotalArmorChanged();
		}
	}

	function onCombatFinished()
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onCombatFinished();
		}
	}

	function onActorDied( _onTile )
	{
		if (this.m.Upgrade != null)
		{
			this.m.Upgrade.onActorDied(_onTile);
		}
	}

	function onSerialize( _out )
	{
		if (this.m.Upgrade != null)
		{
			_out.writeI32(this.m.Upgrade.ClassNameHash);
			this.m.Upgrade.onSerialize(_out);
		}
		else
		{
			_out.writeI32(0);
		}

		this.item.onSerialize(_out);
		_out.writeF32(this.m.ConditionMax);
		_out.writeF32(this.m.StaminaModifier);
	}

	function onDeserialize( _in )
	{
		if (_in.getMetaData().getVersion() >= 36)
		{
			local upgrade = _in.readI32();

			if (upgrade != 0)
			{
				this.m.Upgrade = this.new(this.IO.scriptFilenameByHash(upgrade));
				this.m.Upgrade.setArmor(this);
				this.m.Upgrade.onDeserialize(_in);
			}
		}

		this.item.onDeserialize(_in);

		if (this.m.Upgrade != null)
		{
			this.m.ConditionMax = _in.readF32();

			if (_in.getMetaData().getVersion() >= 40)
			{
				this.m.StaminaModifier = _in.readF32();
			}
		}
		else
		{
			_in.readF32();

			if (_in.getMetaData().getVersion() >= 40)
			{
				_in.readF32();
			}
		}

		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition);
		this.updateVariant();
	}

});

