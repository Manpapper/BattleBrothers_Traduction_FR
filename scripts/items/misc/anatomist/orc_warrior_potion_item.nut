this.orc_warrior_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.orc_warrior_potion";
		this.m.Name = "Potion Tête de Fer";
		this.m.Description = "Comme tout vétéran de la Bataille aux Nombreux Noms peut en témoigner, combattre un guerrier orc revient à affronter un véritable mur de métal et de chair, apparemment impénétrable même aux coups les plus débilitants. Avec cette potion, vous pouvez maintenant être ce mur !";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_15.png";
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] de résistance aux effets d'étourdissement, de chancellement, de sonné, de distraction et de flétrissement"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/orc_warrior_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

