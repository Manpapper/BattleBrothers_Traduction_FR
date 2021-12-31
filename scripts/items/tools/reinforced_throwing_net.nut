this.reinforced_throwing_net <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "tool.reinforced_throwing_net";
		this.m.Name = "Filet de lancer renforcé";
		this.m.Description = "Un filet utilisé pour jeter par-dessus une cible afin d\'entraver sa capacité à se déplacer et à se défendre efficacement. Renforcé d\'une toile tiré d\'une webknecht, il est encore plus difficile de s\'en libérer.";
		this.m.IconLarge = "tools/inventory_throwing_net_02.png";
		this.m.Icon = "tools/throwing_net_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_throwing_net_02";
		this.m.Value = 150;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = -2;
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
			text = "Porté dans la main gauche"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Porté de [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] tuiles"
		});

		if (this.m.StaminaModifier < 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color] Fatigue Maximum"
			});
		}

		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Immobilisera une cible sur place et réduira ses défenses"
		});
		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Est détruit à l\'utilisation"
		});
		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "La chance de se libérer est réduite de [color=" + this.Const.UI.Color.NegativeValue + "]-15[/color]"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_net");
		skill.setReinforced(true);
		this.addSkill(skill);
	}

});

