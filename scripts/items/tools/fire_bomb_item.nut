this.fire_bomb_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.fire_bomb";
		this.m.Name = "Pot à feu";
		this.m.Description = "Un pot rempli d\'un liquide hautement inflammable qui mettra le feu à une zone lorsqu\'il sera jeté.";
		this.m.IconLarge = "tools/fire_pot_01.png";
		this.m.Icon = "tools/fire_pot_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_fire_bomb_01";
		this.m.Value = 600;
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
			text = "Porté dans la main gauche "
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Porté de [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] tuiles"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Mettra [color=" + this.Const.UI.Color.DamageValue + "]7[/color] tuiles enflammé d\'un feu brûlant pendant 2 tours"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Est détruit à l\'utilisation"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/move_pot_clay_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_fire_bomb_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

