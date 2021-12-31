this.acid_flask_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.acid_flask";
		this.m.Name = "Fiole d\'acide";
		this.m.Description = "Une fiole remplie du concentré de sang acide d\'un Lindwurm. Il est très corrosif pour de nombreux matériaux et brûle rapidement à travers les armures. Peut être lancé à courte distance.";
		this.m.IconLarge = "tools/acid_flask_01.png";
		this.m.Icon = "tools/acid_flask_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_acid_flask_01";
		this.m.Value = 400;
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
			text = "Porté dans la main gauche"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Portée de [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] tuiles"
		});
		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Réduit l\'armure de la cible de [color=" + this.Const.UI.Color.DamageValue + "]20%[/color] chaque tour pendant 3 tours"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "A [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] de chance de toucher des adversaires adjacents au même niveau ou à un niveau inférieur"
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
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_acid_flask");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

