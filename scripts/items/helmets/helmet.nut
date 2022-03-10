this.helmet <- this.inherit("scripts/items/item", {
	m = {
		AddGenericSkill = true,
		ShowOnCharacter = false,
		HideCharacterHead = false,
		HideHair = false,
		HideBeard = false,
		HideCorpseHead = false,
		HideHelmetIfDestroyed = true,
		ReplaceSprite = false,
		Sprite = "",
		SpriteColor = this.createColor("#ffffff"),
		SpriteCorpse = "",
		SpriteDamaged = "",
		VariantString = "helmet",
		ImpactSound = this.Const.Sound.ArmorLeatherImpact,
		InventorySound = this.Const.Sound.ArmorLeatherImpact,
		Armor = 0.0,
		ArmorMax = 0.0,
		StaminaModifier = 0,
		Vision = 0
	},
	function getCondition()
	{
		return this.Math.floor(this.m.Condition);
	}

	function getConditionMax()
	{
		return this.Math.floor(this.m.ConditionMax);
	}

	function setCondition( _a )
	{
		this.m.Condition = _a;
		this.updateAppearance();
	}

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

	function setPlainVariant()
	{
	}

	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function getValue()
	{
		return this.Math.floor(this.m.Value * (this.m.Condition / this.m.ConditionMax));
	}

	function create()
	{
		this.item.create();
		this.m.SlotType = this.Const.ItemSlot.Head;
		this.m.ItemType = this.Const.Items.ItemType.Helmet;
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

		result.push({
			id = 4,
			type = "progressbar",
			icon = "ui/icons/armor_head.png",
			value = this.m.Condition,
			valueMax = this.m.ConditionMax,
			text = "" + this.getArmor() + " / " + this.getArmorMax() + "",
			style = "armor-head-slim"
		});

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] de Fatigue Maximum"
			});
		}

		if (this.m.Vision < 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Vision + "[/color] de Vision"
			});
		}
		else if (this.m.Vision > 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Vision + "[/color] de Vision"
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

		if (this.m.Condition > 15 && isPlayer || this.m.Condition > 30 && this.m.Condition / this.m.ConditionMax >= 0.25 && (isLucky || this.Math.rand(1, 100) <= 70) || !isPlayer && this.isItemType(this.Const.Items.ItemType.Named) || this.isItemType(this.Const.Items.ItemType.Legendary) || isBlacksmithed)
		{
			return true;
		}

		return false;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play(this.m.InventorySound[this.Math.rand(0, this.m.InventorySound.len() - 1)], this.Const.Sound.Volume.Inventory);
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

			if (this.m.Condition == 0 && this.m.HideHelmetIfDestroyed)
			{
				if (app.Helmet != "")
				{
					app.Helmet = "";
					app.HelmetColor = this.createColor("#ffffff");
					app.HelmetDamage = "";
					app.HelmetCorpse = "";
					app.HideHead = false;
					app.HideHair = false;
					app.HideBeard = false;
					app.HideCorpseHead = false;
					this.getContainer().updateAppearance();
				}
			}
			else if (this.m.Condition / this.m.ConditionMax <= this.Const.Combat.ShowDamagedArmorThreshold)
			{
				local changed = false;

				if (this.m.ReplaceSprite && app.Helmet != this.m.SpriteDamaged)
				{
					app.Helmet = this.m.SpriteDamaged;
					app.HelmetDamage = "";
					changed = true;
				}
				else if (!this.m.ReplaceSprite && (app.Helmet != this.m.Sprite || app.HelmetDamage != this.m.SpriteDamaged))
				{
					app.Helmet = this.m.Sprite;
					app.HelmetDamage = this.m.SpriteDamaged;
					changed = true;
				}

				app.HelmetColor = this.m.SpriteColor;
				app.HelmetCorpse = this.m.SpriteCorpse;
				app.HideHead = this.m.HideCharacterHead;
				app.HideHair = this.m.HideHair;
				app.HideBeard = this.m.HideBeard;
				app.HideCorpseHead = this.m.HideCorpseHead;

				if (changed)
				{
					this.getContainer().updateAppearance();
				}
			}
			else if (app.Helmet != this.m.Sprite || app.HelmetDamage != "")
			{
				app.Helmet = this.m.Sprite;
				app.HelmetColor = this.m.SpriteColor;
				app.HelmetDamage = "";
				app.HelmetCorpse = this.m.SpriteCorpse;
				app.HideHead = this.m.HideCharacterHead;
				app.HideHair = this.m.HideHair;
				app.HideBeard = this.m.HideBeard;
				app.HideCorpseHead = this.m.HideCorpseHead;
				this.getContainer().updateAppearance();
			}
		}
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_" + this.m.VariantString + "_" + variant;
		this.m.SpriteDamaged = "bust_" + this.m.VariantString + "_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_" + this.m.VariantString + "_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_" + this.m.VariantString + "_" + variant + ".png";
	}

	function onEquip()
	{
		this.item.onEquip();

		if (this.m.AddGenericSkill)
		{
			this.addGenericItemSkill();
		}

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.ImpactSound[this.Const.BodyPart.Head] = this.m.ImpactSound;
			this.updateAppearance();
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Helmet = "";
			app.HelmetColor = this.createColor("#ffffff");
			app.HelmetDamage = "";
			app.HelmetCorpse = "";
			app.HideHead = false;
			app.HideCorpseHead = false;
			app.HideHair = false;
			app.HideBeard = false;
			app.ImpactSound[this.Const.BodyPart.Head] = [];
			this.getContainer().updateAppearance();
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

			if (_attacker != null && _attacker.isPlayerControlled())
			{
				this.Tactical.Entities.addArmorParts(this.getArmorMax());
			}
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s " + this.getName() + " is hit for [b]" + this.Math.floor(_damage) + "[/b] damage");
		}

		this.updateAppearance();
	}

	function onUpdateProperties( _properties )
	{
		local staminaMult = 1.0;

		if (this.getContainer().getActor().getSkills().hasSkill("perk.brawny"))
		{
			staminaMult = 0.7;
		}

		_properties.Armor[this.Const.BodyPart.Head] += this.m.Condition;
		_properties.ArmorMax[this.Const.BodyPart.Head] += this.m.ConditionMax;
		_properties.Stamina += this.Math.ceil(this.m.StaminaModifier * staminaMult);
		_properties.Vision += this.m.Vision;
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeF32(this.m.Condition);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Condition = this.Math.minf(this.m.ConditionMax, _in.readF32());
		this.updateVariant();
	}

});

