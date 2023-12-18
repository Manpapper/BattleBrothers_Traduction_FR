this.goblin_overseer_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.goblin_overseer_potion";
		this.m.Name = "Breuvage du Tireur d'Élite";
		this.m.Description = "À parts égales terrifiant et ennuyeux, le tir infaillible des gobelins de la caste supérieure a longtemps été considéré comme inaccessible pour les humains ordinaires respectueux d'eux-mêmes. Cependant, avec cette potion merveilleuse, le guerrier averti peut exploiter une partie de cette compétence latente pour lui-même à un coût cosmétique mineur !";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_13.png";
		this.m.Value = 0;
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
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Un [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] supplémentaire des dégâts ignore l'armure lors de l'utilisation d'arcs ou d'arbalètes"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Cliquez avec le bouton droit ou faites glisser sur le personnage actuellement sélectionné pour boire. Cet objet sera consommé dans le processus."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Mutile le corps, provoquant la maladie"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/goblin_overseer_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

