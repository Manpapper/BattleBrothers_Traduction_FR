this.accessory <- this.inherit("scripts/items/item", {
	m = {
		StaminaModifier = 0,
		AddGenericSkill = true,
		ShowOnCharacter = false,
		Sprite = null,
		SpriteCorpse = null
	},
	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function create()
	{
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
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

		if (this.m.SlotType == this.Const.ItemSlot.Accessory)
		{
			result.push({
				id = 64,
				type = "text",
				text = "Worn in Accessory Slot"
			});
		}
		else
		{
			result.push({
				id = 64,
				type = "text",
				text = "Carried in Bag"
			});
		}

		result.push({
			id = 65,
			type = "text",
			text = "Usable in Combat"
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

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});
		}

		return result;
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
			app.Accessory = this.m.Sprite;
			this.getContainer().updateAppearance();
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Accessory = "";
			this.getContainer().updateAppearance();
		}
	}

	function onUpdateProperties( _properties )
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.updateVariant();
	}

});

