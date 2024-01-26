this.goblin_grunt_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.goblin_grunt_potion";
		this.m.Name = "Potion de Pied Léger";
		this.m.Description = "Développée à partir de substances trouvées sur les troupes de première ligne gobelines, cette concoction peut conférer à un homme la célérité généralement observée chez les petits Peaux-Vertes. Peut entraîner une légère décoloration de la peau.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_11.png";
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
			icon = "ui/icons/action_points.png",
			text = "Les coûts en Points d'Action des compétences Rotation et Footwork sont réduits à [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Les coûts en Fatigue des compétences Rotation et Footwork sont réduits de [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/goblin_grunt_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

