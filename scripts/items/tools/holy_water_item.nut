this.holy_water_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.holy Water";
		this.m.Name = "Flask of Blessed Water";
		this.m.Description = "A flask filled with water blessed by a man of the gods. Can be thrown at short ranges.";
		this.m.IconLarge = "tools/holy_water_01.png";
		this.m.Icon = "tools/holy_water_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_holy_water_01";
		this.m.Value = 100;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = 0;
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
			id = 64,
			type = "text",
			text = "Worn in Offhand"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] tiles"
		});
		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Damage of [color=" + this.Const.UI.Color.DamageValue + "]20[/color] for [color=" + this.Const.UI.Color.DamageValue + "]3[/color] turns to any undead target hit"
		});
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/direct_damage.png",
			text = "[color=" + this.Const.UI.Color.DamageValue + "]100%[/color] of damage ignores armor"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Has a [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] chance to hit bystanders at the same or lower height level as well."
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Is destroyed on use"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_holy_water");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

