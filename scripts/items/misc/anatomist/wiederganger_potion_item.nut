this.wiederganger_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.wiederganger_potion";
		this.m.Name = "Potion Peau de Cuir";
		this.m.Description = "Lorsqu'elle est consommée, cette puissante concoction modifie la chair pour réagir immédiatement aux coups soudains, protégeant le corps contre les blessures graves ! N'y prêtez pas attention à l'odeur, c'est juste un signe de sa puissance.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_22.png";
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
			text = "Le seuil pour subir des blessures en cas de coup est augmenté de [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color]"
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
			text = "Mutile le corps, provoquant une maladie"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/wiederganger_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

