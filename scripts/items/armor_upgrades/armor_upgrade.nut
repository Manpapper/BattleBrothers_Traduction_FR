this.armor_upgrade <- this.inherit("scripts/items/item", {
	m = {
		OverlayIcon = "",
		OverlayIconLarge = "",
		SpriteFront = null,
		SpriteBack = null,
		SpriteDamagedFront = null,
		SpriteDamagedBack = null,
		SpriteCorpseFront = null,
		SpriteCorpseBack = null,
		ArmorDescription = "",
		Armor = null,
		ConditionModifier = 0,
		StaminaModifier = 0,
		PreviousCondition = 0,
		PreviousStamina = 0
	},
	function getOverlayIcon()
	{
		return this.m.OverlayIcon;
	}

	function getOverlayIconLarge()
	{
		return this.m.OverlayIconLarge;
	}

	function isUsed()
	{
		return this.m.Armor != null;
	}

	function getArmor()
	{
		return this.m.Armor;
	}

	function setArmor( _a )
	{
		this.m.Armor = this.WeakTableRef(_a);
	}

	function getArmorDescription()
	{
		return this.m.ArmorDescription;
	}

	function create()
	{
		this.item.create();
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
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
			id = 65,
			type = "text",
			text = "Right-click or drag onto an armor carried by the currently selected character in order to permanently fuse. This item will be consumed in the process to give the following effects:"
		});
		return result;
	}

	function getArmorTooltip( _result )
	{
		this.onArmorTooltip(_result);
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/plus.png",
			text = "Has an armor attachment which can be replaced, but will be destroyed in the process"
		});
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function updateAppearance( _app )
	{
		if (this.m.Armor.m.Condition / this.m.Armor.m.ConditionMax <= this.Const.Combat.ShowDamagedArmorThreshold)
		{
			_app.ArmorUpgradeFront = this.m.SpriteDamagedFront != null ? this.m.SpriteDamagedFront : this.m.SpriteFront != null ? this.m.SpriteFront : "";
			_app.ArmorUpgradeBack = this.m.SpriteDamagedBack != null ? this.m.SpriteDamagedBack : this.m.SpriteBack != null ? this.m.SpriteBack : "";
		}
		else
		{
			_app.ArmorUpgradeFront = this.m.SpriteFront != null ? this.m.SpriteFront : "";
			_app.ArmorUpgradeBack = this.m.SpriteBack != null ? this.m.SpriteBack : "";
		}

		_app.CorpseArmorUpgradeFront = this.m.SpriteCorpseFront != null ? this.m.SpriteCorpseFront : "";
		_app.CorpseArmorUpgradeBack = this.m.SpriteCorpseBack ? this.m.SpriteCorpseBack : "";
	}

	function onAdded()
	{
		this.m.PreviousCondition = this.m.Armor.m.ConditionMax;
		this.m.PreviousStamina = this.m.Armor.m.StaminaModifier;
		this.m.Armor.m.ConditionMax += this.m.ConditionModifier;
		this.m.Armor.m.Condition += this.m.ConditionModifier;
		this.m.Armor.m.StaminaModifier -= this.m.StaminaModifier;
	}

	function onRemoved()
	{
		this.m.Armor.m.ConditionMax = this.m.PreviousCondition;
		this.m.Armor.m.Condition = this.Math.minf(this.m.Armor.m.Condition, this.m.Armor.m.ConditionMax);
		this.m.Armor.m.StaminaModifier = this.m.PreviousStamina;
		this.m.PreviousCondition = 0;
		this.m.PreviousStamina = 0;
	}

	function onUse( _actor, _item = null )
	{
		if (this.isUsed())
		{
			return false;
		}

		local armor = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body) : _item;

		if (armor == null)
		{
			return false;
		}

		this.Sound.play("sounds/inventory/armor_upgrade_use_01.wav", this.Const.Sound.Volume.Inventory);
		armor.setUpgrade(this);
		return true;
	}

	function onArmorTooltip( _result )
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeF32(this.m.PreviousCondition);
		_out.writeI16(this.m.PreviousStamina);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 44)
		{
			this.m.PreviousCondition = _in.readF32();
			this.m.PreviousStamina = _in.readI16();
		}
	}

});

